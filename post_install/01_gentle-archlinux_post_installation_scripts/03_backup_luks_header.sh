#! /bin/bash

declare C_RED="\033[91m"
declare C_GREEN="\033[92m"
declare C_CYAN="\033[96m"
declare C_YELLOW="\033[93m"
declare C_WHITE="\033[97m"

# End of the color sequence
declare NO_FORMAT="\033[0m"

main() {

        if [[ "${EUID}" -ne 0 && "lsblk -f | grep crypto | awk '{ print \$1 }' | tr -d [└][─]" ]]; then
                echo -e "${C_WHITE}:: ${C_RED}This script must be executed as root. Exiting.${C_WHITE} ::${NO_FORMAT}"
                exit 1
        fi

        declare ans_luks_header=""

        while true; do
                echo -e "${C_WHITE}Do you want to backup your partition luks header?"
                echo -e "It's highly recommended to do so, in case the header become altered"
                echo -e "and your system becomes unusable. [Y/n] ->${NO_FORMAT} \c"

                read ans_luks_header
                : "${ans_luks_header:=Y}"
                echo ""

                case "${ans_luks_header}" in
                        [yY])
                                break
                                ;;
                        [nN])
                                echo -e "${C_YELLOW}Nothing has been done.${NO_FORMAT}\n"
                                exit 0
                                ;;
                        *)
                                echo -e "${C_YELLOW}Not a valid answer.${NO_FORMAT}\n"
                                ;;
                esac
        done

        cryptsetup luksHeaderBackup "/dev/$(lsblk -f | grep crypto | awk '{ print $1 }' | tr -d [└][─])" --header-backup-file "${HOME}/$(date +%Y%m%d)_luks_header_file.img"
        if [[ "${?}" -eq 0 ]]; then
                echo -e "File saved at ${C_GREEN}${HOME}/$(date +%Y%m%d)_luks_header_file.img${NO_FORMAT}"
        else
                echo -e "${C_RED}Error during backup. Nothing has been done.${NO_FORMAT}"
                exit 1
        fi

        return 0
}

main
