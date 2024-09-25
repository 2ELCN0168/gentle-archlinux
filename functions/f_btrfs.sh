btrfs() {

        # FORMATTING DONE

        export btrfsSubvols="0"
        local btrfsQuotas=""
        btrfs_subvols=("@root" "@home" "@usr" "@tmp" "@var")

        while true; do
                echo -e "${C_CYAN}:: ${C_WHITE}It seems that you've picked BTRFS, do you want a clean installation with subvolumes (0) or a regular one with only the filesystem (1)? (0=default) -> ${NO_FORMAT}\c"

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

        if [ "${btrfsSubvols}" -eq 1 ]; then
                while true; do
                        echo -e "${C_CYAN}:: ${C_WHITE}Do you want to enable quotas on your subvolumes? [Y/n] ${NO_FORMAT}\c"

                        local ans_btrfs_subvols_quotas=""
                        read ans_btrfs_subvols_quotas
                        : "${ans_btrfs_subvols_quotas:=Y}"

                        case "${ans_btrfs_subvols_quotas}" in
                                "y"|"Y")
                                        btrfsQuotas=1
                                        echo -e "${C_WHITE}> ${INFO} ${C_GREEN}You chose to enable quotas.${NO_FORMAT}\n"
                                        break
                                        ;;
                                "n"|"N")
                                        btrfsQuotas=0
                                        echo -e "${C_WHITE}> ${INFO} ${C_YELLOW}There will be no quotas on your subvolumes.${NO_FORMAT}\n"
                                        break
                                        ;;
                                *)
                                        invalid_answer
                                        ;;
                        esac
                done
        fi

        echo -e "${C_WHITE}> ${INFO} Formatting ${root_part} to ${filesystem}.${NO_FORMAT}\n"
        mkfs.btrfs -f -L Archlinux "${root_part}" 1> "/dev/null" 2>&1

        if [[ "${btrfsSubvols}" -eq 0 ]]; then
                mount_default
                return
        fi

        echo -e "root part is ${root_part}"
        if ! mount "${root_part}" "/mnt"; then #1> "/dev/null" 2>&1
                echo -e "Cannot mount ${root_part} to /mnt"
                exit 1
        else
                echo "mounted ${root_part} to /mnt"
        fi

        # for i in "${btrfs_subvols[@]}"; do
                # echo -e "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}${i}${NO_FORMAT}"
        #         # if ! btrfs subvolume create "/mnt/${r}"; then # 1> "/dev/null" 2>&1
        #         #         echo "Cannot create subvolume ${r}"
        #         # fi
        #         # if [[ "${?}" -ne 0 ]]; then
        #         #         echo "Something went wrong"
        #         # else
        #         #         echo "Created subvolume ${i}"
        #         # fi
        # done
        # 
        # if ! btrfs subvolume create "/mnt/${btrfs_subvols[0]}"; then
        #         echo -e "Error while creating the subvolumes. Exiting."
        #         exit 1
        # fi
        # if ! btrfs subvolume create "/mnt/${btrfs_subvols[1]}"; then
        #         echo -e "Error while creating the subvolumes. Exiting."
        #         exit 1
        # fi
        # if ! btrfs subvolume create "/mnt/${btrfs_subvols[2]}"; then
        #         echo -e "Error while creating the subvolumes. Exiting."
        #         exit 1
        # fi
        # if ! btrfs subvolume create "/mnt/${btrfs_subvols[3]}"; then
        #         echo -e "Error while creating the subvolumes. Exiting."
        #         exit 1
        # fi
        # if ! btrfs subvolume create "/mnt/${btrfs_subvols[4]}"; then
        #         echo -e "Error while creating the subvolumes. Exiting."
        #         exit 1
        # fi

        btrfs subvolume create /mnt/@
        btrfs subvolume create /mnt/@home
        btrfs subvolume create /mnt/@usr
        btrfs subvolume create /mnt/@var
        btrfs subvolume create /mnt/@tmp
        echo ""

        umount -R "/mnt" 1> "/dev/null" 2>&1

        echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@${NO_FORMAT} to ${C_WHITE}/mnt${NO_FORMAT}"
        mount -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@ "${root_part}" "/mnt"

        echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@home${NO_FORMAT} to ${C_WHITE}/mnt/home${NO_FORMAT}"
        mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@home "${root_part}" "/mnt/home"

        echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@usr${NO_FORMAT} to ${C_WHITE}/mnt/usr${NO_FORMAT}"
        mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@usr "${root_part}" "/mnt/usr"

        echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@tmp${NO_FORMAT} to ${C_WHITE}/mnt/tmp${NO_FORMAT}"
        mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@tmp "${root_part}" "/mnt/tmp"

        echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@var${NO_FORMAT} to ${C_WHITE}/mnt/var${NO_FORMAT}"
        mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@var "${root_part}" "/mnt/var"

        echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}/dev/sda1${NO_FORMAT} to ${C_WHITE}/mnt/boot${NO_FORMAT}\n"
        mount --mkdir "${boot_part}" "/mnt/boot"
        echo ""

        lsblk -f


        if [[ "${btrfsQuotas}" -eq 1 ]]; then

                # MUST BE REFORMATTED

                btrfs quota enable "/mnt/var"
                btrfs quota enable "/mnt/tmp"
                btrfs quota rescan "/mnt/var"
                btrfs quota rescan "/mnt/tmp"
                btrfs qgroup limit 2G "/mnt/tmp"
                btrfs qgroup limit 5G "/mnt/var"
        fi
}
