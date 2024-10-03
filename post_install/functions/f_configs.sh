set_time() {

        echo -e "${C_W}> ${INFO} Setting system clock to UTC."

        if hwclock --systohc 1> "/dev/null" 2>&1; then
                echo -e "${C_W}> ${SUC} ${C_G}Successfully set up system clock to UTC.${N_F}\n"
        else
                echo -e "${C_W}> ${WARN} ${C_Y}Failed to setting system clock to UTC.${N_F}\n"
        fi

        echo -e "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} systemd-timesyncd.${N_F}"
        
        if systemctl enable systemd-timesyncd 1> "/dev/null" 2>&1; then
                echo -e "${C_W}> ${SUC} ${C_G}Successfully set up NTP.${N_F}\n"
        else
                echo -e "${C_W}> ${WARN} ${C_Y}Failed to setting up NTP.${N_F}\n"
        fi

        nKorea=0
        local country=""

        while true; do
                echo -e "==${C_C}TIME${N_F}==============\n"

                echo -e "${C_W}[0] - ${C_C}France${N_F} [default]"
                echo -e "${C_W}[1] - ${C_W}England${N_F}"
                echo -e "${C_W}[2] - ${C_W}US (New-York)${N_F}"
                echo -e "${C_W}[3] - ${C_R}Japan${N_F}"
                echo -e "${C_W}[4] - ${C_C}South Korea (Seoul)${N_F}"
                echo -e "${C_W}[5] - ${C_R}Russia (Moscow)${N_F}"
                echo -e "${C_W}[6] - ${C_R}China (CST - Shanghai)${N_F}"
                echo -e "${C_W}[7] - ${C_R}North Korea (Pyongyang)${N_F}"
                
                echo -e "\n====================\n"

                echo -e "${C_C}:: ${C_W}Where do you live? -> ${N_F}\c"

                local ans_localtime=""
                read ans_localtime
                : "${ans_localtime:=0}"
                # echo ""

                case "${ans_localtime}" in
                        [0])
                                country="France"
                                ln -sf "/usr/share/zoneinfo/Europe/Paris" "/etc/localtime"
                                break
                                ;;
                        [1])
                                country="England"
                                ln -sf "/usr/share/zoneinfo/Europe/London" "/etc/localtime"
                                break
                                ;;
                        [2])
                                country="the US"
                                ln -sf "/usr/share/zoneinfo/America/New_York" "/etc/localtime"
                                break
                                ;;
                        [3])
                                country="Japan"
                                ln -sf "/usr/share/zoneinfo/Japan" "/etc/localtime"
                                break
                                ;;
                        [4])
                                country="South Korea"
                                ln -sf "/usr/share/zoneinfo/Asia/Seoul" "/etc/localtime"
                                break
                                ;;
                        [5])
                                country="Russia"
                                ln -sf "/usr/share/zoneinfo/Europe/Moscow" "/etc/localtime"
                                break
                                ;;
                        [6])
                                country="China"
                                ln -sf "/usr/share/zoneinfo/Asia/Shanghai" "/etc/localtime"
                                break
                                ;;
                        [7])
                                country="North Korea >:) "
                                ln -sf "/usr/share/zoneinfo/Asia/Pyongyang" "/etc/localtime"
                                nKorea=1
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        echo -e "${C_W}> ${INFO} You live in ${C_Y}${country}${N_F}.\n"
}

locales_gen() {

        # Uncomment #en_US.UTF-8 UTF-8 in /mnt/etc/locale.gen
        echo -e "${C_W}> ${INFO} ${N_F}Uncommenting ${C_C}en_US.UTF-8 UTF-8${N_F} in ${C_P}/etc/locale.gen${N_F}...\n"
        sed -i '/^\s*#\(en_US.UTF-8 UTF-8\)/ s/^#//' "/etc/locale.gen"

        echo -e "${C_W}> ${INFO} ${C_C}Generating locales...${N_F}"

        if locale-gen 1> "/dev/null" 2>&1; then
                echo -e "${C_W}> ${SUC} ${C_G}Locales generated successfully.${N_F}\n"
        else
                echo -e "${C_W}> ${WARN} ${C_Y}Failed to generate locales.${N_F}\n"
        fi
}

set_hostname() {

        # Setting up /etc/hostname

        echo -e "${C_C}:: ${C_W}Enter your hostname without domain."
        echo -e "${C_C}:: ${C_W}Recommended hostname length: 15 chars. Default is 'localhost' -> ${N_F}\c"

        local ans_hostname=""
        read ans_hostname
        : "${ans_hostname:=localhost}"
        echo ""

        echo -e "${C_C}:: ${C_W}Enter your domain name. Default is 'home.arpa' (RFC 8375) -> ${N_F}\c."

        local ans_domain_name=""
        read ans_domain_name
        : "${ans_domain_name:=home.arpa}"

        export domain="${ans_domain_name}"
        export hostname="${ans_hostname}"

        echo -e "${hostname}.${domain}" > "/etc/hostname"
        echo -e "\n${C_W}> ${INFO} ${N_F}Your hostname will be ${C_C}${hostname}.${domain}${N_F} (FQDN).\n"
}

set_hosts() {

        # Setting up /mnt/etc/hosts
        echo -e "${C_W}> ${INFO} ${N_F}Setting up ${C_P}/etc/hosts${N_F}"
        echo -e "> ${C_G}Here is the file:${N_F}\n"

        echo -e "127.0.0.1      localhost.localdomain           localhost                       localhost-ipv4" > "/etc/hosts"
        echo -e "::1            localhost.localdomain           localhost                       localhost-ipv6" >> "/etc/hosts"
        echo -e "127.0.0.1      ${hostname}.localdomain         ${hostname}.${domain}           ${hostname}.${domain}-ipv4" >> "/etc/hosts"
        echo -e "::1            ${hostname}.localdomain         ${hostname}.${domain}           ${hostname}.${domain}-ipv6" >> "/etc/hosts"

        column -t "/etc/hosts" > "/tmp/hosts"
        mv "/tmp/hosts" "/etc/hosts"

        echo -e ":::::::::::::::::::::::::::::::::::::::::::::::::::"
        echo ""
        cat "/etc/hosts"
        echo ""
        echo -e ":::::::::::::::::::::::::::::::::::::::::::::::::::"
        echo ""
}

set_vconsole() {

        # Creating /mnt/etc/vconsole.conf
        echo -e "${C_W}> ${INFO} ${N_F}Creating the file ${C_P}/etc/vconsole.conf${N_F}."

        local keymap=""

        while true; do
                echo -e "\n==${C_C}KEYMAP${N_F}============\n"

                echo -e "${C_W}[0] - ${C_W}US INTL. - QWERTY${N_F} [default]"
                echo -e "${C_W}[1] - ${C_W}US - QWERTY${N_F}"
                echo -e "${C_W}[2] - ${C_W}FR - AZERTY${N_F}"
                
                echo -e "\n====================\n"

                echo -e "${C_C}:: ${C_W}Select your keymap -> ${N_F}\c"

                local ans_keymap=""
                read ans_keymap
                : "${ans_keymap:=0}"
                # echo -e "\n"

                case "${ans_keymap}" in
                        [0])
                                keymap="us-acentos"
                                break
                                ;;
                        [1])
                                keymap="us"
                                break
                                ;;
                        [2])
                                keymap="fr"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        echo -e "${C_W}> ${INFO} ${N_F}You chose ${C_P}${keymap}${N_F}.\n"
        echo "KEYMAP=${keymap}" > "/etc/vconsole.conf"
        echo "FONT=ter-116b" >> "/etc/vconsole.conf"
}

set_pacman() {

        # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf AGAIIIIN
        echo -e "${C_W}> ${INFO} ${N_F}Uncommenting ${C_W}'Color'${N_F} and ${C_W}'ParallelDownloads 5'${N_F} in ${C_P}/mnt/etc/pacman.conf${N_F} AGAIIIIN.\n"

        #sed -i '/^\s*#\(Color\|ParallelDownloads\)/ s/^#//' /etc/pacman.conf
        sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' "/etc/pacman.conf"

        if tldr -v 1> "/dev/null" 2>&1; then
                tldr --update 1> "/dev/null" 2>&1
        fi
}

set_mkinitcpio() {

        # Making a clean backup of /mnt/etc/mkinitcpio.conf
        echo -e "${C_W}> ${INFO} ${N_F}Making a backup of ${C_P}/etc/mkinitcpio.conf${N_F}..."

        if [[ ! -e "/etc/mkinitcpio.conf.d" ]]; then
                mkdir "/etc/mkinitcpio.conf.d"
        fi
        cp -a "/etc/mkinitcpio.conf" "/etc/mkinitcpio.conf.d/$(date +%Y%m%d)-mkinitcpio.conf.bak"

        # Setting up /etc/mkinitcpio.conf
        local isBTRFS=""
        local isLUKS=""
        local isLVM=""

        if [[ "${filesystem}" == "BTRFS" ]]; then
                isBTRFS="btrfs "
        fi

        if [[ "${wantEncrypted}" -eq 1 ]]; then
                isLUKS="sd-encrypt "
        fi

        if [[ "${LVM}" -eq 1 ]]; then
                isLVM="lvm2 "
        fi

        echo -e "${C_W}> ${INFO} ${N_F}Updating ${C_P}/etc/mkinitcpio.conf${N_F} with custom parameters...\n"

        local mkcpioHOOKS="HOOKS=(base systemd ${isBTRFS}autodetect modconf kms keyboard sd-vconsole ${isLUKS}block ${isLVM}filesystems fsck)"

        awk -v newLine="$mkcpioHOOKS" '!/^#/ && /HOOKS/ { print newLine; next } 1' "/etc/mkinitcpio.conf" > tmpfile && mv tmpfile "/etc/mkinitcpio.conf"

        # Generate initramfs
        mkinitcpio -P
}

set_root_passwd() {

        echo -e "\n${C_W}> ${INFO} ${C_C}Changing root password...${N_F}\n"
        while true; do
                if passwd; then
                        break
                fi
        done
        echo ""
}

set_vim_nvim() {

        if [[ "${param_minimal}" -eq 1 ]]; then
                return
        fi

        cat << EOF > "/etc/skel/.vimrc"
        set number
        set relativenumber
EOF

        cp "/etc/skel/.vimrc" "/root"

        mkdir -p "/etc/skel/.config/nvim"
        cat << EOF > "/etc/skel/.config/nvim/init.vim"
        set number
        set relativenumber
        syntax on
        set cursorline
EOF

        cp -r "/etc/skel/.config" "/root"

}

enable_net_manager() {

        if [[ "${net_manager}" == "networkmanager" ]]; then
                echo -e "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} NetworkManager.${N_F}\n"
                systemctl enable NetworkManager 1> "/dev/null" 2>&1
        elif [[ "${net_manager}" == "systemd-networkd" ]]; then
                echo -e "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} systemd-networkd.${N_F}\n"
                systemctl enable systemd-networkd 1> "/dev/null" 2>&1
        fi
}

# make_config() {
#
#         set_time
#         locales_gen
#         set_hostname
#         set_hosts
#         set_vconsole
#         set_pacman
#         set_mkinitcpio
#         set_root_passwd
#         set_vim_nvim
#         enable_net_manager
# }
