# FUNCTION(S)
# ---
# This function asks the user if they want to use LUKS to encrypt their filesystem.
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

luks_choice() {

        export wantEncrypted=0

        # FORMATTING DONE
        while true; do

                echo -e "${C_CYAN}:: ${C_WHITE}Do you want your system to be encrypted with \033[41;0m LUKS ${NO_FORMAT}? [y/N] -> ${NO_FORMAT} \c"

                local ans_luks=""
                read ans_luks
                : "${ans_luks:=N}"
                echo ""

                case "${ans_luks}" in
                        "y"|"Y")
                                echo -e "${C_WHITE}> ${INFO} ${C_GREEN}cryptsetup${NO_FORMAT} will be installed.\n"
                                wantEncrypted=1
                                break
                                ;;
                        "n"|"N")
                                echo -e "${C_WHITE}> ${INFO} ${C_RED}cryptsetup${NO_FORMAT} won't be installed.\n"
                                wantEncrypted=0
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}
