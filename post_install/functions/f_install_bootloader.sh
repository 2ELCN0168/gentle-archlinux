install_bootloader() {

        case "${bootloader}" in 
                "REFIND")
                        install_refind
                        ;;
                "GRUB")
                        install_grub
                        ;;
                "SYSTEMDBOOT")
                        install_systemdboot
                        ;;
        esac
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
                echo -e "${C_CYAN}:: ${C_WHITE}Should we install rEFInd? [Y/n] ->${NO_FORMAT} \c"

                local ans_install_refind=""
                read ans_install_refind
                : "${ans_install_refind:=Y}"
                echo ""

                case "${ans_install_refind}" in 
                        "y"|"Y")
                                bootloader="REFIND"
                                install_refind
                                break
                                ;;
                        "n"|"N")
                                echo -e "${C_WHITE}> ${WARN} Fine, I guess you know what you're doing.\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}

install_refind() {

        declare_bootloader_vars

        echo -e "${C_WHITE}> ${INFO} Installing rEFInd.${NO_FORMAT}"
        
        refind-install 1> "/dev/null" 2>&1

        if [[ "${cpuBrand}" == "INTEL" ]]; then
                isMicrocode=" initrd=intel-ucode.img"
        elif [[ "${cpuBrand}" == "AMD" ]]; then
                isMicrocode=" initrd=amd-ucode.img"
        fi

        if [[ "${wantEncrypted}" -eq 1 ]]; then
                rootLine=""
                isEncrypt="rd.luks.name="
                isEncryptEnding="=root root=/dev/mapper/root"
        elif [[ "${wantEncrypted}" -eq 0 ]]; then
                rootLine="root=UUID="
        fi

        if [[ "${filesystem}" == "BTRFS" && "${btrfsSubvols}" -eq 1 ]]; then
                isBTRFS=" rootflags=subvol=@"
        fi
        echo -e "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
        echo -e "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
        echo -e "VARIABLE \$user_disk = ${user_disk}2"
        echo -e "VARIABLE \$root_part = ${root_part}"
        echo -e "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
        echo -e "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
        sleep 2
        
        if [[ "${filesystem}" == "BTRFS" && "${btrfsSubvols}" -eq 1 && "${wantEncrypted}" -eq 1 ]]; then
                uuid=$(blkid -o value -s UUID "${user_disk}2")
                #uuid=$(blkid -o value -s UUID "${user_disk}")
                # A problem has been spotted here. With the former one, it doesn't boot and the blkid command returns nothing.
                # Need to inverstigate.
        else
                uuid=$(blkid -o value -s UUID "$root_part")
        fi






        # This is interesting, it generates the proper refind_linux.conf file with custom parameters, e.g., filesystem and microcode
        echo -e "${C_WHITE}> ${INFO} ${C_PINK}\"Arch Linux\" \"${rootLine}${isEncrypt}${uuid}${isEncryptEnding} rw initrd=${kernel_initramfs}${isBTRFS}${isMicrocode}\"${NO_FORMAT} to ${C_WHITE}/boot/refind-linux.conf.${NO_FORMAT}\n"

        # For Linux kernel
        echo -e \"Arch Linux\" \"${rootLine}${isEncrypt}${uuid}${isEncryptEnding} rw initrd=${kernel_initramfs}${isBTRFS}${isMicrocode}\" > /boot/refind_linux.conf

        echo -e "${C_WHITE}> ${SUC} ${C_WHITE} rEFInd configuration created successfully.${NO_FORMAT}\n"
}

install_grub() {

        if [[ "${UEFI}" -eq 1 ]]; then
                echo -e "${C_WHITE}> ${INFO} Installing grub for EFI to /boot.\n"

                grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 1> /dev/null 2>&1

                if [[ ! "${?}" -eq 0 ]]; then
                        echo -e "${C_WHITE}> ${ERR} GRUB installation failed, trying another method...\n"

                        grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable --force 1> /dev/null 2>&1

                        if [[ ! "${?}" -eq 0 ]]; then
                                echo -e "${C_WHITE}> ${ERR} ${C_RED}GRUB installation failed even with different parameters, you will have to install and configure a bootloader manually. Good luck.${NO_FORMAT}"
                                refind_as_fallback
                                
                        fi
                fi

        elif [[ "${UEFI}" -eq 0 ]]; then
                echo -e "${C_WHITE}> ${INFO} Installing grub for BIOS to /boot.\n"
                grub-install --target=i386-pc /dev/$disk 1> /dev/null 2>&1
        fi

        # Add a verifcation for partition name with testing if ls /dev/$partname returns error or not instead of lsblk
        #read -p "Type your root partition name (e.g., sda2, nvme0n1p2 (default=sda2)) -> " partition
        #partition="${partition:-sda2}"
        #partition="/dev/${partition}"

        declare_bootloader_vars
        #
        # Make a backup of /etc/default/grub
        cp -a /etc/default/grub /etc/default/grub.bak

        if [[ "${cpuBrand}" == "INTEL" ]]; then
                isMicrocode=" initrd=intel-ucode.img"
        elif [[ "${cpuBrand}" == "AMD" ]]; then
                isMicrocode=" initrd=amd-ucode.img"
        fi

        if [[ "${wantEncrypted}" -eq 1 ]]; then
                rootLine=""
                isEncrypt="rd.luks.name="
                isEncryptEnding="=root root=/dev/mapper/root"
                sed -i '/^\s*#\(GRUB_ENABLE_CRYPTODISK\)/ s/^#//' /etc/default/grub
        elif [[ "${wantEncrypted}" -eq 0 ]]; then
                rootLine="root=UUID="
        fi

        if [[ "${filesystem}" == "BTRFS" && "${btrfsSubvols}" -eq 1 ]]; then
                isBTRFS=" rootflags=subvol=@"
        fi

        # uuid=$(blkid -o value -s UUID "$partition")
        uuid=$(blkid -o value -s UUID ${root_part})

        grubKernelParameters="\"${rootLine}${isEncrypt}${uuid}${isEncryptEnding} rw initrd=${kernel_initramfs}${isBTRFS}${isMicrocode}\""
        echo -e "${C_WHITE}> ${INFO} Inserting ${C_PINK}${grubKernelParameters}${NO_FORMAT} to /etc/default/grub."

        # VERY IMPORTANT LINE, SO ANNOYING TO GET IT WORKING, DO NOT DELETE!
        # If it doesn't work anymore, remove brackets to ${grubKernelParameters}
        awk -v params="${grubKernelParameters}" '/GRUB_CMDLINE_LINUX=""/{$0 = "GRUB_CMDLINE_LINUX=" params ""} 1' /etc/default/grub > tmpfile && mv tmpfile /etc/default/grub
        # Should be reformatted once I have learnt AWK

        grub-mkconfig -o /boot/grub/grub.cfg
}

install_systemdboot() {

        declare_bootloader_vars
        # x kernel_name="" -> /functions/f_kernel_choice.sh 

        if [[ "${cpuBrand}" == "INTEL" ]]; then
                isMicrocode="initrd=intel-ucode.img"
        elif [[ "${cpuBrand}" == "AMD" ]]; then
                isMicrocode="initrd=amd-ucode.img"
        fi

        if [[ "${wantEncrypted}" -eq 1 ]]; then
                rootLine=""
                isEncrypt="rd.luks.name="
                isEncryptEnding="=root root=/dev/mapper/root"
        elif [[ "${wantEncrypted}" -eq 0 ]]; then
                rootLine="root=UUID="
        fi

        if [[ "${filesystem}" == "BTRFS" && "${btrfsSubvols}" -eq 1 ]]; then
                isBTRFS=" rootflags=subvol=@"
        fi

        local uuid=$(blkid -o value -s UUID "${root_part}")

        echo -e "${C_WHITE}> ${INFO} Installing ${C_RED}systemd-boot.${NO_FORMAT}\n"


        bootctl install --esp-path=/boot 1> /dev/null 2>&1

        if [[ "${?}" -eq 0 ]]; then
                echo -e "title   Arch Linux" > /boot/loader/entries/arch.conf
                echo -e "linux   /${kernel_name}" >> /boot/loader/entries/arch.conf
                echo -e "initrd  /${kernel_initramfs}" >> /boot/loader/entries/arch.conf
                if [[ -z "${isMicrocode}" ]];then
                        echo -e "initrd  /${isMicrocode}" >> /boot/loader/entries/arch.conf
                fi
                echo -e "options ${rootLine}${isEncrypt}${uuid}${isEncryptEnding} rw ${isBTRFS}" >> /boot/loader/entries/arch.conf

                echo -e "${C_WHITE}> ${SUC} Installed ${C_RED}systemd-boot.${NO_FORMAT}\n"

                if ! ls /etc/pacman.d/hooks; then
                        echo -e "${C_WHITE}> ${INFO} Creating a pacman hook for ${C_RED}systemd-boot.${NO_FORMAT}"

                        if [[ ! -e "/etc/pacman.d/hooks" ]]; then
                                mkdir -p /etc/pacman.d/hooks
                        fi
                        cat << EOF > /etc/pacman.d/hooks/95-systemd-boot.hook
                        [Trigger]
                        Type = Package
                        Operation = Upgrade
                        Target = systemd

                        [Action]
                        Description = Gracefully upgrading systemd-boot...
                        When = PostTransaction
                        Exec = /usr/bin/systemctl restart systemd-boot-update.service
EOF
                fi
        else
                echo -e "${C_WHITE}> ${ERR} Error during installation of ${C_RED}systemd-boot.${NO_FORMAT}\n"

                refind_as_fallback
       fi
}
