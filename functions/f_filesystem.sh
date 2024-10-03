#
### File: f_filesystem.sh
#
### Description: 
# Ask the user which filesystem they want to use. 
#
### Author: 2ELCN0168
# Last updated: 2024-10-03
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

        [[ "${param_minimal}" -eq 1 ]] && filesystem="EXT4" && return

        while true; do
                
                printf "==${C_C}FILESYSTEM${N_F}========\n\n"

                printf "${C_W}[0] - ${C_Y}BTRFS${N_F} (default)\n"
                printf "${C_W}[1] - ${C_C}XFS${N_F}\n"
                printf "${C_W}[2] - ${C_R}EXT4${N_F}\n"
                
                printf "\n====================\n\n"

                printf "${C_C}:: ${C_W}Which filesystem do you want to use? "
                printf "[0/1/2] -> ${N_F}"
                
                local ans_filesystem=""
                read ans_filesystem
                : "${ans_filesystem:=0}"

                [[ "${ans_filesystem}" -eq 0 ]] && filesystem="BTRFS" && break
                [[ "${ans_filesystem}" -eq 1 ]] && filesystem="XFS" && break
                [[ "${ans_filesystem}" -eq 2 ]] && filesystem="EXT4" && break
                invalid_answer
        done
        printf "${C_W}> ${INFO} ${N_F}You chose ${C_W}${filesystem}${N_F}\n\n"
}


