# FUNCTION(S)
# ---
# This function try to determinates if the system has booted in UEFI mode or in BIOS mode.
# EDIT 1 : Modified variables declarations and tests in conditions + replaced printf by echo.
# ---

get_bios_mode() {

        # FORMATTING DONE

        #export UEFI=0
        declare -ix UEFI="0"

        if [[ -e /sys/firmware/efi/fw_platform_size && -s /sys/firmware/efi/fw_platform_size ]]; then
                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Running in ${C_CYAN}UEFI${NO_FORMAT} mode."
                echo -e "${C_CYAN}You are using UEFI mode, you have the choice for the bootloader...${NO_FORMAT}\n"
                UEFI="1"
        else
                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Running in ${C_RED}BIOS${NO_FORMAT} mode."
                echo -e "${C_YELLOW}No choice for you. You would have been better off using UEFI mode. We will install GRUB2.${NO_FORMAT}\n"
                UEFI="0"
        fi
}
