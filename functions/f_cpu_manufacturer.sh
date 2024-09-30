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

        vendor="$(lscpu | grep -i "vendor" | awk '{ print $3 }' | head -1)"

        case "${vendor}" in
                "GenuineIntel")
                        echo -e "${C_WHITE}> ${INFO} ${C_CYAN}INTEL CPU" \
                                "${NO_FORMAT} detected.\n"
                        cpuBrand="INTEL"
                        ;;
                "AuthenticAMD")
                        echo -e "${C_WHITE}> ${INFO} ${C_RED}AMD CPU" \
                                "${NO_FORMAT} detected.\n"
                        cpuBrand="AMD"
                        ;;
                *)  
                        echo -e "${C_WHITE}> ${INFO} ${C_YELLOW}Could " \
                                "not detect your CPU vendor. No microcode will " \
                                "be installed.${NO_FORMAT}\n"
                        cpuBrand="UNKNOWN"
                        ;;
        esac
}
