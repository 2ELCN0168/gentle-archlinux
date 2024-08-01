# FUNCTION(S)
# ---
# This function aims to get the CPU manufacturer to install the apropriate microcode in a later stage.
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

get_cpu_brand() {

        declare vendor=""
        declare -gx cpuBrand=""

        vendor="$(lscpu | grep -i vendor | awk '{ print $3 }' | head -1)"

        case "${vendor}" in
                "GenuineIntel")
                        echo -e "${C_WHITE}> ${INFO} ${C_CYAN}INTEL CPU${NO_FORMAT} detected.\n"
                        cpuBrand="INTEL"
                        ;;
                "AuthenticAMD")
                        echo -e "${C_WHITE}> ${INFO} ${C_RED}AMD CPU${NO_FORMAT} detected.\n"
                        cpuBrand="AMD"
                        ;;
                *)  
                        echo -e "${C_WHITE}> ${INFO} ${C_YELLOW}Could not detect your CPU vendor. No microcode will be installed.${NO_FORMAT}\n"
                        cpuBrand="UNKNOWN"
                        ;;
        esac
}
