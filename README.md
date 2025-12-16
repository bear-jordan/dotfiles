# Overview

1. run the setup script to pull your dotfiles

```bash
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://downloads.1password.com/linux/keys/1password.asc" > /etc/yum.repos.d/1password.repo'

sudo rpm-ostree install \
    libfido2 \
    tmux \
    1password \
    1password-cli

reboot
```
