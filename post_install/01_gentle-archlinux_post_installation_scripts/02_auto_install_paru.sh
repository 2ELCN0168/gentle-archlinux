#! /bin/bash

declare C_R="\033[91m"
declare C_G="\033[92m"
declare C_C="\033[96m"
declare C_Y="\033[93m"
declare C_W="\033[97m"

# End of the color sequence
declare N_F="\033[0m"

main() {

        if [[ "${EUID}" -eq 0 ]]; then
                echo -e "${C_W}:: ${C_R}This script must be executed as a non-privileged user. Exiting.${C_W} ::${N_F}"
                exit 1
        fi

        declare ans_paru=""
        while true; do
                echo -e "${C_W}Do you want to install ${C_C}paru${C_W}? It's an AUR helper and a pacman wrapper. [Y/n] -> ${N_F}\c"

                read ans_paru
                : "${ans_paru:=Y}"
                echo ""

                case "${ans_paru}" in
                        [Yy])
                                break
                                ;;
                        [nN])
                                echo -e "${C_Y}Nothing has been done${N_F}\n"
                                exit 0
                                ;;
                        *)
                                echo -e "${C_Y}Not a valid answer.${N_F}\n"
                                ;;
                esac
        done

        cd "${HOME}"
        git clone "https://aur.archlinux.org/paru.git"
        cd paru
        makepkg -si
        paru --version
        
        if [[ "${?}" -eq 0 ]]; then
                echo -e "${C_G}Paru has been installed.${N_F}"
        else
                echo -e "${C_R}An error occured during the installation.${N_F}"
        fi
        
        return 0
}

main
