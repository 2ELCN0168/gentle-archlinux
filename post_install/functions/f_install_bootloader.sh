#
### File: f_install_bootloader.sh
#
### Description: 
# Install different bootloaders with rEFInd as fallback if UEFI mode.
#
### Author: 2ELCN0168
# Last updated: 2024-10-20
# 
### Dependencies:
# - rEFInd (optionnal);
# - GRUB2 (optionnal);
# - systemd-boot (optionnal). 
#
### Usage:
#
# 1. Eval the variable $bootloader and install the appropriate bootloader.
#

install_bootloader() {

        [[ "${bootloader}" == "REFIND" ]] && install_refind
        [[ "${bootloader}" == "GRUB" ]] && install_grub
        [[ "${bootloader}" == "SYSTEMDBOOT" ]] && install_systemdboot
}

declare_bootloader_vars() {

        local rootLine=""
        local isMicrocode=""
        local isBTRFS=""
        local isEncrypt=""
        local isEncryptEnding=""
        local uuid=""
        # x kernel_initramfs="" -> /functions/f_kernel_choice.sh 
}

refind_as_fallback() {

        while true; do
                printf "${C_C}:: ${C_W}Should we install rEFInd? [Y/n] -> "
                printf "${N_F}"

                local ans_install_refind=""
                read ans_install_refind
                : "${ans_install_refind:=Y}"
                printf "\n"

                if [[ "${ans_install_refind}" =~ [yY] ]]; then
                        bootloader="REFIND"
                        install_refind
                        break
                elif [[ "${ans_install_refind}" =~ [nN] ]]; then
                        printf "${C_W}> ${WARN} Fine, I guess you know "
                        printf "what you're doing.\n\n"
                        break
                else
                        invalid_answer
                fi
        done
}

install_refind() {

        declare_bootloader_vars
        
        [[ "${cpuBrand}" == "INTEL" ]] && isMicrocode=" initrd=intel-ucode.img"
        [[ "${cpuBrand}" == "AMD" ]] && isMicrocode=" initrd=amd-ucode.img"

        if [[ "${wantEncrypted}" -eq 1 ]]; then
                rootLine=""
                isEncrypt="rd.luks.name="
                isEncryptEnding="=root root=/dev/mapper/root"
        elif [[ "${wantEncrypted}" -eq 0 ]]; then
                rootLine="root=UUID="
        fi

        [[ "${filesystem}" == "BTRFS" && "${btrfsSubvols}" -eq 1 ]] && \
        isBTRFS=" rootflags=subvol=@"

        [[ "${wantEncrypted}" -eq 1 ]] && \
        uuid=$(blkid -o value -s UUID "${user_disk}2") ||
        uuid=$(blkid -o value -s UUID "${root_part}")

        printf "${C_W}> ${INFO} Installing rEFInd.${N_F}\n"

        if refind-install 1> "/dev/null" 2>&1; then
                printf "${C_W}> ${SUC} ${C_W}rEFInd configuration created "
                printf "successfully.${N_F}\n\n"

                # INFO:
                # This is interesting, it generates the proper refind_linux.conf
                # file with custom parameters, e.g., filesystem and microcode
                printf "${C_W}> ${INFO} ${C_P}\"Archlinux\" \"${rootLine}"
                printf "${isEncrypt}${uuid}${isEncryptEnding} rw "
                printf "initrd=${kernel_initramfs}${isBTRFS}${isMicrocode}\""
                printf "${N_F} to ${C_W}/boot/refind_linux.conf.${N_F}\n\n"

                # local boot_string="\"Arch Linux\" \"${rootLine}${isEncrypt}\
                # ${uuid}${isEncryptEnding} rw initrd=${kernel_initramfs}\
                # ${isBTRFS}${isMicrocode}\""

                local boot_string=$(
                printf "\"Archlinux\" \"%s%s%s%s rw initrd=%s%s%s\"" \
                "${rootLine}" "${isEncrypt}" "${uuid}" "${isEncryptEnding}" \
                "${kernel_initramfs}" "${isBTRFS}" "${isMicrocode}"
                )


                printf "${boot_string}" > "/boot/refind_linux.conf"
        else
                printf "${C_W}> ${ERR} ${C_W}Something went wrong, rEFInd has "
                printf "not been installed, you may want to launch manually "
                printf "\"refind-install\" at the end of the installation. "
                printf "But make sure the file \"/boot/refind_linux.conf\" is "
                printf "correctly set up.\n\n"
        fi
}

install_grub() {

        if [[ "${UEFI}" -eq 1 ]]; then
                printf "${C_W}> ${INFO} Installing grub for EFI to /boot.\n\n"

                if ! grub-install --target=x86_64-efi --efi-directory=/boot \
                --bootloader-id=GRUB 1> "/dev/null" 2>&1; then
                        printf "${C_W}> ${ERR} GRUB installation failed, "
                        printf "trying another method...\n\n"

                        if ! grub-install --target=x86_64-efi \
                        --efi-directory=/boot --bootloader-id=GRUB --removable \
                        --force 1> "/dev/null" 2>&1; then
                                printf "${C_W}> ${ERR} ${C_R}GRUB installation "
                                printf "failed even with different parameters, "
                                printf "you will have to install and configure "
                                printf "a bootloader manually. Good luck."
                                printf "${N_F}\n"
                                refind_as_fallback
                        fi
                fi
        elif [[ "${UEFI}" -eq 0 ]]; then
                printf "${C_W}> ${INFO} Installing grub for BIOS to /boot.\n\n"
                grub-install --target=i386-pc "/dev/${disk}" 1> "/dev/null" 2>&1
        fi

        # TODO:
        # Add a verifcation for partition name with testing if ls 
        # /dev/$partname returns error or not instead of lsblk
        # read -p "Type your root partition name (e.g., sda2, nvme0n1p2 
        # (default=sda2)) -> " partition
        # partition="${partition:-sda2}"
        # partition="/dev/${partition}"

        declare_bootloader_vars

        # INFO:
        # Make a backup of /etc/default/grub
        cp -a "/etc/default/grub" "/etc/default/grub.bak"

        [[ "${cpuBrand}" == "INTEL" ]] && isMicrocode=" initrd=intel-ucode.img"
        [[ "${cpuBrand}" == "AMD" ]] && isMicrocode=" initrd=amd-ucode.img"

        if [[ "${wantEncrypted}" -eq 1 ]]; then
                rootLine=""
                isEncrypt="rd.luks.name="
                isEncryptEnding="=root root=/dev/mapper/root"
                sed -i '/^\s*#\(GRUB_ENABLE_CRYPTODISK\)/ s/^#//' \
                "/etc/default/grub"
        elif [[ "${wantEncrypted}" -eq 0 ]]; then
                rootLine="root=UUID="
        fi

        [[ "${filesystem}" == "BTRFS" && "${btrfsSubvols}" -eq 1 ]] && \
        isBTRFS=" rootflags=subvol=@"

        [[ "${wantEncrypted}" -eq 1 ]] && \
        uuid=$(blkid -o value -s UUID "${user_disk}2") ||
        uuid=$(blkid -o value -s UUID "${root_part}")

        # grubKernelParameters="\"${rootLine}${isEncrypt}${uuid}\
        # ${isEncryptEnding} rw initrd=${kernel_initramfs}\
        # ${isBTRFS}${isMicrocode}\""

        grubKernelParameters=$(
        printf "\"%s%s%s%s rw initrd=%s%s%s\"" \
        "${rootLine}" "${isEncrypt}" "${uuid}" "${isEncryptEnding}" \
        "${kernel_initramfs}" "${isBTRFS}" "${isMicrocode}"
        )
        

        printf "${C_W}> ${INFO} Inserting ${C_P}${grubKernelParameters}${N_F} "
        printf "to /etc/default/grub.\n"

        # INFO:
        # VERY IMPORTANT LINE, SO ANNOYING TO GET IT WORKING, DO NOT DELETE!
        # If it doesn't work anymore, remove brackets to ${grubKernelParameters}
        awk -v params="${grubKernelParameters}" \
        '/GRUB_CMDLINE_LINUX=""/{
                $0 = "GRUB_CMDLINE_LINUX=" params ""
        } 
        1' "/etc/default/grub" > tmpfile && mv tmpfile "/etc/default/grub"
        # Should be reformatted once I have learnt AWK

        grub-mkconfig -o "/boot/grub/grub.cfg"
}

install_systemdboot() {

        declare_bootloader_vars
        # x kernel_name="" -> /functions/f_kernel_choice.sh 

        [[ "${cpuBrand}" == "INTEL" ]] && isMicrocode="initrd=intel-ucode.img"
        [[ "${cpuBrand}" == "AMD" ]] && isMicrocode="initrd=amd-ucode.img"

        if [[ "${wantEncrypted}" -eq 1 ]]; then
                rootLine=""
                isEncrypt="rd.luks.name="
                isEncryptEnding="=root root=/dev/mapper/root"
        elif [[ "${wantEncrypted}" -eq 0 ]]; then
                rootLine="root=UUID="
        fi

        [[ "${filesystem}" == "BTRFS" && "${btrfsSubvols}" -eq 1 ]] && \
        isBTRFS=" rootflags=subvol=@"

        [[ "${wantEncrypted}" -eq 1 ]] && \
        uuid=$(blkid -o value -s UUID "${user_disk}2") ||
        uuid=$(blkid -o value -s UUID "${root_part}")

        printf "${C_W}> ${INFO} Installing ${C_R}systemd-boot.${N_F}\n\n"

        if bootctl install --esp-path="/boot" 1> "/dev/null" 2>&1; then

                printf "title   Archlinux\n" \
                1> "/boot/loader/entries/arch.conf"

                printf "linux   /${kernel_name}\n" \
                1>> "/boot/loader/entries/arch.conf"

                echo -e "initrd  /${kernel_initramfs}\n" \
                1>> "/boot/loader/entries/arch.conf"
                
                [[ -z "${isMicrocode}" ]] && \
                printf "initrd  /${isMicrocode}" \
                1>> "/boot/loader/entries/arch.conf"
                
                local bootctl_options=$(
                printf "options %s%s%s%s rw %s" "${rootLine}" "${isEncrypt}" \
                "${uuid}" "${isEncryptEnding}" "${isBTRFS}"
                )

                printf "\n${bootctl_options}" \
                1>> "/boot/loader/entries/arch.conf"

                printf "${C_W}> ${SUC} Installed ${C_R}systemd-boot.${N_F}\n\n"

                printf "${C_W}> ${INFO} Creating a pacman hook for "
                printf "${C_R}systemd-boot.${N_F}\n"

                [[ ! -e "/etc/pacman.d/hooks" ]] && \
                mkdir -p "/etc/pacman.d/hooks"
                
                cat <<-EOF 1> "/etc/pacman.d/hooks/95-systemd-boot.hook"
                [Trigger]
                Type = Package
                Operation = Upgrade
                Target = systemd

                [Action]
                Description = Gracefully upgrading systemd-boot...
                When = PostTransaction
                Exec = /usr/bin/systemctl restart systemd-boot-update.service
EOF
                # INFO:
                # Remove spaces caused by heredocs >:(
                sed -i 's/^[ \t]*//' "/etc/pacman.d/hooks/95-systemd-boot.hook"

        else
                printf "${C_W}> ${ERR} Error during installation of "
                printf "${C_R}systemd-boot.${N_F}\n\n"

                refind_as_fallback
        fi
}
