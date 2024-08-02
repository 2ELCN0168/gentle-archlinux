# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.

ask_packages() {

        while true; do
                echo -e "${B_CYAN} [?] - Do you want to add networking tools (e.g., nload, nethogs, jnettop, iptraf-ng, tcpdump, nmap, bind-tools, ldns, etc.) [Y/n] -> ${NO_FORMAT} \c" 

                declare ans_net_pack=""
                read ans_net_pack
                : "${ans_net_pack:=Y}"
                echo ""

                case "${ans_net_pack}" in
                        "y"|"Y")
                                echo -e "${C_WHITE}> ${INFO} ${C_CYAN}Networking pack${NO_FORMAT} will be installed.\n"
                                additionalPackages="${additionalPackages} bind-tools ldns nmon nload nethogs jnettop iptraf-ng tcpdump nmap"
                                break
                                ;;
                        "n"|"N")
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        while true; do
                echo -e "${B_CYAN} [?] - Do you want to add helping tools (e.g., tealdeer, man, texinfo, etc.) [Y/n] -> ${NO_FORMAT} \c"
                
                declare ans_help_pack=""
                read ans_help_pack
                : "${ans_help_pack:=Y}"
                echo ""

                case "${ans_help_pack}" in
                        "y"|"Y")
                                echo -e "${C_WHITE}> ${INFO} ${C_GREEN}Helping pack${NO_FORMAT} will be installed.\n"
                                additionalPackages="${additionalPackages} texinfo tealdeer man man-pages"
                                break
                                ;;
                        "n"|"N")
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        while true; do
                echo -e "${B_CYAN} [?] - Do you want to add monitoring tools (e.g., btop, htop, bmon, etc.) [Y/n] -> ${NO_FORMAT} \c"
                
                declare ans_monitoring_pack=""
                read ans_monitoring_pack
                : "${ans_monitoring_pack:=Y}"
                echo "" 

                case "${ans_monitoring_pack}" in
                        "y"|"Y")
                                echo -e "${C_WHITE}> ${INFO} ${C_YELLOW}Monitoring pack${NO_FORMAT} will be installed.\n"
                                additionalPackages="${additionalPackages} btop htop bmon"
                                break
                                ;;
                        "n"|"N")
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}

        pacstrap_install() {

        # FORMATTING DONE
        # List of additional packages depending on parameters specified by the user, avoiding installation of useless things
        declare -g additionalPackages=""

        case "${filesystem}" in
                "BTRFS")
                        additionalPackages="${additionalPackages} btrfs-progs"
                        ;;
                "XFS")
                        additionalPackages="${additionalPackages} xfsprogs"
                        ;;
                *)
                        exit 1
                        ;;
        esac

        if [[ "${disk}" =~ "nvme" ]]; then
                additionalPackages="${additionalPackages} nvme-cli libnvme"
        fi

        if [[ "${LVM}" -eq 1 ]]; then
                additionalPackages="${additionalPackages} lvm2"
        fi

        if [[ "${wantEncrypted}" -eq 1 ]]; then
                additionalPackages="${additionalPackages} cryptsetup"
        fi

        if [[ "${bootloader}" == 'REFIND' ]]; then
                additionalPackages="${additionalPackages} refind"
        elif [[ "${bootloader}" == 'GRUB' && "${UEFI}" -eq 1 ]]; then
                additionalPackages="${additionalPackages} grub efibootmgr"
        elif [[ "${bootloader}" == 'GRUB' && "${UEFI}" -eq 0 ]]; then
                additionalPackages="${additionalPackages} grub"
        fi

        if [[ "${cpuBrand}" == 'INTEL' ]]; then
                additionalPackages="${additionalPackages} intel-ucode"
        elif [[ $cpuBrand == 'AMD' ]]; then
                additionalPackages="${additionalPackages} amd-ucode"
        fi

        if [[ "${net_manager}" == 'networkmanager' ]]; then
                additionalPackages="${additionalPackages} networkmanager"
        fi

        # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf
        sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' /etc/pacman.conf

        # Ask for additional packages
        ask_packages

        # Display additional packages
        echo -e "${C_WHITE}> ${INFO} Additional packages are${C_CYAN}${additionalPackages}${NO_FORMAT}\n"
        sleep 4

        # Perform the installation of the customized system
        pacstrap -K /mnt linux{,-{firmware,lts{,-headers}}} base{,-devel} git terminus-font openssh traceroute zsh{,-{syntax-highlighting,autosuggestions,completions,history-substring-search}} \
        systemctl-tui hdparm neovim vim dos2unix tree fastfetch dhclient tmux ${additionalPackages}
        echo -e "\n${C_WHITE}> ${INFO} ${C_RED}Sorry, nano has been deleted from the Arch repository, you will have to learn${NO_FORMAT} ${B_GREEN}Vim${NO_FORMAT}.\n"
}
