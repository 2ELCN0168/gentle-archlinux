#
### File: f_bios_mode.sh
#
### Description: 
# Try to determinates if the system has booted in UEFI mode or in BIOS mode.
# It can be used on several disks at the same time.
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

# get_bios_mode() {
#
#         export UEFI=0
#         local efi_path="/sys/firmware/efi/fw_platform_size"
#
#         if [[ ! -z "${efi_path}" ]]; then
#                 echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Running in" \
#                         "${C_CYAN}UEFI${NO_FORMAT} mode."
#                 echo -e "${C_CYAN}You are using UEFI mode, you have the choice" \
#                         "for the bootloader...${NO_FORMAT}\n"
#                 UEFI=1
#         else
#                 echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Running in" \
#                         "${C_RED}BIOS${NO_FORMAT} mode."
#                 echo -e "${C_YELLOW}No choice for you. You would have been" \
#                         "better off using UEFI mode. We will install" \
#                         "GRUB2.${NO_FORMAT}\n"
#                 UEFI=0
#         fi
# }



get_bios_mode() {

        local C_W="${C_WHITE}"
        local C_C="${C_CYAN}"
        local C_R="${C_RED}"
        local C_Y="${C_YELLOW}"
        local N_F="${NO_FORMAT}"

        export UEFI=0
        local efi_path="/sys/firmware/efi/fw_platform_size"

        if [[ ! -z "${efi_path}" ]]; then
                printf "${C_W}> ${INFO} ${N_F}Running in ${C_C} UEFI${N_F}
                        mode.\n"
                printf "${C_C}You are using UEFI mode, you have the choice for 
                        the bootloader...${N_F}\n\n"
                UEFI=1
        else
                printf "${C_W}> ${INFO} ${N_F}Running in ${C_R}BIOS ${N_F} 
                        mode."
                printf "${C_Y}No choice for you. You would have been better off
                        using UEFI mode. We will install GRUB2.${N_F}\n\n"
                UEFI=0
        fi
}
