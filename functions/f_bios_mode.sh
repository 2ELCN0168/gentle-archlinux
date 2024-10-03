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

get_bios_mode() {

        local C_W="${C_W}"
        local C_C="${C_C}"
        local C_R="${C_R}"
        local C_Y="${C_Y}"
        local N_F="${N_F}"

        export UEFI=0
        local efi_path="/sys/firmware/efi/fw_platform_size"

        if [[ -f "${efi_path}" ]]; then
                printf "${C_W}> ${INFO} ${N_F}Running in ${C_C}UEFI${N_F} "
                printf "mode.\n"
                printf "${C_C}You are using UEFI mode, you have the choice for "
                printf "the bootloader...${N_F}\n\n"
                UEFI=1
        else
                printf "${C_W}> ${INFO} ${N_F}Running in ${C_R}BIOS${N_F} "
                printf "mode."
                printf "${C_Y}No choice for you. You would have been better "
                printf "off using ${C_C}UEFI${N_F} mode. We will install "
                printf "GRUB2.${N_F}\n\n"
                UEFI=0
        fi
}
