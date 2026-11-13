#!/usr/bin/env python3
"""Wake ajax-iii with Wake-on-LAN, unlock its desktop, and report the result.

Usage:  sudo python3 wake_on_lan_server.py [--timeout SECONDS] [--no-unlock]

Exit code 0 = machine is awake (and unlocked, unless --no-unlock),
          1 = it isn't awake, 2 = it's awake but the unlock failed
          (reason printed in both failure cases).
"""
import argparse
import os
import shutil
import subprocess
import sys
import time

# ajax-iii's enp69s0 port, cabled directly to this Pi's eth0. It is the port
# with Wake-on-LAN enabled (eno1, ...:78, has PCI wakeup disabled).
MAC_ADDRESS = "74:56:3c:bb:f9:79"

# Addresses that answer once ajax-iii is up. The .local name resolves via mDNS
# over the direct cable, so it works even if the home Wi-Fi/DHCP changes; the
# LAN IP is a fallback in case mDNS is slow to come up after boot.
CHECK_HOSTS = ("ajax-iii.local", "192.168.1.152")

ETHERWAKE = "/usr/sbin/etherwake"
RETRY_INTERVAL = 10    # seconds between wake attempts
DEFAULT_TIMEOUT = 120  # give up after this many seconds

# Unlocking: ajax-iii's COSMIC lock screen (cosmic-greeter) is dismissed when
# logind sends the session an Unlock signal. This key is accepted on ajax-iii
# only with a forced command in its authorized_keys, so all it can do is run
#   loginctl unlock-session <kyle's graphical session>
# Whatever command we send is ignored. Paths are absolute because this script
# runs under sudo, where ~ would be /root.
UNLOCK_USER = "kyle"
UNLOCK_KEY = "/home/kyle/.ssh/ajax_unlock_ed25519"
UNLOCK_KNOWN_HOSTS = "/home/kyle/.ssh/ajax_known_hosts"  # pins ajax-iii's host key
UNLOCK_TIMEOUT = 60    # sshd can lag a few seconds behind ping after resume
UNLOCK_RETRY = 5


def fail(message, code=1):
    print(f"FAILED: {message}", file=sys.stderr)
    sys.exit(code)


def unlock(host):
    """Unlock ajax-iii's desktop over SSH, retrying while sshd comes up.

    Return None on success, else the last error message.
    """
    command = [
        "ssh",
        "-o", "BatchMode=yes",
        "-o", "ConnectTimeout=5",
        "-o", "IdentitiesOnly=yes",
        "-i", UNLOCK_KEY,
        # The host key is pinned under one alias, so .local and the LAN IP
        # are both checked against the same entry.
        "-o", f"UserKnownHostsFile={UNLOCK_KNOWN_HOSTS}",
        "-o", "HostKeyAlias=ajax-iii",
        "-o", "StrictHostKeyChecking=yes",
        "-o", "CheckHostIP=no",
        f"{UNLOCK_USER}@{host}",
    ]
    deadline = time.monotonic() + UNLOCK_TIMEOUT
    while True:
        result = subprocess.run(command, capture_output=True, text=True,
                                stdin=subprocess.DEVNULL)
        if result.returncode == 0:
            return None
        error = (result.stderr or result.stdout).strip() or f"exit code {result.returncode}"
        if time.monotonic() >= deadline:
            return error
        time.sleep(UNLOCK_RETRY)


def unlock_or_fail(host, enabled):
    if not enabled:
        return
    print(f"Unlocking ajax-iii's desktop via {host}...")
    error = unlock(host)
    if error:
        fail(f"ajax-iii is awake but the unlock failed: {error}", code=2)
    print("SUCCESS: ajax-iii's desktop is unlocked.")


def alive_host():
    """Return the first host in CHECK_HOSTS that answers a ping, else None."""
    for host in CHECK_HOSTS:
        if subprocess.call(
            ["ping", "-c", "1", "-W", "2", host],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ) == 0:
            return host
    return None


def active_interfaces():
    """Every physical interface that is up (e.g. eth0, wlan0).

    A NIC only reacts to a magic packet carrying its own MAC, so the packet
    has to leave on the interface that reaches that NIC. Rather than guess
    (etherwake defaults to eth0), broadcast on all of them; a stray magic
    packet is harmless.
    """
    names = []
    for name in sorted(os.listdir("/sys/class/net")):
        if name == "lo" or name.startswith(("tailscale", "docker", "veth", "br-")):
            continue
        try:
            with open(f"/sys/class/net/{name}/operstate") as f:
                if f.read().strip() == "up":
                    names.append(name)
        except OSError:
            pass
    return names


def send_magic_packet(interfaces):
    """Run etherwake on each interface; return an error message, or None."""
    for iface in interfaces:
        result = subprocess.run(
            [ETHERWAKE, "-i", iface, "-b", MAC_ADDRESS],
            capture_output=True, text=True,
        )
        if result.returncode != 0:
            detail = (result.stderr or result.stdout).strip() or f"exit code {result.returncode}"
            return f"etherwake on {iface} failed: {detail}"
    return None


def main():
    # Print each line immediately, so progress and FAILED/SUCCESS lines stay
    # in order even when output is piped or captured by a log.
    sys.stdout.reconfigure(line_buffering=True)

    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "--timeout", type=int, default=DEFAULT_TIMEOUT,
        help=f"seconds to wait for the machine to come up (default {DEFAULT_TIMEOUT})",
    )
    parser.add_argument(
        "--no-unlock", dest="unlock", action="store_false",
        help="only wake the machine; leave the lock screen up",
    )
    args = parser.parse_args()
    timeout = args.timeout

    # --- Preflight: catch the things that make a wake silently impossible ---
    if os.geteuid() != 0:
        fail("etherwake must run as root. Re-run with: sudo python3 "
             + os.path.basename(sys.argv[0]))
    if not shutil.which(ETHERWAKE):
        fail(f"{ETHERWAKE} not found. Install it with: sudo apt install etherwake")
    if args.unlock and not os.path.isfile(UNLOCK_KEY):
        fail(f"unlock key {UNLOCK_KEY} is missing. Re-run with --no-unlock to only wake.")

    host = alive_host()
    if host:
        print(f"ajax-iii is already awake ({host} answers).")
        unlock_or_fail(host, args.unlock)
        return

    interfaces = active_interfaces()
    if not interfaces:
        fail("no network interface is up on this Pi, so a magic packet can't be sent.")

    print(f"Waking {MAC_ADDRESS} via {', '.join(interfaces)}; "
          f"waiting up to {timeout}s for {' or '.join(CHECK_HOSTS)}...")

    started = time.monotonic()
    attempts = 0
    while True:
        error = send_magic_packet(interfaces)
        if error:
            fail(error)
        attempts += 1

        time.sleep(RETRY_INTERVAL)

        host = alive_host()
        if host:
            elapsed = int(time.monotonic() - started)
            print(f"SUCCESS: ajax-iii woke up after {elapsed}s ({host} answers; "
                  f"{attempts} magic packet{'s' if attempts != 1 else ''} sent).")
            unlock_or_fail(host, args.unlock)
            return

        if time.monotonic() - started >= timeout:
            fail(f"ajax-iii did not respond within {timeout}s "
                 f"({attempts} magic packets sent on {', '.join(interfaces)}). "
                 f"Check that it is plugged in and that Wake-on-LAN is still enabled "
                 f"for MAC {MAC_ADDRESS}.")


if __name__ == "__main__":
    main()
