vim() {
    if [[ $# -eq 0 ]]; then
        nvim .
    else
        nvim "$@"
    fi
}
alias lsd="lsd -1X"
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias fdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

