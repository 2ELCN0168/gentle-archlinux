# CREATE PACMAN HOOKS 

create_pacman_hooks() {

        if [[ ! -e "/etc/pacman.d/hooks" ]]; then
                mkdir -p /etc/pacman.d/hooks 1> /dev/null 2>&1
        fi

        refind_hook
        bash_zsh_hook
}

refind_hook() {

        # This hook launches refind-install after a package update.

        if [[ "$bootloader" != 'REFIND' ]]; then
                return 1;
        fi

        echo -e "${C_WHITE}> ${INFO} Creating a pacman hook for ${C_WHITE}rEFInd.${NO_FORMAT}\n"

        cat << EOF > /etc/pacman.d/hooks/refind.hook
        [Trigger]
        Operation=Upgrade
        Type=Package
        Target=refind

        [Action]
        Description=Updating rEFInd to ESP...
        When=PostTransaction
        Exec=/usr/bin/refind-install
EOF

        if [[ -e "/etc/pacman.d/hooks/refind.hook" ]]; then
                echo -e "${C_WHITE}> ${SUC} Created a pacman hook for ${C_WHITE}${1}.${NO_FORMAT}\n"
        else
                echo -e "${C_WHITE}> ${ERR} While creating a pacman hook for ${C_WHITE}${1}.${NO_FORMAT}\n"
        fi
}

bash_zsh_hook() {

        # This hook avoids bash to be uninstalled.

        echo -e "${C_WHITE}> ${INFO} Creating a pacman hook for ${C_WHITE}Bash and Zsh.${NO_FORMAT}\n"

        cat << EOF > /etc/pacman.d/hooks/bash_zsh_no_remove.hook
        [Trigger]
        Operation=Remove
        Type=Package
        Target=bash
        Target=zsh

        [Action]
        Description=CAN'T UNINSTALL BASH/ZSH
        When=PreTransaction
        Exec=/usr/bin/false
        AbortOnFail
EOF
        if [[ -e "/etc/pacman.d/hooks/bash_zsh_no_remove.hook" ]]; then
                echo -e "${C_WHITE}> ${SUC} Created a pacman hook for ${C_WHITE}Bash and Zsh.${NO_FORMAT}\n"
        else
                echo -e "${C_WHITE}> ${ERR} While creating a pacman hook for ${C_WHITE}Bash and Zsh.${NO_FORMAT}\n"
        fi
}
