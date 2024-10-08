#! /bin/bash

source_files() {

    local f_path="/post_install/functions"

    source "/post_install/config/c_config.sh"
    source "/post_install/config/c_formatting.sh"
    source "${f_path}/f_greetings_pi.sh"
    source "${f_path}/f_configs.sh"
    source "${f_path}/f_hardening_rules.sh"
    source "${f_path}/f_messages.sh"
    source "${f_path}/f_set_shellrc.sh"
    source "${f_path}/f_install_bootloader.sh"
    source "${f_path}/f_theming.sh"
    source "${f_path}/f_refind_theming.sh"
    source "${f_path}/f_pacman_hooks.sh"
    source "${f_path}/f_install_frw.sh"
    source "${f_path}/f_desktop_environment.sh"
    source "${f_path}/f_user_management.sh"
    source "${f_path}/f_enable_guest_agents.sh"
    source "${f_path}/f_systemd-networkd.sh"
    source "${f_path}/f_systemd_resolved.sh"
    source "${f_path}/f_ending.sh"
}

main() {
        
        trap 'echo -e "\n\n${C_BLUE}:: ${C_RED}Program interrupted, installation aborted. Exiting with code 1.${C_BLUE} ::\n" ; exit 1' INT

        # SOURCE FILES
        source_files

        # START SECOND PART
        greetings_pi

        # CHANGE MULTIPLE CONFIG FILES
        # make_config
        set_time
        locales_gen
        set_hostname
        set_hosts
        set_vconsole
        set_pacman
        if [[ "${param_hardening}" -eq 1 ]]; then
                hardening_rules
        fi
        set_mkinitcpio
        set_root_passwd
        set_vim_nvim
        enable_net_manager

        

        # INSTALL BOOTLOADER
        install_bootloader

        # PACMAN HOOKS CREATION
        create_pacman_hooks

        # INSTALL FIREWALL + SSHGUARD
        install_frw

        if [[ "${param_minimal}" -ne 1 ]]; then
                # SET SHELLS .RCs
                set_bashrc
                set_zshrc

                # THEMING
                create_themes
                refind_theming

                # CUSTOMIZE MESSAGES
                set_issue
                set_motd
        fi

        if [[ "${param_full}" -eq 1 ]]; then
                # INSTALL DESKTOP ENVIRONMENT
                desktop_env
        fi
        
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
