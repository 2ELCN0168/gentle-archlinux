# NAVIGATION
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias conf="cd ${HOME}/.config"
alias pics="cd ${HOME}/Pictures"
alias vids="cd ${HOME}/Videos"
alias docs="cd ${HOME}/Documents"
alias music="cd ${HOME}/Music"
alias desk="cd ${HOME}/Desktop"
alias downs="cd ${HOME}/Downloads"
alias public="cd ${HOME}/Public"

# NETWORK
alias ipb='printf "\033[92m"; curl -s ifconfig.me; printf "\033[0m"'

# COLORS
alias diff='command diff --color=auto'
alias ll='command ls -lh --color=auto'
alias ls='command ls --color=auto'
alias ip='command ip -color=auto'
alias grep='command grep --color=auto'
alias egrep='command grep -E --color=auto'
alias fgrep='command fgrep --color=auto'

# THEMES
alias _themes="__show_themes"

__show_themes() {

        local themes=("/etc/tty_themes.d/"*)
        printf "There are ${#themes[@]} themes in /etc/tty_themes.d/:\n\n"
        for i in "${themes[@]}"; do
                local name=$(basename ${i})
                printf "\033[96m"
                printf "%s\n" "${name}"
                printf "\033[0m"
        done
        printf "\n"
}

alias _tokyo="source /etc/tty_themes.d/tokyonight_storm.sh"
alias _latte="source /etc/tty_themes.d/catppuccin_latte.sh"
alias _dracula="source /etc/tty_themes.d/dracula.sh"
alias _amber="source /etc/tty_themes.d/mono_amber.sh"
alias _green="source /etc/tty_themes.d/mono_green.sh"
alias _powershell="source /etc/tty_themes.d/powershell.sh"
alias _red="source /etc/tty_themes.d/red_impact.sh"
alias _ryuuko="source /etc/tty_themes.d/ryuuko.sh"
alias _batman="source /etc/tty_themes.d/batman.sh"

# SAFETY
alias rm='command rm -i'
alias cp='command cp -i'
alias mv='command mv -i'

# CUSTOM OUTPUTS - USED IN ALIASES
_ss() {
        # BRIGHT GREEN
        printf "\033[92m"
        command ss "${@}"
        printf "\033[0m"
}

_free() {
        # BRIGHT YELLOW
        printf "\033[93m"
        command free "${@}"
        printf "\033[0m"
        printf "\n"
}

_df() {
        # BRIGHT YELLOW
        printf "\033[93m"
        command df "${@}"
        printf "\033[0m"
        printf "\n"
}

_du() {
        # BRIGHT YELLOW
        printf "\033[93m"
        command du "${@}"
        printf "\033[0m"
        printf "\n"
}

# CUSTOM OUTPUTS - STANDARD
lsblk() {
        # BRIGHT CYAN
        printf "\033[96m"
        command lsblk "${@}"
        printf "\033[0m"
        printf "\n"
}

blkid() {
        # BRIGHT BLUE
        printf "\033[94m"
        command blkid "${@}"
        printf "\033[0m"
        printf "\n"
}

uptime() {
        # BRIGHT RED
        printf "\033[91m"
        command uptime "${@}"
        printf "\033[0m"
        printf "\n"
}

ps() {
        # BRIGHT YELLOW
        printf "\033[93m"
        command ps "${@}"
        printf "\033[0m"
        printf "\n"
}


ping() {
        # BRIGHT BLUE
        printf "\033[94m"
        command ping "${@}"
        printf "\033[0m"
        printf "\n"
}

traceroute() {
        # BRIGHT BLUE
        printf "\033[94m"
        command traceroute "${@}"
        printf "\033[0m"
        printf "\n"
}

# CONVENIENCE
alias untar='command tar xvf'
alias sstcp='_ss -eant'
alias ssudp='_ss -eanu'

# READABILITY
alias du='_du -h'
alias df='_df -h'
alias free='_free -h'

# REPLACEMENTS
if hash eza 2> "/dev/null"; then
        alias ls='eza'
        alias ll='eza -l'
fi

if hash bat 2> "/dev/null"; then
        alias cat='bat'
fi

# OTHERS
