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
# Last updated: 2024-10-04
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
                printf "==${C_C}GUEST AGENTS${N_F}========\n\n"

                printf "${C_W}[0] - ${C_C}qemu-guest-agent (Qemu/Proxmox)"
                printf "${N_F} (default)\n"
                printf "${C_W}[1] - ${C_R}virtualbox-guest-utils (Virtual Box)"
                printf "${N_F}\n"
                printf "${C_W}[2] - ${C_Y}open-vm-tools (VMWare)${N_F}\n"
                printf "${C_W}[3] - ${C_B}hyperv (Hyper-V but not working "
                printf "actually)${N_F}\n"
                printf "${C_W}[4] - ${C_G}None${N_F}\n"
                
                printf "\n====================\n\n"

                printf "${C_C}:: ${C_W}Choose the guest-agent you want to "
                printf "install. If none, choose 4. (useful in virtual "
                printf "machine) -> ${N_F}"

                local ans_guest_agent=""
                read ans_guest_agent
                : "${ans_guest_agent:=0}"

                case "${ans_guest_agent}" in
                        [0])
                                guest_agent="QEMU"
                                printf "${C_W}> ${INFO} ${C_G}qemu-guest-agent" 
                                printf "${N_F} will be installed.\n\n" 
                                additionalPackages="${additionalPackages} \
                                qemu-guest-agent"
                                break
                                ;;
                        [1])
                                guest_agent="VIRTUALBOX"
                                printf "${C_W}> ${INFO} ${C_G}virtualbox-guest" 
                                printf "-utils${N_F} will be installed.\n\n"
                                additionalPackages="${additionalPackages} \
                                virtualbox-guest-utils"
                                break
                                ;;
                        [2])
                                guest_agent="VMWARE"
                                printf "${C_W}> ${INFO} ${C_G}open-vm-tools"
                                printf "${N_F} will be installed.\n\n"
                                additionalPackages="${additionalPackages} \
                                open-vm-tools"
                                break
                                ;;
                        [3])
                                guest_agent="HYPERV"
                                printf "${C_W}> ${INFO} ${C_G}hyperv${N_F} "
                                printf "will be installed.\n\n"
                                additionalPackages="${additionalPackages} \
                                hyperv"
                                break
                                ;;
                        [4])
                                printf "${C_W}> ${INFO} ${C_G}No guest-agent"
                                printf "${N_F} will be installed.\n\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
                
                # INFO:
                # Check post_install/function/f_enable_guest_agents.sh for 
                # enabling guest agents services.
        done

        while true; do
                printf "${C_C}:: ${C_W}Do you want to add networking tools "
                printf "${C_G}(e.g., nload, nethogs, jnettop, iptraf-ng, "
                printf "tcpdump, nmap, bind-tools, ldns, etc.)${C_W} "
                printf "[Y/n] -> ${N_F}" 

                local ans_net_pack=""
                read ans_net_pack
                : "${ans_net_pack:=Y}"

                if [[ "${ans_net_pack}" =~ [yY] ]]; then
                        printf "${C_W}> ${INFO} ${C_C}Networking "
                        printf "pack${N_F} will be installed.\n\n"
                        additionalPackages="${additionalPackages} bind-tools \
                        ldns nmon nload nethogs jnettop iptraf-ng tcpdump nmap"
                        break
                elif [[ "${ans_net_pack}" =~ [nN] ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        while true; do
                printf "${C_C}:: ${C_W}Do you want to add helping tools "
                printf  "${C_G}(e.g., tealdeer, man, texinfo, etc.)"
                printf  "${C_W} [Y/n] -> ${N_F}"
                
                local ans_help_pack=""
                read ans_help_pack
                : "${ans_help_pack:=Y}"

                if [[ "${ans_help_pack}" =~ [yY] ]]; then
                        printf "${C_W}> ${INFO} ${C_G}Helping pack${N_F} will "
                        printf "be installed.\n\n"
                        additionalPackages="${additionalPackages} texinfo \
                        tealdeer man man-pages"
                        break
                elif [[ "${ans_help_pack}" =~ [nN] ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        while true; do
                printf "${C_C}:: ${C_W}Do you want to add monitoring tools "
                printf "${C_G}(e.g., btop, htop, bmon, etc.)${C_W} [Y/n] -> "
                printf "${N_F}"
                
                local ans_monitoring_pack=""
                read ans_monitoring_pack
                : "${ans_monitoring_pack:=Y}" 

                if [[ "${ans_monitoring_pack}" =~ [yY] ]]; then
                        printf "${C_W}> ${INFO} ${C_Y}Monitoring pack"
                        printf "${N_F} will be installed.\n\n"
                        additionalPackages="${additionalPackages} btop htop \
                        bmon iotop"
                        break
                elif [[ "${ans_monitoring_pack}" =~ [nN] ]]; then
                        break
                else
                        invalid_answer
                fi
        done
}

pacstrap_install() {

        # INFO:
        # List of additional packages depending on parameters specified by the
        # user, avoiding installation of useless things
        additionalPackages=("")

        local zsh_packages=(
                "zsh" 
                "zsh-syntax-highlighting" 
                "zsh-autosuggestions"
                "zsh-completions" 
                "zsh-history-substring-search"
        )

        [[ "${filesystem}" == 'BTRFS' ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "btrfs-progs"
        )

        [[ "${filesystem}" == 'XFS' ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "xfsprogs"
        )

        [[ "${filesystem}" == 'EXT4' ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "e2fsprogs"
        )

        [[ "${disk}" =~ "nvme" ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "nvme-cli"
                "libnvme"
        )

        
        [[ "${LVM}" -eq 1 ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "lvm2"
        )


        [[ "${wantEncrypted}" -eq 1 ]] && \
        additionalPackages=(
                "${additionalPackages}" 
                "cryptsetup"
        )
        

        [[ "${bootloader}" == 'REFIND' ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "refind"
        )

        [[ "${bootloader}" == 'GRUB' && "${UEFI}" -eq 1 ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "grub"
                "efibootmgr"
        )

        [[ "${bootloader}" == 'GRUB' && "${UEFI}" -eq 0 ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "grub"
        )
        

        [[ "${cpuBrand}" == 'INTEL' ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "intel-ucode"
        )

        [[ "${cpuBrand}" == 'AMD' ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "amd-ucode"
        )

        
        [[ "${net_manager}" == 'networkmanager' ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "networkmanager"
        )


        [[ "${linux_kernel}" == "linux" ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "linux"
                "linux-headers"
        )

        [[ "${linux_kernel}" == "linux-lts" ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "linux-lts"
                "linux-lts-headers"
        )

        [[ "${linux_kernel}" == "linux-hardened" ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "linux-hardened"
                "linux-hardened-headers"
        )

        [[ "${linux_kernel}" == "linux-hardened" ]] && \
        additionalPackages=(
                "${additionalPackages}"
                "linux-zen"
                "linux-zen-headers"
        )

        # INFO:
        # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf
        sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' "/etc/pacman.conf"

        # INFO:
        # Ask for additional packages
        ask_packages

        # Display additional packages
        printf "${C_W}> ${INFO} Additional packages are "
        printf "${C_C}${additionalPackages}${N_F}\n"
        sleep 4

        # INFO:
        # Perform the installation of the customized system
        pacstrap -K "/mnt" "base{,-devel} git terminus-font openssh traceroute \
        ${zsh_packages[*]} systemctl-tui hdparm neovim vim vi dos2unix tree \
        fastfetch dhclient tmux arch-audit ${additionalPackages[*]}"

        [[ "${?}" -ne 0 ]] && exit 1

        printf "\n${C_W}> ${INFO} ${C_R}Sorry, nano has been deleted from the "
        printf "Arch repository, you will have to learn${N_F} ${B_G} Vim ${N_F}"
        printf ".\n"
        sleep 2
}
