#
### File: f_bootloader_choice.sh
#
### Description: 
# Ask the user which bootloader they want to use. More choices availables if
# running in UEFI mode.
#
### Author: 2ELCN0168
# Last updated: 2024-09-30
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
        else
                while true; do
                        echo -e "==${C_CYAN}BOOTLOADER${NO_FORMAT}========\n"

                        echo -e "${C_WHITE}[0] - ${C_CYAN}rEFInd${NO_FORMAT} (default)"
                        echo -e "${C_WHITE}[1] - ${C_YELLOW}GRUB2${NO_FORMAT}"
                        echo -e "${C_WHITE}[2] - ${C_RED}systemd-boot${NO_FORMAT}"

                        echo -e "\n====================\n"
                        
                        echo -e "${C_CYAN}${BOLD}:: ${C_WHITE}Which one do you prefer? [0/1/2] -> ${NO_FORMAT}\c"

                        local ans_bootloader=""
                        read ans_bootloader
                        : "${ans_bootloader:=0}"

                        case "${ans_bootloader}" in
                                0) 
                                        echo -e "${C_WHITE}> ${INFO} We will" \
                                                "install ${C_CYAN}rEFInd${NO_FORMAT}\n"
                                        bootloader="REFIND"
                                        break
                                        ;;
                                1)
                                        echo -e "${C_WHITE}> ${INFO} We will" \
                                                "install ${C_YELLOW}GRUB2${NO_FORMAT}\n"
                                        bootloader="GRUB"
                                        break
                                        ;;
                                2)
                                        echo -e "${C_WHITE}> ${INFO} We will" \
                                                "install ${C_RED}systemd-boot${NO_FORMAT}\n"
                                        bootloader="SYSTEMDBOOT"
                                        break
                                        ;;
                                *)
                                        invalid_answer
                                        ;;
                        esac
                done
        fi
}
