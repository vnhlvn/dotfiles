# dotfiles

Portable dotfiles for macOS and Linux (Omarchy/Hypr, Ubuntu/i3).

## Quick start

```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
make install
```

`install` will automatically generate git configs from 1Password if `op` is on PATH. If not, it skips gracefully — run `make gitconfig` later.

## Commands

```bash
make install       # link dotfiles + generate git configs
make sync          # copy machine overrides back into repo
make status        # show link state and drift
make list          # print active manifest entries
make gitconfig     # generate git configs from 1Password
```

All commands support `--dry-run`, `--force`, `--no-backup`, `--quiet`:

```bash
./scripts/dotfiles install --dry-run
./scripts/dotfiles install --no-backup --force
```

## Manifest

`dotfiles.manifest` maps repo paths to home directory targets:

```text
source|target|os|mode
```

- `os`: `all`, `macos`, or `linux`
- `mode`: `both`, `install`, or `sync`

## Notes

- Machine-specific env vars and secrets go in `~/.zshrc.local` (gitignored).
- Tmux status uses `~/weather.sh` and `~/btc.sh` with 10-minute caches.
- `install` backs up existing targets to `*.bak.<timestamp>` before linking.
