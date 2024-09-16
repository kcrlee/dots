# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:[directory]"
export PATH="$PATH:/home/kyle/.local/share/bob/nvim-bin"
export PATH="$PATH:/usr/local/Bitcoin/bin"
export PATH="$PATH:/usr/local/lib/pkgconfig"
export PATH="$PATH:/home/kyle/libbitcoin"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:/home/kyle/.local/bin"
export PATH="$HOME/.amplify/bin:$PATH"
export SUDO_EDITOR="$HOME/.local/share/bob/nvim-bin/nvim"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fzf key bindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# TO ADD TO STUDENTS BASHRC
export BLOCKCHAIN='testnet'
alias btcdir="cd ~/.bitcoin/" #linux default bitcoind path
alias bitc='/usr/local/Bitcoin/bin/bitcoin-cli -${BLOCKCHAIN} '
alias bitd='/usr/local/Bitcoin/bin/bitcoind -${BLOCKCHAIN} -printtoconsole '
alias bitd-MAINNET='/usr/local/Bitcoin/bin/bitcoind -mainnet -conf=~/.bitcoin/bitcoin.MAINNET.conf -printtoconsole '
alias bitc-MAINNET='/usr/local/Bitcoin/bin/bitcoin-cli -mainnet -conf=~/.bitcoin/bitcoin.MAINNET.conf '
alias btcinfo='bitcoin-cli -${BLOCKCHAIN} getwalletinfo | egrep "\"balance\""; bitcoin-cli -${BLOCKCHAIN} getnetworkinfo | egrep "\"version\"|connections"; bitcoin-cli -${BLOCKCHAIN} getmininginfo | egrep "\"blocks\"|errors"'
alias btcblock="echo \`bitcoin-cli -testnet getblockcount 2>&1\`/\`wget -O - http://blockexplorer.com/testnet/q/getblockcount 2> /dev/null | cut -d : -f2 | rev | cut -c 2- | rev\`"

# pnpm
export PNPM_HOME="/home/kyle/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

function osc7-pwd() {
    emulate -L zsh # also sets localoptions for us
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}

function chpwd-osc7-pwd() {
    (( ZSH_SUBSHELL )) || osc7-pwd
}
add-zsh-hook -Uz chpwd chpwd-osc7-pwd


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# Added by Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"
