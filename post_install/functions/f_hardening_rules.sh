#
### File: f_hardening_rules.sh
#
### Description: 
# If the user chose the option for hardening mode. Execute this part.
# This is a set of recommended actions for hardening a Linux system.
# These recommendations are provided by the ANSI.
#
### Author: 2ELCN0168
# Last updated: 2024-10-06
# 
### Dependencies:
# - auditd. 
#
### Usage:
#
# 1. Create a lot of config files;
# 2. Install what is needed;
# 3. Modify what is needed.
#

hardening_rules() {

        printf "${C_R}> ${INFO} ${C_R}== THE SYSTEM IS BEING HARDENED =="
        printf "\n\n${N_F}"

        # INFO:
        # DISABLE CORE DUMPS
        printf "*         soft    core            0\n" \
        1>> "/etc/security/limits.conf"

        # INFO:
        # BACKUP "/etc/login.defs"
        cp -a "/etc/login.defs" "/etc/login.defs.bak"

        # INFO:
        # ENABLE PASSWORD EXPIRATION ###
        sed -i 's/^\s*PASS_MAX_DAYS.*/PASS_MAX_DAYS  60/' "/etc/login.defs"
        
        # INFO:
        # AUGMENT YESCRYPT COST FACTOR
        sed -i 's/^\s*#\s*YESCRYPT_COST_FACTOR.*/YESCRYPT_COST_FACTOR  8/' \
        "/etc/login.defs"

        # INFO:
        # CHANGE DEFAULT UMASK TO 027
        sed -i 's/^UMASK\s*022/UMASK 027/' "/etc/login.defs"

        # INFO:
        # BLACKLIST USB STORAGE AND FIREWIRE
        printf "blacklist usb-storage" \
        1>> "/etc/modprobe.d/blacklist-usb-storage.conf"

        printf "blacklist firewire-sbp2" \
        1>> "/etc/modprobe.d/blacklist-firewire.conf"

        printf "blacklist firewire-ohci" \
        1>> "/etc/modprobe.d/blacklist-firewire.conf"

        # INFO:
        # DISABLE SOME NETWORK PROTOCOLS
        printf "blacklist dccp" 1>> "/etc/modprobe.d/blacklist-dccp.conf"
        printf "blacklist sctp" 1>> "/etc/modprobe.d/blacklist-sctp.conf"
        printf "blacklist rds" 1>> "/etc/modprobe.d/blacklist-rds.conf"
        printf "blacklist tipc" 1>> "/etc/modprobe.d/blacklist-tipc.conf"

        # INFO:
        # INSTALL cracklib AND libpwquality
        printf "${C_R}> ${INFO} ${C_R}Installing ${C_W}cracklib${C_R} and "
        printf "${C_W}libpwquality${C_R}.${N_F}\n"

        if pacman -S --noconfirm cracklib libpwquality 1> "/dev/null" 2>&1; then
                printf "${C_R}> ${SUC} ${C_R}Installed ${C_W}cracklib${C_R} "
                printf "and ${C_W}libpwquality${C_R}.${N_F}"
        else
                printf "${C_R}> ${ERR} ${C_R}Error during installation of "
                printf "${C_W}cracklib${C_R} and ${C_W}libpwquality${C_R}."
                printf "${N_F}"
        fi

        # INFO:
        # ENABLE auditd.service ###
        printf "${C_R}> ${INFO} ${C_R} systemctl enable ${C_B}auditd.service"
        printf "${C_R}.${N_F}"

        if systemctl enable auditd.service 1> "/dev/null" 2>&1; then
                printf "${C_R}> ${SUC} ${C_G}Enabled ${C_W}auditd.service."
                printf "${N_F}\n"
        else
                printf "${C_R}> ${ERR} Cannot enable ${C_W}auditd.service."
                printf "${N_F}\n"
        fi

        printf "\n"
        printf "${C_R}> ${SUC} ${C_R}== THE SYSTEM HAS BEEN HARDENED ==.${N_F}"
}       
