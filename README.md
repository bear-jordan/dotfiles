# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io).

## Bootstrap

```bash
git clone git@github.com:bear-jordan/dotfiles.git ~/personal/dotfiles
~/personal/dotfiles/install.sh
```

`install.sh` installs chezmoi, applies dotfiles, installs mise, and runs `mise install` to provision dev tools.

## Sync

After initial setup, pull and re-apply changes:

```bash
cm-sync
```

## Host-only installs

The following run only on macOS and are skipped in devcontainers:

- **Homebrew** — installed via `run_once_install-homebrew.sh.tmpl`
- **Brewfile** — casks and formulae applied via `run_onchange_brew-bundle.sh.tmpl`

## Devcontainers

Set the Dotfiles Repository in DevPod settings to `github.com/bear-jordan/dotfiles`. DevPod will clone the repo and run `install.sh` automatically on workspace creation.
