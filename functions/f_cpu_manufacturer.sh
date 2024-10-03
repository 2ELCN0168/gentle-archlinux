#
### File: f_cpu_manufacturer.sh
#
### Description: 
# Detect the CPU vendor to install the correct microcode at the system 
# installation
#
### Author: 2ELCN0168
# Last updated: 2024-10-03
#
### Dependencies:
# - none.
#
### Usage:
#
# 1. Grep to lscpu.
#

get_cpu_brand() {

        local vendor=""
        export cpuBrand=""

        vendor="$(lscpu | grep --ignore-case "vendor" | 
                awk '{ print $3 }' | head -1)"

        case "${vendor}" in
                "GenuineIntel")
                        printf "${C_W}> ${INFO} ${C_C}INTEL CPU ${N_F} "
                        printf "detected.\n\n"
                        cpuBrand="INTEL"
                        ;;
                "AuthenticAMD")
                        printf "${C_W}> ${INFO} ${C_R}AMD CPU ${N_F} "
                        printf "detected.\n\n"
                        cpuBrand="AMD"
                        ;;
                *)  
                        printf "${C_W}> ${INFO} ${C_Y}Could not detect your "
                        printf "CPU vendor. No microcode will be installed."
                        printf "${N_F}\n\n"
                        cpuBrand="UNKNOWN"
                        ;;
        esac
}
