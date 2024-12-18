# CREATE PACMAN HOOKS 

create_pacman_hooks() {

        [[ ! -e "/etc/pacman.d/hooks" ]] && \
        mkdir -p "/etc/pacman.d/hooks" 1> "/dev/null" 2>&1

        refind_hook
}

refind_hook() {

        # INFO:
        # This hook launches refind-install after a package update.

        [[ "$bootloader" != 'REFIND' ]] && return 1

        printf "${C_W}> ${INFO} Creating a pacman hook for "
        printf "${C_W}rEFInd.${N_F}\n"

        cat <<-EOF 1> "/etc/pacman.d/hooks/refind.hook"
        [Trigger]
        Operation=Upgrade
        Type=Package
        Target=refind

        [Action]
        Description=Updating rEFInd to ESP...
        When=PostTransaction
        Exec=/usr/bin/refind-install
EOF

        # INFO:
        # Remove spaces caused by heredocs >:(
        sed -i 's/^[ \t]*//' "/etc/pacman.d/hooks/refind.hook"

        if [[ -e "/etc/pacman.d/hooks/refind.hook" ]]; then
                printf "${C_W}> ${SUC} Created a pacman hook for ${C_W}rEFInd."
                printf "${N_F}\n\n"
        else
                printf "${C_W}> ${ERR} While creating a pacman hook for "
                printf "${C_W}rEFInd${N_F}\n\n"
        fi
}
