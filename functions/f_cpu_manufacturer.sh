#
### File: f_cpu_manufacturer.sh
#
### Description: 
# Detect the CPU vendor to install the correct microcode at the system installation
#
### Author: 2ELCN0168
# Last updated: 2024-09-30
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

        vendor="$(lscpu | grep --ignore-case "vendor" | awk '{ print $3 }' | head -1)"

        case "${vendor}" in
                "GenuineIntel")
                        echo -e "${C_W}> ${INFO} ${C_C}INTEL CPU" \
                                "${N_F} detected.\n"
                        cpuBrand="INTEL"
                        ;;
                "AuthenticAMD")
                        echo -e "${C_W}> ${INFO} ${C_R}AMD CPU" \
                                "${N_F} detected.\n"
                        cpuBrand="AMD"
                        ;;
                *)  
                        echo -e "${C_W}> ${INFO} ${C_Y}Could " \
                                "not detect your CPU vendor. No microcode will " \
                                "be installed.${N_F}\n"
                        cpuBrand="UNKNOWN"
                        ;;
        esac
}
