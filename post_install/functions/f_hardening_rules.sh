hardening_rules() {

        echo -e "${C_R}> ${INFO} ${C_R}== THE SYSTEM IS BEING HARDENED ==.${N_F}"

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
        echo -e "${C_R}> ${INFO} ${C_R}Installing ${C_W}cracklib${C_R} and ${C_W}libpwquality${C_R}.${N_F}"
        pacman -S --noconfirm cracklib libpwquality 1> "/dev/null" 2>&1

        if [[ "${?}" -ne 0 ]]; then
                echo -e "${C_R}> ${ERR} ${C_R}Error during installation of ${C_W}cracklib${C_R} and ${C_W}libpwquality${C_R}.${N_F}"
        else
                echo -e "${C_R}> ${SUC} ${C_R}Installed ${C_W}cracklib${C_R} and ${C_W}libpwquality${C_R}.${N_F}"
        fi

        ### ENABLE auditd.service ###
        #

        echo -e "${C_R}> ${INFO} ${C_R} systemctl enable ${C_B}auditd.service${C_R}.${N_F}"

        systemctl enable auditd.service 1> "/dev/null" 2>&1
        if [[ "${?}" -ne 0 ]]; then
                echo -e "${C_R}> ${ERR} Cannot enable ${C_W}auditd.service.${N_F}\n"
        fi

        echo -e "${C_R}> ${SUC} ${C_R}== THE SYSTEM HAS BEEN HARDENED ==.${N_F}"
}       
