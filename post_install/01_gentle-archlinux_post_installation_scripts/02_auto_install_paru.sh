#! /bin/bash

declare C_RED="\033[91m"
declare C_GREEN="\033[92m"
declare C_CYAN="\033[96m"
declare C_YELLOW="\033[93m"
declare C_WHITE="\033[97m"

# End of the color sequence
declare NO_FORMAT="\033[0m"

main() {

        if [[ "${EUID}" -eq 0 ]]; then
                echo -e "${C_WHITE}:: ${C_RED}This script must be executed as a non-privileged user. Exiting.${C_WHITE} ::${NO_FORMAT}"
                exit 1
        fi

        declare ans_paru=""
        while true; do
                echo -e "${C_WHITE}Do you want to install ${C_CYAN}paru${C_WHITE}? It's an AUR helper and a pacman wrapper. [Y/n] -> ${NO_FORMAT}\c"

                read ans_paru
                : "${ans_paru:=Y}"
                echo ""

                case "${ans_paru}" in
                        [Yy])
                                break
                                ;;
                        [nN])
                                echo -e "${C_YELLOW}Nothing has been done${NO_FORMAT}\n"
                                exit 0
                                ;;
                        *)
                                echo -e "${C_YELLOW}Not a valid answer.${NO_FORMAT}\n"
                                ;;
                esac
        done

        cd "${HOME}"
        git clone "https://aur.archlinux.org/paru.git"
        cd paru
        makepkg -si
        paru --version
        
        if [[ "${?}" -eq 0 ]]; then
                echo -e "${C_GREEN}Paru has been installed.${NO_FORMAT}"
        else
                echo -e "${C_RED}An error occured during the installation.${NO_FORMAT}"
        fi
        
        return 0
}

main
