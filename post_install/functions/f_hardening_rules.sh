hardening_rules() {

        echo -e "${C_RED}> ${INFO} ${C_RED}== THE SYSTEM IS BEING HARDENED ==.${NO_FORMAT}"

        ### DISABLE CORE DUMPS ###
        #
        echo "*         soft    core            0" >> "/etc/security/limits.conf"

        ### BACKUP "/etc/login.defs" ###
        # 
        cp -a "/etc/login.defs" "/etc/login.defs.bak"

        ### ENABLE PASSWORD EXPIRATION ###
        #
        sed -i 's/^\s*PASS_MAX_DAYS.*/PASS_MAX_DAYS  60/' "/etc/login.defs"
        
        ### AUGMENT YESCRYPT COST FACTOR ###
        #
        sed -i 's/^\s*#\s*YESCRYPT_COST_FACTOR.*/YESCRYPT_COST_FACTOR  8/' "/etc/login.defs"

        ### CHANGE DEFAULT UMASK TO 027 ###
        #
        sed -i 's/^UMASK\s*022/UMASK 027/' "/etc/login.defs"

        ### BLACKLIST USB STORAGE AND FIREWIRE ###
        #
        echo "blacklist usb-storage" >> "/etc/modprobe.d/blacklist-usb-storage.conf"

        echo "blacklist firewire-sbp2" >> "/etc/modprobe.d/blacklist-firewire.conf"
        echo "blacklist firewire-ohci" >> "/etc/modprobe.d/blacklist-firewire.conf"

        ### DISABLE SOME NETWORK PROTOCOLS ###
        #

        echo "blacklist dccp" >> "/etc/modprobe.d/blacklist-dccp.conf"
        echo "blacklist sctp" >> "/etc/modprobe.d/blacklist-sctp.conf"
        echo "blacklist rds" >> "/etc/modprobe.d/blacklist-rds.conf"
        echo "blacklist tipc" >> "/etc/modprobe.d/blacklist-tipc.conf"

        ### INSTALL cracklib AND libpwquality
        #
        echo -e "${C_RED}> ${INFO} ${C_RED}Installing ${C_WHITE}cracklib${C_RED} and ${C_WHITE}libpwquality${C_RED}.${NO_FORMAT}"
        pacman -S --noconfirm cracklib libpwquality 1> "/dev/null" 2>&1

        if [[ "${?}" -ne 0 ]]; then
                echo -e "${C_RED}> ${ERR} ${C_RED}Error during installation of ${C_WHITE}cracklib${C_RED} and ${C_WHITE}libpwquality${C_RED}.${NO_FORMAT}"
        else
                echo -e "${C_RED}> ${SUC} ${C_RED}Installed ${C_WHITE}cracklib${C_RED} and ${C_WHITE}libpwquality${C_RED}.${NO_FORMAT}"
        fi

        ### ENABLE auditd.service ###
        #

        echo -e "${C_RED}> ${INFO} ${C_RED} systemctl enable ${C_BLUE}auditd.service${C_RED}.${NO_FORMAT}"

        systemctl enable auditd.service 1> "/dev/null" 2>&1
        if [[ "${?}" -ne 0 ]]; then
                echo -e "${C_RED}> ${ERR} Cannot enable ${C_WHITE}auditd.service.${NO_FORMAT}\n"
        fi

        echo -e "${C_RED}> ${SUC} ${C_RED}== THE SYSTEM HAS BEEN HARDENED ==.${NO_FORMAT}"
}       
