## ⛔ ABSOLUTE PRIORITIES - READ FIRST

### Search: prefer rg over grep

Always use `rg` as primary search tool. Only fall back to `grep` for plain text/comments.

### Visual verification: MANDATORY for all UI changes

When ANY task touches Tailwind classes, color values, CSS, component layout, styling, or UI/UX:

1. **Before** making changes: take a screenshot of the affected page/component in Chrome (use `mcp__claude-in-chrome` or `mcp__chrome-devtools` tools) so you have a baseline
2. Make the code changes — all color and contrast choices **must** follow WCAG 2.1 AA guidelines:
   - Normal text: minimum 4.5:1 contrast ratio against its background
   - Large text (18px+ bold or 24px+): minimum 3:1 contrast ratio
   - Interactive elements and focus indicators: minimum 3:1 contrast ratio against adjacent colors
   - Never rely on color alone to convey meaning — pair with icons, text, or patterns
3. **After** changes: take another screenshot of the same page/component
4. Compare before vs after — confirm the change looks correct, has no visual regressions, and meets contrast requirements
5. If something looks wrong or contrast is insufficient, fix it and re-screenshot until it's right

**Do not consider the task complete until you have visually verified the result in Chrome and confirmed WCAG AA contrast compliance.**

### Documentation: always ask first

After completing any code change, **ask the user** if they want a markdown document generated. Offer these specific options:

- **Architecture overview** — component relationships, dependencies, design decisions
- **Data flow** — how data moves through the changed system (inputs → transforms → outputs)
- **Implementation details** — key logic, algorithms, edge cases, and why things were done a certain way
- **API reference** — new or changed function signatures, props, hooks, or endpoints
- **Migration guide** — if the change is breaking or requires other code to update

Do NOT create documentation files automatically — always wait for explicit approval. If the user declines, move on without creating any docs.

**Placement:** Create docs in a `docs/` directory at the root of the affected package, app, or project. If the project is a monorepo, place docs in the specific sub-package that was changed. If placement is unclear, **ask the user**.
