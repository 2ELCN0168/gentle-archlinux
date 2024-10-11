# NAVIGATION
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# NETWORK
alias ipb='printf "\033[92m"; curl -s ifconfig.me; printf "\033[0m"'

# COLORS
alias diff='diff --color=auto'
alias ll='command ls -lh --color=auto'
alias ls='command ls --color=auto'
alias ip='command ip -color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# SAFETY
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# CUSTOM OUTPUTS
lsblk() {
        printf "\033[96m"
        lsblk "${@}"
        printf "\033[0m"
        printf "\n"
}

blkid() {
        printf "\033[94m"
        blkid "${@}"
        printf "\033[0m"
        printf "\n"
}

ss() {
        printf "\033[92m"
        ss "${@}"
        printf "\033[0m"
}

uptime() {
        printf "\033[91m"
        uptime "${@}"
        printf "\033[0m"
        printf "\n"
}

ps() {
        printf "\033[93m"
        ps "${@}"
        printf "\033[0m"
        printf "\n"
}

free() {
        printf "\033[93m"
        free "${@}"
        printf "\033[0m"
        printf "\n"
}

ping() {
        printf "\033[94m"
        command ping "${@}"
        printf "\033[0m"
        printf "\n"
}

traceroute() {
        printf "\033[94m"
        command traceroute "${@}"
        printf "\033[0m"
        printf "\n"
}

# CONVENIENCE
alias untar='tar xvf'
alias sstcp='ss -eant'
alias ssudp='ss -eanu'

# READABILITY
alias du='du -h'
alias df='df -h'
alias free='free -h'

# REPLACEMENTS
if hash eza 2> "/dev/null"; then
        alias ls='eza'
        alias ll='eza -l'
fi

if hash bat 2> "/dev/null"; then
        alias cat='bat'
fi

# OTHERS
