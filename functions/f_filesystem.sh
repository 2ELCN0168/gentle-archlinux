#
### File: f_filesystem.sh
#
### Description: 
# Ask the user which filesystem they want to use. 
#
### Author: 2ELCN0168
# Last updated: 2024-09-30
#
### Dependencies:
# - none.
#
### Usage:
#
# 1. Just ask the user for the filesystem.
#
# NOTE:
# More filesystems will be implemented in the future.
#

filesystem_choice() {

        export filesystem=""

        if [[ "${param_minimal}" -eq 1 ]]; then
                filesystem="EXT4"
                return
        fi

        while true; do
                
                
                echo -e "==${C_CYAN}FILESYSTEM${NO_FORMAT}========\n"

                echo -e "${C_WHITE}[0] - ${C_YELLOW}BTRFS${NO_FORMAT} (default)"
                echo -e "${C_WHITE}[1] - ${C_CYAN}XFS${NO_FORMAT}"
                echo -e "${C_WHITE}[2] - ${C_RED}EXT4${NO_FORMAT}"
                
                echo -e "\n====================\n"

                echo -e "${C_CYAN}:: ${C_WHITE}Which filesystem do you want to use? [0/1/2] -> ${NO_FORMAT}\c"
                
                local ans_filesystem=""
                read ans_filesystem
                : "${ans_filesystem:=0}"

                case "${ans_filesystem}" in
                        [0])
                                filesystem="BTRFS"
                                break
                                ;;
                        [1])
                                filesystem="XFS"
                                break
                                ;;
                        [2])
                                filesystem="EXT4"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose" \
                        "${C_WHITE}${filesystem}${NO_FORMAT}\n"
        done
}


