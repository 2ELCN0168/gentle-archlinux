#! /bin/bash

declare C_R="\033[91m"
declare C_G="\033[92m"
declare C_C="\033[96m"
declare C_Y="\033[93m"
declare C_W="\033[97m"

# End of the color sequence
declare N_F="\033[0m"

main() {

        if [[ "${EUID}" -ne 0 && "lsblk -f | grep crypto | awk '{ print \$1 }' | tr -d [└][─]" ]]; then
                echo -e "${C_W}:: ${C_R}This script must be executed as root. Exiting.${C_W} ::${N_F}"
                exit 1
        fi

        declare ans_luks_header=""

        while true; do
                echo -e "${C_W}Do you want to backup your partition luks header?"
                echo -e "It's highly recommended to do so, in case the header become altered"
                echo -e "and your system becomes unusable. [Y/n] ->${N_F} \c"

                read ans_luks_header
                : "${ans_luks_header:=Y}"
                echo ""

                case "${ans_luks_header}" in
                        [yY])
                                break
                                ;;
                        [nN])
                                echo -e "${C_Y}Nothing has been done.${N_F}\n"
                                exit 0
                                ;;
                        *)
                                echo -e "${C_Y}Not a valid answer.${N_F}\n"
                                ;;
                esac
        done

        cryptsetup luksHeaderBackup "/dev/$(lsblk -f | grep crypto | awk '{ print $1 }' | tr -d [└][─])" --header-backup-file "${HOME}/$(date +%Y%m%d)_luks_header_file.img"
        if [[ "${?}" -eq 0 ]]; then
                echo -e "File saved at ${C_G}${HOME}/$(date +%Y%m%d)_luks_header_file.img${N_F}"
        else
                echo -e "${C_R}Error during backup. Nothing has been done.${N_F}"
                exit 1
        fi

        return 0
}

main
