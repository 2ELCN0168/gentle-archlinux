PS1='\[\e[93m\][\[\e[97;1m\]\u\[\e[0;93m\]@\[\e[97m\]\h\[\e[93m\]]\[\e[91m\][\w]\[\e[93m\](\t)\[\e[0m\] \[\e[97m\]\$\[\e[0m\] '

# LINKED CONFIGURATIONS 
if [[ "${TERM}" == "linux" ]]; then
        # ID2642 # To be replaced with the theme for TTY
fi

# INFO:
# Source every shell/env configuration file in "/etc/shell_conf.d"
for i in /etc/shell_conf.d/*.sh; do
        [[ -r "${i}" ]] && source "${i}"
done
