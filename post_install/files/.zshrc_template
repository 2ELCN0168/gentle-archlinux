# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

# PLUGINS #

source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
PROMPT="%F{red}[%f%B%F{white}%n%f%b%F{red}@%f%F{white}%m%f%F{red}:%f%B%~%b%F{red}]%f(%F{red}%*%f)%F{red}%#%f "

# LINKED CONFIGURATIONS 

# INFO:
# Source every shell/env configuration file in "/etc/shell_conf.d"
for i in /etc/shell_conf.d/*.sh; do
        [[ -r "${i}" ]] && source "${i}"
done
