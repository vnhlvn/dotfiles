# ── Environment (instant: no I/O, no subshells) ──────────────
export ZSH="$HOME/.oh-my-zsh"
export PYENV_ROOT="$HOME/.pyenv"
export BUN_INSTALL="$HOME/.bun"
export AWS_PROFILE=amplify-learning-dev
export YARN_NM_MODE=hardlinks-global
export YARN_ENABLE_GLOBAL_CACHE=true

export LITELLM_PROXY_BASE_URL=https://amplify-llm-gateway-devci.poc.learning.amplify.com
export LITELLM_PROXY_API_KEY="${LITELLM_PROXY_API_KEY:-}"

export ANTHROPIC_API_KEY=$LITELLM_PROXY_API_KEY
export ANTHROPIC_BASE_URL="$LITELLM_PROXY_BASE_URL/anthropic"

# ── PATH (instant: zsh array manipulation) ───────────────────
command -v pyenv >/dev/null || path=("$PYENV_ROOT/bin" $path)
path=(
  "$HOME/.opencode/bin"
  "$HOME/.antigravity/antigravity/bin"
  "$HOME/.cargo/bin"
  "$BUN_INSTALL/bin"
  $path
)
export PATH

# ── Oh My Zsh (disabled — using built-in zsh completions instead) ──
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# DISABLE_AUTO_TITLE="true"
# DISABLE_AUTO_UPDATE="true"
# plugins=(git)
# source "$ZSH/oh-my-zsh.sh"

# ── Completions (built-in zsh git completion) ────────────────
autoload -Uz compinit && compinit

# ── Sources (file I/O only, no subshells) ────────────────────
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source "$HOME/aliases.sh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ── Evals (subshell spawns, slowest — keep last) ─────────────
eval "$(fnm env --use-on-cd --shell zsh)"
eval "$(starship init zsh)"

# bun completions
[ -s "/Users/iholovi/.bun/_bun" ] && source "/Users/iholovi/.bun/_bun"
