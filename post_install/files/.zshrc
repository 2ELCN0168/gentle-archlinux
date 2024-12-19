# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

zmodload zsh/net/tcp

setopt append_history 
setopt share_history
setopt extendedglob
setopt promptsubst
setopt histignorealldups

# Exit on Ctrl+D even if command line is filled
exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh

# PLUGINS #

source "/usr/share/zsh/plugins/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
PROMPT="%F{red}[%f%B%F{white}%n%f%b%F{red}@%f%F{white}%m%f%F{red}:%f%B%~%b%F{red}]%f(%F{red}%*%f)%F{red}%#%f "

# LINKED CONFIGURATIONS 
if [[ "${TERM}" == "linux" ]]; then
        # ID2642 # To be replaced with the theme for TTY
fi

# INFO:
# Source every shell/env configuration file in "/etc/shell_conf.d"
for i in /etc/shell_conf.d/*.sh; do
        [[ -r "${i}" ]] && source "${i}"
done
