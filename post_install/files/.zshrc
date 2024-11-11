# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}

zmodload zsh/net/tcp

setopt append_history share_history histignorealldups

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
