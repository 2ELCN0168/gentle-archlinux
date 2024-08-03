set_time() {

        echo -e "${C_WHITE}> ${INFO} Setting system clock to UTC."

        if hwclock --systohc 1> /dev/null 2>&1; then
                echo -e "${C_WHITE}> ${SUC} ${C_GREEN}Successfully set up system clock to UTC.${NO_FORMAT}\n"
        else
                echo -e "${C_WHITE}> ${WARN} ${C_YELLOW}Failed to setting system clock to UTC.${NO_FORMAT}\n"
        fi

        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} systemd-timesyncd.${NO_FORMAT}"
        
        if systemctl enable systemd-timesyncd 1> /dev/null 2>&1; then
                echo -e "${C_WHITE}> ${SUC} ${C_GREEN}Successfully set up NTP.${NO_FORMAT}\n"
        else
                echo -e "${C_WHITE}> ${WARN} ${C_YELLOW}Failed to setting up NTP.${NO_FORMAT}\n"
        fi

        declare -ig nKorea=0

        while true; do
                echo -e "==TIME==============\n"

                echo -e "${C_WHITE}[0] - ${C_CYAN}FRANCE${NO_FORMAT} [default]"
                echo -e "${C_WHITE}[1] - ${C_WHITE}ENGLAND${NO_FORMAT}"
                echo -e "${C_WHITE}[2] - ${C_WHITE}US (New-York)${NO_FORMAT}"
                echo -e "${C_WHITE}[3] - ${C_RED}Japan${NO_FORMAT}"
                echo -e "${C_WHITE}[4] - ${C_CYAN}South Korea (Seoul)${NO_FORMAT}"
                echo -e "${C_WHITE}[5] - ${C_RED}Russia (Moscow)${NO_FORMAT}"
                echo -e "${C_WHITE}[6] - ${C_RED}China (CST - Shanghai)${NO_FORMAT}"
                echo -e "${C_WHITE}[7] - ${C_RED}North Korea (Pyongyang)${NO_FORMAT}"
                
                echo -e "\n====================\n"

                echo -e "${C_CYAN}:: ${C_WHITE}Where do you live? -> ${NO_FORMAT} \c"

                declare -i ans_localtime=""
                read ans_localtime
                : "${ans_localtime:=0}"
                echo ""

                case "${ans_localtime}" in
                        [0])
                                ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
                                break
                                ;;
                        [1])
                                ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
                                break
                                ;;
                        [2])
                                ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
                                break
                                ;;
                        [3])
                                ln -sf /usr/share/zoneinfo/Japan /etc/localtime
                                break
                                ;;
                        [4])
                                ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
                                break
                                ;;
                        [5])
                                ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
                                break
                                ;;
                        [6])
                                ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
                                break
                                ;;
                        [7])
                                ln -sf /usr/share/zoneinfo/Asia/Pyongyang /etc/localtime
                                nKorea=1
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}

locales_gen() {

        # Uncomment #en_US.UTF-8 UTF-8 in /mnt/etc/locale.gen
        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Uncommenting ${C_CYAN}en_US.UTF-8 UTF-8${NO_FORMAT} in ${C_PINK}/etc/locale.gen${NO_FORMAT}...\n"
        sed -i '/^\s*#\(en_US.UTF-8 UTF-8\)/ s/^#//' /etc/locale.gen

        echo -e "${C_WHITE}> ${INFO} ${C_CYAN}Generating locales...${NO_FORMAT}"

        if locale-gen 1> /dev/null 2>&1; then
                echo -e "${C_WHITE}> ${SUC} ${C_GREEN}Locales generated successfully.${NO_FORMAT}\n"
        else
                echo -e "${C_WHITE}> ${WARN} ${C_YELLOW}Failed to generate locales.${NO_FORMAT}\n"
        fi
}

set_hostname() {

        # Setting up /etc/hostname

        echo -e "${C_CYAN}:: ${C_WHITE}Enter your hostname without domain."
        echo -e "${C_CYAN}:: ${C_WHITE}Recommended hostname length: 15 chars. Default is 'localhost' -> ${NO_FORMAT} \c"

        declare ans_hostname=""
        read ans_hostname
        : "${ans_hostname:=localhost}"
        echo ""

        echo -e "${C_CYAN}:: ${C_WHITE}Enter your domain name. Default is 'home.arpa' (RFC 8375) -> ${NO_FORMAT} \c."

        declare ans_domain_name=""
        read ans_domain_name
        : "${ans_domain_name:=home.arpa}"

        declare -gx domain="${ans_domain_name}"
        declare -gx hostname="${ans_hostname}"

        echo -e "${hostname}.${domain}" > /etc/hostname
        echo -e "\n${C_WHITE}> ${INFO} ${NO_FORMAT}Your hostname will be ${C_CYAN}${hostname}.${domain}${NO_FORMAT} (FQDN).\n"
}

set_hosts() {

        # Setting up /mnt/etc/hosts
        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Setting up ${C_PINK}/etc/hosts${NO_FORMAT}"
        echo -e "> ${C_GREEN}Here is the file:${NO_FORMAT}\n"

        echo -e ":::::::::::::::::::::::::::::::::::::::::::::::::::"
        echo ""
        echo -e "127.0.0.1      localhost.localdomain           localhost                       localhost-ipv4" > /etc/hosts
        echo -e "::1            localhost.localdomain           localhost                       localhost-ipv6" >> /etc/hosts
        echo -e "127.0.0.1      ${hostname}.localdomain         ${hostname}.${domain}           ${hostname}.${domain}-ipv4" >> /etc/hosts
        echo -e "::1            ${hostname}.localdomain         ${hostname}.${domain}           ${hostname}.${domain}-ipv6" >> /etc/hosts
        echo ""
        echo -e ":::::::::::::::::::::::::::::::::::::::::::::::::::"

        cat "/etc/hosts"
        echo ""
        sleep 1
}

set_vconsole() {

        # Creating /mnt/etc/vconsole.conf
        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Creating the file ${C_PINK}/etc/vconsole.conf${NO_FORMAT}."

        declare keymap=""

        while true; do
                echo -e "\n==KEYMAP============\n"

                echo -e "${C_WHITE}[0] - ${C_WHITE}US INTL. - QWERTY${NO_FORMAT} [default]"
                echo -e "${C_WHITE}[1] - ${C_WHITE}US - QWERTY${NO_FORMAT}"
                echo -e "${C_WHITE}[2] - ${C_WHITE}FR - AZERTY${NO_FORMAT}"
                
                echo -e "\n====================\n"

                echo -e "${C_CYAN}:: ${C_WHITE}Select your keymap -> ${NO_FORMAT} \c"

                declare -i ans_keymap=""
                read ans_keymap
                : "${ans_keymap:=0}"
                echo -e "\n"

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

        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_PINK}${keymap}${NO_FORMAT}.\n"
        echo "KEYMAP=${keymap}" > /etc/vconsole.conf
        echo "FONT=ter-116b" >> /etc/vconsole.conf
}

set_pacman() {

        # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf AGAIIIIN
        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Uncommenting ${C_WHITE}'Color'${NO_FORMAT} and ${C_WHITE}'ParallelDownloads 5'${NO_FORMAT} in ${C_PINK}/mnt/etc/pacman.conf${NO_FORMAT} AGAIIIIN.\n"

        #sed -i '/^\s*#\(Color\|ParallelDownloads\)/ s/^#//' /etc/pacman.conf
        sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' /etc/pacman.conf

        if tldr -v 1> /dev/null 2>&1; then
                tldr --update 1> /dev/null 2>&1
        fi
}

set_mkinitcpio() {

        # Making a clean backup of /mnt/etc/mkinitcpio.conf
        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Making a backup of ${C_PINK}/etc/mkinitcpio.conf${NO_FORMAT}..."

        if [[ ! -e "/etc/mkinitcpio.conf.d" ]]; then
                mkdir /etc/mkinitcpio.conf.d
        fi
        cp -a /etc/mkinitcpio.conf /etc/mkinitcpio.conf.d/$(date +%Y%m%d)-mkinitcpio.conf.bak

        # Setting up /etc/mkinitcpio.conf
        declare isBTRFS=""
        declare isLUKS=""
        declare isLVM=""

        if [[ "${filesystem}" == "BTRFS" ]]; then
                isBTRFS="btrfs "
        fi

        if [[ "${wantEncrypted}" -eq 1 ]]; then
                isLUKS="sd-encrypt "
        fi

        if [[ "${LVM}" -eq 1 ]]; then
                isLVM="lvm2 "
        fi

        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Updating ${C_PINK}/etc/mkinitcpio.conf${NO_FORMAT} with custom parameters...\n"

        declare mkcpioHOOKS="HOOKS=(base systemd ${isBTRFS}autodetect modconf kms keyboard sd-vconsole ${isLUKS}block ${isLVM}filesystems fsck)"

        awk -v newLine="$mkcpioHOOKS" '!/^#/ && /HOOKS/ { print newLine; next } 1' /etc/mkinitcpio.conf > tmpfile && mv tmpfile /etc/mkinitcpio.conf

        # Generate initramfs
        mkinitcpio -P
}

set_root_passwd() {

        echo -e "\n${C_WHITE}> ${INFO} ${C_CYAN}Changing root password...${NO_FORMAT}\n"
        while true; do
                if passwd; then
                        break
                fi
        done
        echo ""
}

set_vim_nvim() {

        cat << EOF > /etc/skel/.vimrc
        set number
        set relativenumber
EOF

        cp /etc/skel/.vimrc /root

        mkdir -p /etc/skel/.config/nvim
        cat << EOF > /etc/skel/.config/nvim/init.vim
        set number
        set relativenumber
        syntax on
        set cursorline
EOF

        cp -r /etc/skel/.config /root

}

enable_net_manager() {

        if [[ "${net_manager}" == "networkmanager" ]]; then
                echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} NetworkManager.${NO_FORMAT}\n"
                systemctl enable NetworkManager 1> /dev/null 2>&1
        elif [[ "${net_manager}" == "systemd-networkd" ]]; then
                echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} systemd-networkd.${NO_FORMAT}\n"
                systemctl enable systemd-networkd 1> /dev/null 2>&1
        fi
}

make_config() {

        set_time
        locales_gen
        set_hostname
        set_hosts
        set_vconsole
        set_pacman
        set_mkinitcpio
        set_root_passwd
        set_vim_nvim
        enable_net_manager
}
