# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.

ask_packages() {

        export guest_agent=""

        while true; do
                echo -e "==${C_CYAN}GUEST AGENTS${NO_FORMAT}========\n"

                echo -e "${C_WHITE}[0] - ${C_CYAN}qemu-guest-agent (Qemu/Proxmox)${NO_FORMAT} (default)"
                echo -e "${C_WHITE}[1] - ${C_RED}virtualbox-guest-utils (Virtual Box)${NO_FORMAT}"
                echo -e "${C_WHITE}[2] - ${C_YELLOW}open-vm-tools (VMWare)${NO_FORMAT}"
                echo -e "${C_WHITE}[3] - ${C_BLUE}hyperv (Hyper-V but not working actually)${NO_FORMAT}"
                echo -e "${C_WHITE}[4] - ${C_GREEN}None${NO_FORMAT}"
                
                echo -e "\n====================\n"

                echo -e "${C_CYAN}:: ${C_WHITE}Choose the guest-agent you want to install, if none, choose 4. (useful in virtual machine) -> ${NO_FORMAT}\c"

                local ans_guest_agent=""
                read ans_guest_agent
                : "${ans_guest_agent:=0}"

                case "${ans_guest_agent}" in
                        [0])
                                guest_agent="QEMU"
                                echo -e "${C_WHITE}> ${INFO} ${C_GREEN}qemu-guest-agent${NO_FORMAT} will be installed.\n"
                                additionalPackages="${additionalPackages} qemu-guest-agent"
                                break
                                ;;
                        [1])
                                guest_agent="VIRTUALBOX"
                                echo -e "${C_WHITE}> ${INFO} ${C_GREEN}virtualbox-guest-utils${NO_FORMAT} will be installed.\n"
                                additionalPackages="${additionalPackages} virtualbox-guest-utils"
                                break
                                ;;
                        [2])
                                guest_agent="VMWARE"
                                echo -e "${C_WHITE}> ${INFO} ${C_GREEN}open-vm-tools${NO_FORMAT} will be installed.\n"
                                additionalPackages="${additionalPackages} open-vm-tools"
                                break
                                ;;
                        [3])
                                guest_agent="HYPERV"
                                echo -e "${C_WHITE}> ${INFO} ${C_GREEN}hyperv${NO_FORMAT} will be installed.\n"
                                additionalPackages="${additionalPackages} hyperv"
                                break
                                ;;
                        [4])
                                echo -e "${C_WHITE}> ${INFO} ${C_GREEN}No guest-agent${NO_FORMAT} will be installed.\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
                # Check post_install/function/f_enable_guest_agents.sh for enabling guest agents services.
        done

        while true; do
                echo -e "${C_CYAN}:: ${C_WHITE}Do you want to add networking tools ${C_GREEN}(e.g., nload, nethogs, jnettop, iptraf-ng, tcpdump, nmap, bind-tools, ldns, etc.)${C_WHITE} [Y/n] -> ${NO_FORMAT}\c" 

                local ans_net_pack=""
                read ans_net_pack
                : "${ans_net_pack:=Y}"
                # echo ""

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
                echo -e "${C_CYAN}:: ${C_WHITE}Do you want to add helping tools ${C_GREEN}(e.g., tealdeer, man, texinfo, etc.)${C_WHITE} [Y/n] -> ${NO_FORMAT}\c"
                
                local ans_help_pack=""
                read ans_help_pack
                : "${ans_help_pack:=Y}"
                # echo ""

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
                echo -e "${C_CYAN}:: ${C_WHITE}Do you want to add monitoring tools ${C_GREEN}(e.g., btop, htop, bmon, etc.)${C_WHITE} [Y/n] -> ${NO_FORMAT}\c"
                
                local ans_monitoring_pack=""
                read ans_monitoring_pack
                : "${ans_monitoring_pack:=Y}"
                # echo "" 

                case "${ans_monitoring_pack}" in
                        "y"|"Y")
                                echo -e "${C_WHITE}> ${INFO} ${C_YELLOW}Monitoring pack${NO_FORMAT} will be installed.\n"
                                additionalPackages="${additionalPackages} btop htop bmon iotop"
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
        additionalPackages=""

        case "${filesystem}" in
                "BTRFS")
                        additionalPackages="${additionalPackages} btrfs-progs"
                        ;;
                "XFS")
                        additionalPackages="${additionalPackages} xfsprogs"
                        ;;
                "EXT4")
                        additionalPackages="${additionalPackages} e2fsprogs"
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
        elif [[ "${cpuBrand}" == 'AMD' ]]; then
                additionalPackages="${additionalPackages} amd-ucode"
        fi

        if [[ "${net_manager}" == 'networkmanager' ]]; then
                additionalPackages="${additionalPackages} networkmanager"
        fi

        case "${linux_kernel}" in
                "linux")
                        additionalPackages="${additionalPackages} linux linux-headers"
                        ;;
                "linux-lts")
                        additionalPackages="${additionalPackages} linux-lts linux-lts-headers"
                        ;;
                "linux-hardened")
                        additionalPackages="${additionalPackages} linux-hardened linux-hardened-headers"
                        ;;
                "linux-zen")
                        additionalPackages="${additionalPackages} linux-zen linux-zen-headers"
                        ;;
        esac

        # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf
        sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' /etc/pacman.conf

        # Ask for additional packages
        ask_packages

        # Display additional packages
        echo -e "${C_WHITE}> ${INFO} Additional packages are${C_CYAN}${additionalPackages}${NO_FORMAT}\n"
        sleep 4

        # Perform the installation of the customized system
        pacstrap -K /mnt base{,-devel} git terminus-font openssh traceroute zsh{,-{syntax-highlighting,autosuggestions,completions,history-substring-search}} \
        systemctl-tui hdparm neovim vim vi dos2unix tree fastfetch dhclient tmux arch-audit ${additionalPackages}
        echo -e "\n${C_WHITE}> ${INFO} ${C_RED}Sorry, nano has been deleted from the Arch repository, you will have to learn${NO_FORMAT} ${B_GREEN} Vim ${NO_FORMAT}.\n"
        sleep 2
}
