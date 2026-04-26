# Dotfiles Repo

Chezmoi-managed dotfiles targeting macOS (host) and devcontainers. Single source, dual target.

## Chezmoi conventions

| Pattern | Deploys to |
|---|---|
| `dot_foo` | `~/.foo` |
| `dot_config/` | `~/.config/` |
| `*.tmpl` | Processed as Go templates (use `{{ if eq .chezmoi.os "darwin" }}` for platform conditionals) |
| `run_once_*` | Runs once on first `chezmoi apply` |
| `run_onchange_*` | Re-runs whenever the file content changes |

Files in `.chezmoiignore` (`README.md`, `Brewfile`, `install.sh`, `scripts/`, `CLAUDE.md`) are not deployed to `~/`.

## CRITICAL: Never edit Brewfile or dot_config/mise/config.toml directly

Both are generated from `tools.yaml` by CI. To add/remove tools:
1. Edit `tools.yaml` — `shared:` for tools needed everywhere (mise in devcontainers + brew on mac), `host.formulas:` / `host.casks:` for mac-only
2. Push to main — CI generates and commits `Brewfile` and `dot_config/mise/config.toml` automatically

Tool name mapping exceptions (handled by CI): `delta` → `git-delta`, `rg` → `ripgrep`.

## Shared vs host-only tools (`tools.yaml`)

- `shared:` — tools needed everywhere (neovim, node, bat, fd, etc.)
- `host.formulas:` — mac-only brew formulas
- `host.casks:` — mac-only GUI apps

## Shell config (`dot_config/bash/`)

- `aliases.bash` — all aliases and functions
- `env.bash` — environment variables
- `integrations.bash` — shell integrations (mise, starship, zoxide, sesh, yq completions)

**Key aliases:** `cm` = chezmoi, `cm-sync` = chezmoi update, `sb` = source ~/.bashrc, `k` = kubectl

## Television (tv) picker functions

Shell functions in `aliases.bash` with multi-action `--expect` keybindings:

| function | channel | enter | ctrl-s | ctrl-v | ctrl-r | ctrl-p | ctrl-d | ctrl-l | ctrl-t |
|---|---|---|---|---|---|---|---|---|---|
| `ff` | files | nvim | tmux split ↓ | tmux split → | | | | | |
| `fa` | files-hidden | nvim | tmux split ↓ | tmux split → | | | | | |
| `fo` | podman-images | run bash | run sh | | run -d | pull | rmi | | |
| `fc` | podman-containers | exec bash | exec sh | | restart | | rm -f | logs -f | stop |
| `fe` | env | (tv native) | | | | | | | |

**Rule:** `ctrl-y` (yank to clipboard) is handled natively by tv — never add it to `--expect` in bash or to handlers in tv.nvim.

Custom cables live in `dot_config/television/cable/`: `files-hidden`, `git-log`, `podman-images`, `podman-containers`, `tldr`.

Run `ff --help` (or any picker `--help`) to print the keybinding cheatsheet.

## Neovim (`dot_config/nvim/`)

Plugin manager: **mini.deps** — use `MiniDeps.add(source)` wrapped in `later(function() ... end)`.

Plugins are split by concern in `lua/plugins/`:

| file | contents |
|---|---|
| `navigation.lua` | tv.nvim (`<leader>ff/fa/fg/fs/fo/fc/fe`), oil.nvim, harpoon |
| `lsp.lua` | blink.cmp, mason + mason-lspconfig, telescope (LSP pickers only: gR/gd/gi/gt/`<leader>d`) |
| `ui.lua` | Colorscheme, statusline, etc. |
| `editing.lua` | Text editing plugins |
| `formatting.lua` | Formatters |
| `diagnostics.lua` | Diagnostic display |
| `git.lua` | Git plugins |
| `workflow.lua` | Productivity plugins |

tv.nvim channels mirror the bash functions (`<leader>fo` = podman-images, `<leader>fc` = podman-containers). Interactive podman commands use `vim.cmd('terminal ...')`, non-interactive use `vim.fn.jobstart(...)`.

## Tmux (`dot_config/tmux/tmux.conf`)

- Prefix: `C-a`
- Splits: `prefix + -` (horizontal/down), `prefix + |` (vertical/right)
- Pane nav: `C-h/j/k/l` (vim-tmux-navigator aware)
- Session picker: `prefix + s` → tv sesh popup

## Aerospace (`dot_config/aerospace/aerospace.toml`)

macOS tiling WM. Named workspaces: `T` (terminal), `B` (browser), `M` (music), `S` (slack), `O` (obsidian), `E` (email).

## Commit conventions

Conventional commits: `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`

## Applying changes

```bash
chezmoi diff          # preview what would change
chezmoi apply         # deploy to ~/
source ~/.bashrc      # reload shell config
```
