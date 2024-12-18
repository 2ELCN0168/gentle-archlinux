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
# Last updated: 2024-11-07
#
### Dependencies:
# - pacman (pactrap script) (included); 
#
### Usage:
#
# 1. It is simple questions/answers.
#

ask_packages() {

        export guest_agent=""

        while true; do

                print_box "Guest agents" "${C_C}" 40 

                printf "${C_W}[0] - ${C_C}qemu-guest-agent (Qemu/Proxmox)"
                printf "${N_F} (default)\n"
                printf "${C_W}[1] - ${C_R}virtualbox-guest-utils (Virtual Box)"
                printf "${N_F}\n"
                printf "${C_W}[2] - ${C_Y}open-vm-tools (VMWare)${N_F}\n"
                printf "${C_W}[3] - ${C_B}hyperv (Hyper-V but not working "
                printf "actually)${N_F}\n"
                printf "${C_W}[4] - ${C_G}None${N_F}\n\n"
                
                printf "────────────────────────────────────────\n\n"

                printf "${C_C}:: ${C_W}Choose the guest-agent you want to "
                printf "install. If none, choose 4. (useful in virtual "
                printf "machine) -> ${N_F}"

                local ans_guest_agent=""
                read ans_guest_agent
                : "${ans_guest_agent:=0}"

                [[ "${ans_guest_agent}" =~ ^[0-4]$ ]] && break || invalid_answer
        done

        case "${ans_guest_agent}" in
                [0])
                        guest_agent="QEMU"
                        printf "${C_W}> ${INFO} ${C_G}qemu-guest-agent" 
                        printf "${N_F} will be installed.\n\n" 
                        additionalPackages+=("qemu-guest-agent")
                        ;;
                [1])
                        guest_agent="VIRTUALBOX"
                        printf "${C_W}> ${INFO} ${C_G}virtualbox-gues" 
                        printf "t-utils${N_F} will be installed.\n\n"
                        additionalPackages+=("virtualbox-guest-utils")
                        ;;
                [2])
                        guest_agent="VMWARE"
                        printf "${C_W}> ${INFO} ${C_G}open-vm-tools"
                        printf "${N_F} will be installed.\n\n"
                        additionalPackages+=("open-vm-tools")
                        ;;
                [3])
                        guest_agent="HYPERV"
                        printf "${C_W}> ${INFO} ${C_G}hyperv${N_F} "
                        printf "will be installed.\n\n"
                        additionalPackages+=("hyperv")
                        ;;
                [4])
                        printf "${C_W}> ${INFO} ${C_G}No guest-agent"
                        printf "${N_F} will be installed.\n\n"
                        ;;
        esac
        
        # INFO:
        # Check post_install/function/f_enable_guest_agents.sh for 
        # enabling guest agents services.

        while true; do
                printf "${C_C}:: ${C_W}Do you want to add networking tools "
                printf "${C_G}(e.g., nload, nethogs, jnettop, iptraf-ng, "
                printf "tcpdump, nmap, bind-tools, ldns, etc.)${C_W} "
                printf "[Y/n] -> ${N_F}" 

                local ans_net_pack=""
                read ans_net_pack
                : "${ans_net_pack:=Y}"

                [[ "${ans_net_pack}" =~ ^[yYnN]$ ]] && break || invalid_answer
        done

        if [[ "${ans_net_pack}" =~ ^[yY]$ ]]; then
                printf "${C_W}> ${INFO} ${C_C}Networking "
                printf "pack${N_F} will be installed.\n\n"
                additionalPackages+=("bind-tools" "ldns" "nmon" "nload"
                "nethogs" "jnettop" "iptraf-ng" "tcpdump" "nmap")
        fi

        while true; do
                printf "${C_C}:: ${C_W}Do you want to add helping tools "
                printf  "${C_G}(e.g., tealdeer, man, texinfo, etc.)"
                printf  "${C_W} [Y/n] -> ${N_F}"
                
                local ans_help_pack=""
                read ans_help_pack
                : "${ans_help_pack:=Y}"

                [[ "${ans_help_pack}" =~ ^[yYnN]$ ]] && break || invalid_answer
        done

        if [[ "${ans_help_pack}" =~ ^[yY]$ ]]; then
                printf "${C_W}> ${INFO} ${C_G}Helping pack${N_F} will "
                printf "be installed.\n\n"
                additionalPackages+=("texinfo" "tealdeer" "man" 
                "man-pages")
        fi

        while true; do
                printf "${C_C}:: ${C_W}Do you want to add monitoring tools "
                printf "${C_G}(e.g., btop, htop, bmon, etc.)${C_W} [Y/n] -> "
                printf "${N_F}"
                
                local ans_monitoring_pack=""
                read ans_monitoring_pack
                : "${ans_monitoring_pack:=Y}" 

                [[ "${ans_help_pack}" =~ ^[yYnN]$ ]] && break || invalid_answer
        done

        if [[ "${ans_monitoring_pack}" =~ ^[yY]$ ]]; then
                printf "${C_W}> ${INFO} ${C_Y}Monitoring pack"
                printf "${N_F} will be installed.\n\n"
                additionalPackages+=("btop" "htop" "bmon" "iotop"
                "bottom")
        fi
}

pacstrap_install() {

        # INFO:
        # List of additional packages depending on parameters specified by the
        # user, avoiding installation of useless things
        additionalPackages=()

        local base_packages=()

        local zsh_packages=(
                "zsh" 
                "zsh-syntax-highlighting" 
                "zsh-autosuggestions"
                "zsh-completions" 
                "zsh-history-substring-search"
        )

        case "${filesystem}" in
                "BTRFS") additionalPackages+=("btrfs-progs") ;;
                "XFS") additionalPackages+=("xfsprogs") ;;
                "EXT4") additionalPackages+=("e2fsprogs") ;;
        esac


        [[ "${disk}" =~ "nvme" ]] && \
        additionalPackages+=("nvme-cli" "libnvme")

        
        [[ "${LVM}" -eq 1 ]] && \
        additionalPackages+=("lvm2")


        [[ "${wantEncrypted}" -eq 1 ]] && \
        additionalPackages+=("cryptsetup")
        

        [[ "${bootloader}" == 'REFIND' ]] && \
        additionalPackages+=("refind")

        [[ "${bootloader}" == 'GRUB' && "${UEFI}" -eq 1 ]] && \
        additionalPackages+=("grub" "efibootmgr")

        [[ "${bootloader}" == 'GRUB' && "${UEFI}" -eq 0 ]] && \
        additionalPackages+=("grub")
        

        case "${cpuBrand}" in
                "INTEL") additionalPackages+=("intel-ucode") ;;
                "AMD") additionalPackages+=("amd-ucode") ;;
        esac
        

        [[ "${net_manager}" == 'networkmanager' ]] && \
        additionalPackages+=("networkmanager")


        case "${linux_kernel}" in
                "linux") 
                        additionalPackages+=("linux" "linux-headers") ;;
                "linux-lts") 
                        additionalPackages+=("linux-lts" "linux-lts-headers") ;;
                "linux-hardened")
                        additionalPackages+=("linux-hardened" 
                        "linux-hardened-headers") ;;
                "linux-zen")
                        additionalPackages+=("linux-zen" "linux-zen-headers") ;;
        esac


        # INFO:
        # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf
        sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' "/etc/pacman.conf"

        # INFO:
        # Ask for additional packages
        ask_packages

        # Display additional packages
        printf "${C_W}> ${INFO} Additional packages are "
        printf "${C_C}${additionalPackages[*]}${N_F}\n\n"
        sleep 4

        # INFO:
        # Perform the installation of the customized system

        local base_packages=("base" "base-devel" "linux-firmware" "eza" "rust"
        "git" "terminus-font" "openssh" "gparted" "wget" "gdisk" "ntfs-3g"
        "traceroute" "systemctl-tui" "hdparm" "neovim" "vim" "vi" "dos2unix"
        "tree" "fastfetch" "dhclient" "tmux" "arch-audit" "xdg-user-dirs"
        "arch-install-scripts")

        pacstrap -K "/mnt" "${base_packages[@]}" "${zsh_packages[@]}" \
        "${additionalPackages[@]}" || exit 1

        printf "\n${C_W}> ${INFO} ${C_R}Sorry, nano has been deleted from the "
        printf "Arch repository, you will have to learn${N_F} ${B_G} Vim ${N_F}"
        printf ".\n\n"
        sleep 2
}
