.PHONY: install install-dry sync sync-dry status list gitconfig

install:
	./scripts/dotfiles install

install-dry:
	./scripts/dotfiles install --dry-run

sync:
	./scripts/dotfiles sync

sync-dry:
	./scripts/dotfiles sync --dry-run

status:
	./scripts/dotfiles status

list:
	./scripts/dotfiles list

gitconfig:
	cd git && bun install && bun run gitconfig.js
