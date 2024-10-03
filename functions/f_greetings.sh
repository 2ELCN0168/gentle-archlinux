### File: f_greetings.sh
#
### Description: 
# Beginning of the script. Presentation to the user.
# Detection of LVM or LUKS + unmounting everything in "/mnt".
# Nothing should be mounted here before beginning the installation or it will be
# erased or bugged if not unmounted.
#
#        ,                       _     _ _                       
#       /#\        __ _ _ __ ___| |__ | (_)_ __  _   ___  __     
#      ,###\      / _` | '__/ __| '_ \| | | '_ \| | | \ \/ /     
#     /#####\    | (_| | | | (__| | | | | | | | | |_| |>  <      
#    /##;-;##\    \__,_|_|  \___|_| |_|_|_|_| |_|\__,_/_/\_\TM   
#   /##(   )##`                                                  
#  /#;--   --;#\              Gentle Installer.                  
# /`           `\                                                
#
### Author: 2ELCN0168
# Last updated: 2024-10-02
#
### Dependencies:
# - none;
#
### Usage:
#
# 1. Display which parameted has been used;
# 2. Unmount everything in "/mnt";
#
# NOTE:
# I've been struggling with the unmounting part but it seems to be working now.
#
# OPTIMIZE:
# It should be verified or optimized because I have a feeling that it's not perfect.
#

greetings() {
        clear

        local mini="${C_PINK}Minimal installation mode.${NO_FORMAT}"
        local complete="${C_GREEN}Complete installation mode.${NO_FORMAT}"
        local hard="${C_RED}Hardened installation mode.${NO_FORMAT}"
        local standard="${C_CYAN}Standard installation mode.${NO_FORMAT}"

        # INFO:
        # Empty variables when the corresponding parameter is not called.
        # It's just used to display the text in the ASCII art below.
        
        [[ "${param_minimal}" -eq 0 ]] && mini=""
        [[ "${param_full}" -eq 0 ]] && complete=""
        [[ "${param_hardening}" -eq 0 ]] && hard=""
        [[ "${param_standard}" -eq 0 ]] && standard=""
        
        

        echo ""
        echo -e "${C_BLUE}       ,       ${C_CYAN}                _     _ _                               "
        echo -e "${C_BLUE}      /#\      ${C_CYAN}  __ _ _ __ ___| |__ | (_)_ __  _   ___  __             "
        echo -e "${C_BLUE}     ,###\     ${C_CYAN} / _\` | '__/ __| '_ \| | | '_ \| | | \ \/ /            "
        echo -e "${C_BLUE}    /#####\    ${C_CYAN}| (_| | | | (__| | | | | | | | | |_| |>  <              "
        echo -e "${C_BLUE}   /##;-;##\   ${C_CYAN} \__,_|_|  \___|_| |_|_|_|_| |_|\__,_/_/\_\ ${C_GREEN}TM"
        echo -e "${C_BLUE}  /##(   )##\`                                                                  "
        echo -e "${C_BLUE} /#;--   --;#\  ${C_YELLOW}Gentle Installer. ${mini}${complete}${hard}${standard}"
        echo -e "${C_BLUE}/\`           \`\                                                               "
        echo -e "${NO_FORMAT}"

        echo -e "\n${C_WHITE}██████████████████████████████████████████████████████████████████████████████████████"
        echo -e "████████████████████████████████████████████████████"
        echo -e "████████████████\n${NO_FORMAT}"

        # INFO:
        # Keep a report of the date and time it was installed.
        
        date | tee > "./installation_date.log"
        echo -e "${C_CYAN}> ${C_WHITE}Welcome to this gently automated" \
                "${C_CYAN}Arch/\Linux${NO_FORMAT} ${C_WHITE}installer." \
                "${C_CYAN}<${NO_FORMAT}\n"

        echo -e "${C_WHITE}> ${C_PINK}Before starting, make sure you have" \
                "${C_RED}no LVM ${C_PINK}configured on your disk, or it will" \
                "${C_RED}mess up${C_PINK} the script. You must delete any LV," \
                "VG and PV before starting.${NO_FORMAT}\n"

        echo -e "${C_WHITE}> ${C_GREEN}This script is safe to use as it asks" \
                "the user for any modification. No disk/volume will be touched" \
                "without you making the selection. ${C_YELLOW}Just BE CAREFUL" \
                "because actions on disks are ${C_RED}IRREVERSIBLE!${NO_FORMAT}\n"

        # INFO: This unmounting action ensure to have nothing actually mounted 
        # on /mnt before starting
        # BUG: 2027-09-28: It cannot unmount everything at the first launch. 
        # We need to quit and restart the script.
        # PASSED: 2027-09-27: It seems to be working now.
        
        systemctl daemon-reload 1> "/dev/null" 2>&1
        local mountpoints=("home" "usr" "var" "tmp")

        for i in "${mountpoints[@]}"; do
                while mountpoint --quiet "/mnt/${i}"; do 
                        if umount --recursive "/mnt/${i}" 1> "/dev/null" 2>&1; then
                                echo -e "${C_WHITE}> ${SUC} ${C_WHITE}Unmounted" \
                                        "${C_CYAN}${i}${NO_FORMAT}."
                        else
                                echo -e "${C_WHITE}> ${ERR} ${C_WHITE}Error" \
                                        "while unmounting ${C_CYAN}${i}${C_WHITE}." \
                                        "You may want to unmount it manually" \
                                        "before starting the installation."
                        fi
                done
        done
        while mountpoint --quiet "/mnt"; do
                if umount --recursive "/mnt" 1> "/dev/null" 2>&1; then
                        echo -e "${C_WHITE}> ${SUC} ${C_WHITE}Unmounted" \
                                "${C_CYAN}/mnt${NO_FORMAT}."
                else
                        echo -e "${C_WHITE}> ${ERR} ${C_WHITE}Error while" \
                                "unmounting ${C_CYAN}/mnt${C_WHITE}. You may" \
                                "want to unmount it manually before starting" \
                                "the installation.${NO_FORMAT}"
                fi
        echo ""
        done
}
