# ── Environment (instant: no I/O, no subshells) ──────────────
export ZSH="$HOME/.oh-my-zsh"
export PYENV_ROOT="$HOME/.pyenv"
export BUN_INSTALL="$HOME/.bun"

# ── PATH (instant: zsh array manipulation) ───────────────────
command -v pyenv >/dev/null || path=("$PYENV_ROOT/bin" $path)
path=(
  "$HOME/go/bin"
  "$HOME/.opencode/bin"
  "$HOME/.antigravity/antigravity/bin"
  "$HOME/.cargo/bin"
  "$BUN_INSTALL/bin"
  $path
)
export PATH

# ── Completions (built-in zsh git completion) ────────────────
autoload -Uz compinit && compinit

# ── Sources (file I/O only, no subshells) ────────────────────
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
[[ -f "$HOME/aliases.sh" ]] && source "$HOME/aliases.sh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ── Evals (subshell spawns, slowest — keep last) ─────────────
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(starship init zsh)"

# ── Local overrides (secrets, machine-specific exports) ───────
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
