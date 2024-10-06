#
### File: f_greetings_pi.sh
#
### Description: 
# This is post-install introduction.
#
### Author: 2ELCN0168
# Last updated: 2024-10-06
# 
### Dependencies:
# - none. 
#
### Usage:
#
# 1. Say hello.
#

greetings_pi() {
        
        sleep 2
        clear
        printf "${C_C}███${C_R}█${C_C}█${C_Y}█${C_C}█${N_F}\n\n"

        printf "${C_C}> ${C_W}Welcome to your new ${C_C}Arch/\Linux${N_F} "
        printf "${C_W}system. ${C_C}<${N_F}\n\n"

        printf ":::::::::::::::::::::::::::::::::::::::::::::::::::\n\n"
        printf "${C_W}> ${INFO} ${C_G}This is the second stage script."
        printf "${N_F}\n\n"
        printf ":::::::::::::::::::::::::::::::::::::::::::::::::::\n\n"
}
