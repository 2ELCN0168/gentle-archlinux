# FUNCTION(S)
# ---
# This function, after getting the BIOS mode, asks the user which bootloader they want to use.
# Choices are : rEFInd (default), GRUB2, systemd-boot.
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

bootloader_choice() {

        # FORMATTING DONE

        declare -gx bootloader=""

        if [[ "${UEFI}" -eq 1 ]]; then
                while true; do
                        echo -e "==BOOTLOADER========\n"

                        echo -e "${C_WHITE}[0] - ${C_CYAN}rEFInd${NO_FORMAT} (default)"
                        echo -e "${C_WHITE}[1] - ${C_YELLOW}GRUB2${NO_FORMAT}"
                        echo -e "${C_WHITE}[2] - ${C_RED}systemd-boot${NO_FORMAT}"

                        echo -e "====================\n"
                        
                        echo -e "${B_CYAN} Which one do you prefer? [0/1/2] -> ${NO_FORMAT} "

                        declare -i ans_bootloader="0"
                        read ans_bootloader
                        echo ""
                        #response=${response:-0}
                        case "${ans_bootloader}" in
                                [0])
                                        echo -e "${C_WHITE}> ${NO_FORMAT}We will install ${C_CYAN}rEFInd${NO_FORMAT}\n"
                                        bootloader="REFIND"
                                        break
                                        ;;
                                [1])
                                        echo -e "${C_WHITE}> ${NO_FORMAT}We will install ${C_YELLOW}GRUB2${NO_FORMAT}\n"
                                        bootloader="GRUB"
                                        break
                                        ;;
                                [2])
                                        echo -e "${C_WHITE}> ${NO_FORMAT}We will install ${C_RED}systemd-boot${NO_FORMAT}\n"
                                        bootloader="SYSTEMDBOOT"
                                        break
                                        ;;
                                *)
                                        invalid_answer
                                ;;
                        esac
                done
        elif [[ "${UEFI}" -eq 0 ]]; then
                bootloader="GRUB"
        fi
}
