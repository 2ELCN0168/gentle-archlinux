#! /bin/bash

source_files() {

    local f_path="/post_install/functions"

    source /post_install/config/c_config.sh
    source /post_install/config/c_formatting.sh
    source $f_path/f_greetings_pi.sh
    source $f_path/f_configs.sh
    source $f_path/f_messages.sh
    source $f_path/f_set_shellrc.sh
    source $f_path/f_install_bootloader.sh
    source $f_path/f_theming.sh
    source $f_path/f_refind_theming.sh
    source $f_path/f_pacman_hooks.sh
    source $f_path/f_install_frw.sh
    source $f_path/f_user_management.sh
    source $f_path/f_enable_guest_agents.sh
    source $f_path/f_systemd-networkd.sh
    source $f_path/f_systemd_resolved.sh
    source $f_path/f_ending.sh
}

main() {
        
        trap 'echo -e "\n\n${C_BLUE}:: ${C_RED}Program interrupted, installation aborted. Exiting with code 1.${C_BLUE} ::\n" ; exit 1' INT

        # SOURCE FILES
        source_files

        # START SECOND PART
        greetings_pi

        # CHANGE MULTIPLE CONFIG FILES
        make_config

        # CUSTOMIZE MESSAGES
        set_issue
        set_motd

        # INSTALL BOOTLOADER
        install_bootloader

        # PACMAN HOOKS CREATION
        create_pacman_hooks

        # INSTALL FIREWALL + SSHGUARD
        #install_frw

        # SET SHELLS .RCs
        if [[ "${param_minimal}" -ne 1 ]]; then
                set_bashrc
                set_zshrc
        fi

        # THEMING
        create_themes
        refind_theming

        # CREATE USER
        ask_newuser

        # ENABLE GUEST AGENTS
        enable_guest_agents

        # CONFIGURE systemd-networkd
        systemd_networkd

        # CONFIGURE SYSTEMD-RESOLVED
        systemd_resolved

        # ENDING
        ending

        rm -rf "/post_install"
}

main
