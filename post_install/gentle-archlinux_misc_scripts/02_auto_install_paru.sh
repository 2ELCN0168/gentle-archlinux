#! /bin/bash

#
### File: 02_auto_install_paru.sh
#
### Description: 
# Install paru (AUR helper) if the user is not root.
#
### Author: 2ELCN0168
# Last updated: 2024-10-05
# 
### Dependencies:
# - git.
#
### Usage:
#
# 1. Check if the user is not root;
# 2. Clone the paru repository;
# 3. Compile it.
#

main() {

        local C_R="\033[91m"
        local C_G="\033[92m"
        local C_C="\033[96m"
        local C_Y="\033[93m"
        local C_W="\033[97m"

        # End of the color sequence
        local N_F="\033[0m"


        if [[ "${EUID}" -eq 0 ]]; then
                printf "${C_W}:: ${C_R}This script must be executed as a "
                printf "non-privileged user. Exiting.${C_W} ::${N_F}\n"
                exit 1
        fi

        local ans_paru=""
        while true; do
                printf "${C_W}Do you want to install ${C_C}paru${C_W}? It's "
                printf "an AUR helper and a pacman wrapper. [Y/n] -> ${N_F}"

                read ans_paru
                : "${ans_paru:=Y}"
                printf "\n"

                [[ "${ans_paru}" =~ [yY] ]] && break
                [[ "${ans_paru}" =~ [nN] ]] && \
                printf "${C_Y}Nothing has been done${N_F}\n\n" && exit 0

                printf "${C_Y}Not a valid answer.${N_F}\n\n"
        done

        cd "${HOME}"
        git clone "https://aur.archlinux.org/paru.git"
        cd paru
        makepkg -si
        if paru --version; then
                printf "${C_G}Paru has been installed.${N_F}\n"
                return 0
        else
                printf "${C_R}An error occured during the installation.${N_F}\n"
                return 1
        fi
}

main
