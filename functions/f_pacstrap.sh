#
### File: f_pacstrap.sh
#
### Description: 
# Ask the user which packages they want to install. There are predefined
# groups of packages + basic packages that will be installed anyway.
#
# Guest-agent are also asked in case the system is installed inside a
# hypervisor.
#
### Author: 2ELCN0168
# Last updated: 2024-10-03
#
### Dependencies:
# - pacman (pactrap script) (included); 
#
### Usage:
#
# 1. It is simple questions/answers.

ask_packages() {

        export guest_agent=""

        while true; do
                echo -e "==${C_C}GUEST AGENTS${N_F}========\n"

                echo -e "${C_W}[0] - ${C_C}qemu-guest-agent (Qemu/Proxmox)${N_F} (default)"
                echo -e "${C_W}[1] - ${C_R}virtualbox-guest-utils (Virtual Box)${N_F}"
                echo -e "${C_W}[2] - ${C_Y}open-vm-tools (VMWare)${N_F}"
                echo -e "${C_W}[3] - ${C_B}hyperv (Hyper-V but not working actually)${N_F}"
                echo -e "${C_W}[4] - ${C_G}None${N_F}"
                
                echo -e "\n====================\n"

                echo -e "${C_C}:: ${C_W}Choose the guest-agent you want to install, if none, choose 4. (useful in virtual machine) -> ${N_F}\c"

                local ans_guest_agent=""
                read ans_guest_agent
                : "${ans_guest_agent:=0}"

                case "${ans_guest_agent}" in
                        [0])
                                guest_agent="QEMU"
                                echo -e "${C_W}> ${INFO}" \
                                        "${C_G}qemu-guest-agent${N_F}" \
                                        "will be installed.\n"
                                additionalPackages="${additionalPackages} qemu-guest-agent"
                                break
                                ;;
                        [1])
                                guest_agent="VIRTUALBOX"
                                echo -e "${C_W}> ${INFO}" \
                                        "${C_G}virtualbox-guest-utils${N_F}" \
                                        "will be installed.\n"
                                additionalPackages="${additionalPackages} virtualbox-guest-utils"
                                break
                                ;;
                        [2])
                                guest_agent="VMWARE"
                                echo -e "${C_W}> ${INFO}" \
                                        "${C_G}open-vm-tools${N_F}" \
                                        "will be installed.\n"
                                additionalPackages="${additionalPackages} open-vm-tools"
                                break
                                ;;
                        [3])
                                guest_agent="HYPERV"
                                echo -e "${C_W}> ${INFO}" \
                                        "${C_G}hyperv${N_F} will be" \
                                        "installed.\n"
                                additionalPackages="${additionalPackages} hyperv"
                                break
                                ;;
                        [4])
                                echo -e "${C_W}> ${INFO} ${C_G}No" \
                                        "guest-agent${N_F} will be" \
                                        "installed.\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
                
                # INFO:
                # Check post_install/function/f_enable_guest_agents.sh for enabling guest agents services.
        done

        while true; do
                echo -e "${C_C}:: ${C_W}Do you want to add networking" \
                        "tools ${C_G}(e.g., nload, nethogs, jnettop," \
                        "iptraf-ng, tcpdump, nmap, bind-tools, ldns," \
                        "etc.)${C_W} [Y/n] -> ${N_F}\c" 

                local ans_net_pack=""
                read ans_net_pack
                : "${ans_net_pack:=Y}"

                case "${ans_net_pack}" in
                        [yY])
                                echo -e "${C_W}> ${INFO} ${C_C}Networking" \
                                        "pack${N_F} will be installed.\n"
                                additionalPackages="${additionalPackages} bind-tools ldns nmon nload nethogs jnettop iptraf-ng tcpdump nmap"
                                break
                                ;;
                        [nN])
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        while true; do
                echo -e "${C_C}:: ${C_W}Do you want to add helping" \
                        "tools ${C_G}(e.g., tealdeer, man, texinfo," \
                        "etc.)${C_W} [Y/n] -> ${N_F}\c"
                
                local ans_help_pack=""
                read ans_help_pack
                : "${ans_help_pack:=Y}"
                # echo ""

                case "${ans_help_pack}" in
                        [yY])
                                echo -e "${C_W}> ${INFO} ${C_G}Helping" \
                                        "pack${N_F} will be installed.\n"
                                additionalPackages="${additionalPackages} texinfo tealdeer man man-pages"
                                break
                                ;;
                        [nN])
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        while true; do
                echo -e "${C_C}:: ${C_W}Do you want to add monitoring" \
                        "tools ${C_G}(e.g., btop, htop, bmon," \
                        "etc.)${C_W} [Y/n] -> ${N_F}\c"
                
                local ans_monitoring_pack=""
                read ans_monitoring_pack
                : "${ans_monitoring_pack:=Y}"
                # echo "" 

                case "${ans_monitoring_pack}" in
                        [yY])
                                echo -e "${C_W}> ${INFO} ${C_Y}Monitoring" \
                                        "pack${N_F} will be installed.\n"
                                additionalPackages="${additionalPackages} btop htop bmon iotop"
                                break
                                ;;
                        [nN])
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}

pacstrap_install() {

        # INFO:
        # List of additional packages depending on parameters specified by the
        # user, avoiding installation of useless things
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

        # INFO:
        # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf
        sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' "/etc/pacman.conf"

        # INFO:
        # Ask for additional packages
        ask_packages

        # Display additional packages
        echo -e "${C_W}> ${INFO} Additional packages are" \
                "${C_C}${additionalPackages}${N_F}\n"
        sleep 4

        # INFO:
        # Perform the installation of the customized system
        pacstrap -K /mnt base{,-devel} git terminus-font openssh traceroute \
        zsh{,-{syntax-highlighting,autosuggestions,completions,history-substring-search}} \
        systemctl-tui hdparm neovim vim vi dos2unix tree fastfetch dhclient \
        tmux arch-audit ${additionalPackages}
        echo -e "\n${C_W}> ${INFO} ${C_R}Sorry, nano has been deleted" \
                "from the Arch repository, you will have to" \
                "learn${N_F} ${B_G} Vim ${N_F}.\n"
        sleep 2
}
