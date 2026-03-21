vim() {
    if [[ $# -eq 0 ]]; then
        nvim .
    else
        nvim "$@"
    fi
}
alias lsd="lsd -1X"
alias zshconfig="vim ~/.zshrc"
alias oc="opencode"

# macOS-only
if [[ "$OSTYPE" == darwin* ]]; then
  alias fdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
fi

