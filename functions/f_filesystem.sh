# FUNCTION(S)
# ---
# This function asks the user which filesystem they want to use. 
# Choices are BTRFS (default), XFS, EXT4.
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

filesystem_choice() {

        export filesystem=""

        while true; do
                
                if [[ "${param_minimal}" -eq 1 ]]; then
                        filesystem="EXT4"
                        break
                fi
                echo -e "==${C_CYAN}FILESYSTEM${NO_FORMAT}========\n"

                echo -e "${C_WHITE}[0] - ${C_YELLOW}BTRFS${NO_FORMAT} (default)"
                echo -e "${C_WHITE}[1] - ${C_CYAN}XFS${NO_FORMAT}"
                echo -e "${C_WHITE}[2] - ${C_RED}EXT4${NO_FORMAT}"
                
                echo -e "\n====================\n"

                echo -e "${C_CYAN}:: ${C_WHITE}Which filesystem do you want to use? [0/1/2] -> ${NO_FORMAT}\c"
                
                local ans_filesystem=""
                read ans_filesystem
                : "${ans_filesystem:=0}"
                # echo ""

                case "${ans_filesystem}" in
                        [0])
                                filesystem="BTRFS"
                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_WHITE}${filesystem}${NO_FORMAT}\n"
                                break
                                ;;
                        [1])
                                filesystem="XFS"
                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_WHITE}${filesystem}${NO_FORMAT}\n"
                                break
                                ;;
                        [2])
                                filesystem="EXT4"
                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_WHITE}${filesystem}${NO_FORMAT}\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}


