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
# Last updated: 2024-10-04
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

        local mini="${C_P}Minimal installation mode.${N_F}"
        local complete="${C_G}Complete installation mode.${N_F}"
        local hard="${C_R}Hardened installation mode.${N_F}"
        local standard="${C_C}Standard installation mode.${N_F}"

        # INFO:
        # Empty variables when the corresponding parameter is not called.
        # It's just used to display the text in the ASCII art below.
        
        [[ "${param_minimal}" -eq 0 ]] && mini=""
        [[ "${param_full}" -eq 0 ]] && complete=""
        [[ "${param_hardening}" -eq 0 ]] && hard=""
        [[ "${param_standard}" -eq 0 ]] && standard=""
        
        printf "\n"
        printf "${C_B}       ,       ${C_C}                _     _ _                               \n"
        printf "${C_B}      /#\      ${C_C}  __ _ _ __ ___| |__ | (_)_ __  _   ___  __             \n"
        printf "${C_B}     ,###\     ${C_C} / _\` | '__/ __| '_ \| | | '_ \| | | \ \/ /            \n"
        printf "${C_B}    /#####\    ${C_C}| (_| | | | (__| | | | | | | | | |_| |>  <              \n"
        printf "${C_B}   /##;-;##\   ${C_C} \__,_|_|  \___|_| |_|_|_|_| |_|\__,_/_/\_\ ${C_G}TM    \n"
        printf "${C_B}  /##(   )##\`                                                               \n"
        printf "${C_B} /#;--   --;#\  ${C_Y}Gentle Installer. ${mini}${complete}${hard}${standard} \n"
        printf "${C_B}/\`           \`\                                                            \n"
        printf "${N_F}\n"

        printf "\n${C_W}██████████████████████████████████████████████████████████████████████████████████████\n"
        printf "████████████████████████████████████████████████████\n"
        printf "████████████████\n\n${N_F}"

        # INFO:
        # Keep a report of the date and time it was installed.
        
        date | tee > "./installation_date.log"
        printf "${C_C}> ${C_W}Welcome to this gently automated "
        printf "${C_C}Arch/\Linux${N_F} ${C_W}installer. ${C_C}<${N_F}\n\n"

        printf "${C_W}> ${C_P}Before starting, make sure you have ${C_R}no LVM "
        printf "${C_P}configured on your disk, or it will ${C_R}mess up${C_P} "
        printf "the script. You must delete any LV, VG and PV before starting."
        printf "${N_F}\n\n"

        printf "${C_W}> ${C_G}This script is safe to use as it asks the user "
        printf "for any modification. No disk/volume will be touched without "
        printf "you making the selection. ${C_Y}Just BE CAREFUL because "
        printf "actions on disks are ${C_R}IRREVERSIBLE!${N_F}\n\n"

        # INFO: This unmounting action ensure to have nothing actually mounted 
        # on /mnt before starting
        # BUG: 2027-09-28: It cannot unmount everything at the first launch. 
        # We need to quit and restart the script.
        # PASSED: 2027-09-27: It seems to be working now.
        
        systemctl daemon-reload 1> "/dev/null" 2>&1
        local mountpoints=("home" "usr" "var" "tmp")

        for i in "${mountpoints[@]}"; do
                while mountpoint --quiet "/mnt/${i}"; do 
                        if umount --recursive "/mnt/${i}" \
                        1> "/dev/null" 2>&1; then
                                printf "${C_W}> ${SUC} ${C_W}Unmounted "
                                printf  "${C_C}${i}${N_F}.\n"
                        else
                                printf "${C_W}> ${ERR} ${C_W}Error while "
                                printf  "unmounting ${C_C}${i}${C_W}.\n"

                                printf  "You may want to unmount it manually"
                                printf  "before starting the installation.\n"
                        fi
                done
        done
        while mountpoint --quiet "/mnt"; do
                if umount --recursive "/mnt" 1> "/dev/null" 2>&1; then
                        printf "${C_W}> ${SUC} ${C_W}Unmounted ${C_C}/mnt"
                        printf  "${N_F}.\n"
                else
                        printf "${C_W}> ${ERR} ${C_W}Error while unmounting "
                        printf  "${C_C}/mnt${C_W}. You may want to unmount it "
                        printf  "manually before starting the installation."
                        printf  "${N_F}\n"
                fi
        printf "\n"
        done
}
