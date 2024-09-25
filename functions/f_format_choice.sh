# FUNCTION(S)
# ---
# This function format the boot partition to FAT32 and then call other functions,
# depending on the filesystem the user chose, and even if they chose to use LUKS.
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

source "./functions/f_luks_handling.sh"
source "./functions/f_btrfs.sh"

format_partitions() {

        # FORMATTING DONE
        echo -e "${C_WHITE}> ${INFO} ${C_CYAN}Formatting ${boot_part} to FAT32.${NO_FORMAT}"

        if mkfs.fat -F 32 -n ESP "${boot_part}" 1> "/dev/null" 2>&1; then
                echo -e "${C_WHITE}> ${SUC} ${C_GREEN}Successfully formatted ${boot_part} to FAT32.${NO_FORMAT}\n"
        else
                echo -e "${C_WHITE}> ${ERR} ${C_RED}Error during formatting ${boot_part} to FAT32.${NO_FORMAT}\n"
                exit 1
        fi

        if [[ "${wantEncrypted}" -eq 1 ]]; then
                luks_handling
        fi

        case "${filesystem}" in
                "BTRFS")
                        btrfs_mgmt
                        ;;
                *)
                        lvm
                        ;;
        esac
}
