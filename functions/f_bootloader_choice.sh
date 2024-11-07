#
### File: f_bootloader_choice.sh
#
### Description: 
# Ask the user which bootloader they want to use. More choices availables if
# running in UEFI mode.
#
### Author: 2ELCN0168
# Last updated: 2024-11-07
#
### Dependencies:
# - none.
#
### Usage:
#
# 1. Check if the file in ${efi_path} is not empty. (and it exists)
# 2. If so, it's running in UEFI, else, in BIOS mode.
#
# NOTE:
# This part of the script is important to determine which bootloader can be used
# and how it should be installed.
#

bootloader_choice() {

        export bootloader=""

        # INFO:
        # BIOS mode or minimal parameter used = GRUB

        if [[ "${UEFI}" -eq 0 || "${param_minimal}" -eq 1 ]]; then
                bootloader="GRUB"
                return
        fi
        while true; do

                print_box "Bootloader" "${C_C}" 40 

                printf "${C_W}[0] - ${C_C}rEFInd${N_F} (default)\n"
                printf "${C_W}[1] - ${C_Y}GRUB2${N_F}\n"
                printf "${C_W}[2] - ${C_R}systemd-boot${N_F}\n\n"

                printf "────────────────────────────────────────\n\n"
                
                printf "${C_C}${BOLD}:: ${C_W}Which one do you prefer? "
                printf "[0/1/2] -> ${N_F}"

                local ans_bootloader=""
                read ans_bootloader
                : "${ans_bootloader:=0}"

                [[ "${ans_bootloader}" =~ ^[0-2]$ ]] && break ||
                invalid_answer
        done

        case "${ans_bootloader}" in
                0) 
                        printf "${C_W}> ${INFO} We will "
                        printf "install ${C_C}rEFInd${N_F}\n\n"
                        bootloader="REFIND"
                        ;;
                1)
                        printf "${C_W}> ${INFO} We will "
                        printf "install ${C_Y}GRUB2${N_F}\n\n"
                        bootloader="GRUB"
                        ;;
                2)
                        printf "${C_W}> ${INFO} We will "
                        printf "install ${C_R}systemd-boot${N_F}\n\n"
                        bootloader="SYSTEMDBOOT"
                        ;;
        esac
}
