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
                        echo -e "==${C_C}BOOTLOADER${N_F}========\n"

                        echo -e "${C_W}[0] - ${C_C}rEFInd${N_F} (default)"
                        echo -e "${C_W}[1] - ${C_Y}GRUB2${N_F}"
                        echo -e "${C_W}[2] - ${C_R}systemd-boot${N_F}"

                        echo -e "\n====================\n"
                        
                        echo -e "${C_C}${BOLD}:: ${C_W}Which one do you prefer? [0/1/2] -> ${N_F}\c"

                        local ans_bootloader=""
                        read ans_bootloader
                        : "${ans_bootloader:=0}"

                        case "${ans_bootloader}" in
                                0) 
                                        echo -e "${C_W}> ${INFO} We will" \
                                                "install ${C_C}rEFInd${N_F}\n"
                                        bootloader="REFIND"
                                        break
                                        ;;
                                1)
                                        echo -e "${C_W}> ${INFO} We will" \
                                                "install ${C_Y}GRUB2${N_F}\n"
                                        bootloader="GRUB"
                                        break
                                        ;;
                                2)
                                        echo -e "${C_W}> ${INFO} We will" \
                                                "install ${C_R}systemd-boot${N_F}\n"
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
