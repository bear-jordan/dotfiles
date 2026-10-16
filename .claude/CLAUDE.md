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

- `shared:` — tools needed everywhere, including dev containers via mise (neovim, bat, fd, etc.). Never list a tool a repo's dev image pins (tflint, terraform, trivy) — mise would shadow the pinned binary in interactive shells.
- `container:` — dev containers only, via mise (zig, the C compiler tree-sitter builds parsers with; macOS has clang)
- `host.formulas:` — mac-only brew formulas
- `host.casks:` — mac-only GUI apps

## Shell config (`dot_config/shell/`)

Supports both bash and zsh. Both `dot_bashrc` and `dot_zshrc` source `~/.config/shell/*.sh`. Shell-specific behavior uses `$BASH_VERSION` / `$ZSH_VERSION` guards.

- `aliases.sh` — all aliases and functions
- `env.sh` — environment variables
- `integrations.sh` — shell integrations (mise, starship, zoxide, yq completions)

**Key aliases:** `cm` = chezmoi, `cm-sync` = chezmoi update, `sb` = source rc file, `k` = kubectl

## Television (tv) picker functions

Shell functions in `aliases.sh` with multi-action `--expect` keybindings:

| function | channel | enter | ctrl-s | ctrl-v | ctrl-r | ctrl-p | ctrl-d | ctrl-l | ctrl-t |
|---|---|---|---|---|---|---|---|---|---|
| `ff` | files | nvim | | | | | | | |
| `fa` | files-hidden | nvim | | | | | | | |
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

tv.nvim channels mirror the shell functions (`<leader>fo` = podman-images, `<leader>fc` = podman-containers). Interactive podman commands use `vim.cmd('terminal ...')`, non-interactive use `vim.fn.jobstart(...)`.

## Herdr (`dot_config/herdr/config.toml`)

Agent-aware terminal multiplexer. Ghostty starts it on every new window through
`~/.local/bin/herdr-shell`; `touch ~/.config/herdr/no-autostart` gets a plain shell instead. The config is
`herdr --default-config` with the bindings below uncommented; everything else runs on defaults.
`hr` reloads it (`herdr server reload-config`), `herdr config check` validates it; startup-only
settings need `herdr server stop` and a fresh `herdr`. Key names are literal characters
(`prefix+|`, `prefix+[`), not names like `pipe`.

- `herdr` attaches to the default background session, starting it if needed. `prefix+q`
  detaches and agents keep running.
- Prefix: `C-a`. Splits: `prefix + |` (right), `prefix + -` (down). Tabs: `prefix + c` / `n` /
  `p`. Workspaces: `prefix + j/k` next/previous, `prefix + s` picker (`j/k` workspaces,
  `J/K` panes), new `prefix + N`. Agents: `prefix + J/K` next/previous. `prefix + o` opens
  the latest toast's agent. Settings: `prefix + S`. All bindings: `prefix + ?`.
- Panes: `C-h/j/k/l` move across herdr panes and nvim splits as one (vim-herdr-navigation,
  installed at a pinned commit by `run_onchange_after_herdr-plugins.sh.tmpl`; the nvim half is
  in `workflow.lua`). This shadows readline's `C-l` and `C-k` in shells. Option-h/j/k/l
  belongs to AeroSpace, so herdr never sees it. `prefix + l` jumps to the last pane.
- Copy mode: `prefix + [`, vi motions, `/` search, `v` select, `y` copy, `q` exit.
- The sidebar tracks `claude`, `codex` and `pi` panes as working / blocked / done / idle.

## Aerospace (`dot_config/aerospace/aerospace.toml`)

macOS tiling WM. Named workspaces: `T` (terminal), `B` (browser), `M` (music), `S` (slack), `O` (obsidian), `E` (email).

## Commit conventions

Conventional commits: `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`

## Applying changes

```bash
chezmoi diff          # preview what would change
chezmoi apply         # deploy to ~/
source ~/.bashrc      # reload shell config (or ~/.zshrc)
```
