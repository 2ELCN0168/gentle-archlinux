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
                
                
                echo -e "==${C_C}FILESYSTEM${N_F}========\n"

                echo -e "${C_W}[0] - ${C_Y}BTRFS${N_F} (default)"
                echo -e "${C_W}[1] - ${C_C}XFS${N_F}"
                echo -e "${C_W}[2] - ${C_R}EXT4${N_F}"
                
                echo -e "\n====================\n"

                echo -e "${C_C}:: ${C_W}Which filesystem do you want to use? [0/1/2] -> ${N_F}\c"
                
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
        done
        echo -e "${C_W}> ${INFO} ${N_F}You chose" \
                "${C_W}${filesystem}${N_F}\n"
}


