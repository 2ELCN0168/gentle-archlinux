btrfs_mgmt() {

        # FORMATTING DONE

        export btrfsSubvols="0"
        # Only add subvolumes after @tmp and @var
        btrfs_subvols=("@" "@home" "@usr" "@tmp" "@var")

        while true; do

                echo -e "==${C_CYAN}SUBVOLUMES${NO_FORMAT}========\n"

                echo -e "${C_WHITE}[0] - ${C_YELLOW}Make subvolumes!${NO_FORMAT} (default)"
                echo -e "${C_WHITE}[1] - ${C_CYAN}No subvolumes this time${NO_FORMAT}"
                
                echo -e "\n====================\n"

                echo -e "${C_CYAN}:: ${C_WHITE}Do you want to use subvolumes? [0/1] -> ${NO_FORMAT}\c"
                
                local ans_btrfs_subvols=""
                read ans_btrfs_subvols
                : "${ans_btrfs_subvols:=0}"

                case "${ans_btrfs_subvols}" in
                        [0])
                                btrfsSubvols=1
                                echo -e "${C_WHITE}> ${INFO} ${C_GREEN}You chose to make subvolumes. Good choice.${NO_FORMAT}\n"
                                break
                                ;;
                        [1])
                                btrfsSubvols=0
                                echo -e "${C_WHITE}> ${INFO} ${C_YELLOW}No subvolume will be created.${NO_FORMAT}\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        echo -e "${C_WHITE}> ${INFO} Formatting ${root_part} to ${filesystem}.${NO_FORMAT}\n"
        mkfs.btrfs -f -L Archlinux "${root_part}" 1> "/dev/null" 2>&1

        if [[ "${btrfsSubvols}" -eq 0 ]]; then
                mount_default
                return
        fi

        if mountpoint -q "/mnt" 1> "/dev/null" 2>&1; then
                umount -R "/mnt" 1> "/dev/null" 2>&1
        fi

        if ! mount "${root_part}" "/mnt" 1> "/dev/null" 2>&1; then
                echo -e "Cannot mount ${root_part} to /mnt"
                exit 1
        else
                echo "mounted ${root_part} to /mnt" 1> "/dev/null"
        fi

        for i in "${btrfs_subvols[@]}"; do
                echo -e "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}${i}${NO_FORMAT}"
                if ! btrfs subvolume create "/mnt/${i}" 1> "/dev/null" 2>&1; then
                        echo "Cannot create subvolume ${i}"
                else 
                        echo "Created subvolume ${i}" > "/dev/null"
                fi
        done

        echo ""

        # Unmount /dev/sdX2 to free the mountpoint for @ subvolume
        umount -R "/mnt" 1> "/dev/null" 2>&1

        # Creating subvolumes and mount them + mount boot partition
        local mountpoint=""
        for i in "${btrfs_subvols[@]}"; do
                if [[ "${i}" == '@' ]]; then
                        mountpoint="/mnt"
                else
                        mountpoint="/mnt/${i//@/}"
                fi
                echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}${i}${NO_FORMAT} to ${C_PINK}${mountpoint}${NO_FORMAT}"
                mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol="${i}" "${root_part}" "${mountpoint}"
        done
                
        echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}/dev/sda1${NO_FORMAT} to ${C_PINK}/mnt/boot${NO_FORMAT}\n"
        mount --mkdir "${boot_part}" "/mnt/boot"

        echo ""
        lsblk -f
        echo ""

        # Enable quotas?
        if [[ "${btrfsSubvols}" -eq 1 ]]; then
                while true; do
                        echo -e "${C_CYAN}:: ${C_WHITE}Do you want to enable quotas on your subvolumes? [Y/n] ${NO_FORMAT}\c"

                        local ans_btrfs_subvols_quotas=""
                        read ans_btrfs_subvols_quotas
                        : "${ans_btrfs_subvols_quotas:=Y}"

                        case "${ans_btrfs_subvols_quotas}" in
                                [yY])
                                        echo -e "${C_WHITE}> ${INFO} ${C_GREEN}You chose to enable quotas.${NO_FORMAT}\n"
                                        break
                                        ;;
                                [nN])
                                        echo -e "${C_WHITE}> ${INFO} ${C_YELLOW}There will be no quotas on your subvolumes.${NO_FORMAT}\n"
                                        return
                                        ;;
                                *)
                                        invalid_answer
                                        ;;
                        esac
                done

                for i in "${btrfs_subvols[@]:3:2}"; do
                        local clean_i="${i//@/}"
                        echo -e "${C_WHITE}> ${INFO} Enabling quota for ${C_GREEN}@${clean_i}${NO_FORMAT}"
                        btrfs quota enable "/mnt/${clean_i}"
                        btrfs quota rescan "/mnt/${clean_i}" 1> "/dev/null" 2>&1
                        btrfs qgroup limit 5G "/mnt/${clean_i}"
                done
        fi
}
