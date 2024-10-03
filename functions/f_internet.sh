#
### File: f_internet.sh
#
### Description: 
# Try to ping 1.1.1.1 to check the internet connection.
#
### Author: 2ELCN0168
# Last updated: 2024-09-30
#
### Dependencies:
# - none.
#
### Usage:
#
# 1. ping.
#
# NOTE:
# This file may be removed later because we assume you already have internet if
# you have downloaded the script.
#

test_internet() {

        export attempt=3

        while (( "${attempt}" > 0 )); do
                if ping -c 1 1.1.1.1 1> "/dev/null" 2>&1; then
                        echo -e "${C_W}> ${SUC} ${C_G}Internet" \
                                "connection detected.${N_F}\n"
                        return
                fi
                (( attempt-- ))
        done

        echo -e "${C_W}> ${WARN} ${C_R}No Internet connection detected." \
                "Exiting...${N_F}\n"
        exit 1
}
