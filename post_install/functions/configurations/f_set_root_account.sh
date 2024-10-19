#
### File: f_set_root_account.sh
#
### Description: 
# Management for the root account.
#
### Author: 2ELCN0168
# Last updated: 2024-10-18
# 
### Dependencies:
# - none.
#
### Usage:
#
# 1. Lock root account [Y/n];
# 2. If no, change password.
#

set_root_account() {

        local ans_lock_root=""
        local isFailed=""

        while true; do
                printf "\n${C_C}:: ${C_W}Do you want to authorize log-in as "
                printf "${C_R}root${N_F}? [y/N] -> "
                
                read -r ans_lock_root
                : "${ans_lock_root:=N}"
                printf "\n"

                if [[ "${ans_lock_root}" =~ ^[nN]$ ]]; then
                        printf "${C_W}> ${INFO} Locking ${C_R}root${N_F} "
                        printf "account...\n"
                        
                        if passwd --lock root 1> "/dev/null" 2>&1; then
                                printf "${C_W}> ${SUC} Locked ${C_R}root${N_F} "
                                printf "account.\n\n"

                                printf "${C_W}> ${WARN} You will have to "
                                printf "create a privileged user, otherwise, "
                                printf "the ${C_R}root${N_F} account will be "
                                printf "unlocked.\n\n"
                                sleep 2
                                return 
                        else
                                isFailed=1
                                printf "${C_W}> ${WARN} An error occured, "
                                printf "we couldn't lock the ${C_R}root${N_F} "
                                printf "account.\n\n"
                                break
                        fi
                elif [[ "${ans_lock_root}" =~ ^[yY]$ ||
                        "${isFailed}" -eq 1 ]]; then
                        printf "${C_W}> ${INFO} Changing "
                        printf "${C_R}root${N_F} password...${N_F}\n\n"
                        while true; do
                                if passwd; then
                                        break
                                fi
                        done
                        printf "\n"                       
                        break
                else
                        invalid_answer
                fi
        done
}
