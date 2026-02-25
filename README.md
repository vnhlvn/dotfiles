# dotfiles

Portable dotfiles for macOS and Linux with a manifest-driven installer.

## What changed

- Single installer: `./install.sh` or `make install`
- Single sync-back flow: `./sync.sh` or `make sync`
- OS-aware mapping in `dotfiles.manifest`
- Status report for drift/overrides: `./status.sh` or `make status`

## Quick start on a new machine

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Optional: pull nested theme repo if present
git submodule update --init --recursive

# Optional: generate git configs from 1Password template values
make gitconfig

# Link everything declared in manifest
make install
```

## Daily workflow

```bash
# See what is linked vs overridden
make status

# If you changed files directly in ~ or ~/.config, import them back into repo
make sync
```

Then commit repo changes.

## Manifest format

`dotfiles.manifest` lines are:

```text
source|target|os|mode
```

- `source`: path inside this repository
- `target`: path on machine (`~` supported)
- `os`: `all`, `macos`, or `linux`
- `mode`: `both`, `install`, or `sync`

Example:

```text
zsh/.zshrc|~/.zshrc|all|both
picom/picom.conf|~/.config/picom/picom.conf|linux|both
```

## Commands

- `make install` / `./install.sh`: symlink files from repo to home directory
- `make sync` / `./sync.sh`: copy machine overrides back into repo
- `make status` / `./status.sh`: show link and drift state
- `make list`: print active manifest entries
- `make gitconfig`: generate `git/dist/.gitconfig*`

## Safety behavior

- `install` backs up existing targets to `*.bak.<timestamp>` before linking
- Use `--dry-run` to preview operations
- Use `--no-backup --force` if you want destructive replacement

Examples:

```bash
./scripts/dotfiles install --dry-run
./scripts/dotfiles install --no-backup --force
./scripts/dotfiles sync --dry-run
```

## Notes

- Old per-directory scripts (like `tmux/symlink.sh`) are legacy and can be removed later.
- Keep secrets out of tracked files. Prefer local environment exports or secret managers.
