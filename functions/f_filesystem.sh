# FUNCTION(S)
# ---
# This function asks the user which filesystem they want to use. 
# Choices are BTRFS (default), XFS, EXT4.
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

filesystem_choice() {

        export filesystem=""

        while true; do
                echo -e "==FILESYSTEM========\n"

                echo -e "${C_WHITE}[0] - ${C_YELLOW}BTRFS${NO_FORMAT} (default)"
                echo -e "${C_WHITE}[1] - ${C_CYAN}XFS${NO_FORMAT}"
                echo -e "${C_WHITE}[2] - ${C_RED}EXT4${NO_FORMAT}"
                
                echo -e "\n====================\n"

                echo -e "${C_CYAN}:: ${C_WHITE}Which filesystem do you want to use? [0/1/2] -> ${NO_FORMAT} \c"
                
                local ans_filesystem=""
                read ans_filesystem
                : "${ans_filesystem:=0}"
                echo ""

                case "${ans_filesystem}" in
                        [0])
                                filesystem="BTRFS"
                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_WHITE}${filesystem}${NO_FORMAT}\n"
                                break
                                ;;
                        [1])
                                filesystem="XFS"
                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_WHITE}${filesystem}${NO_FORMAT}\n"
                                break
                                ;;
                        [2])
                                filesystem="EXT4"
                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_WHITE}${filesystem}${NO_FORMAT}\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}

btrfs_handling() {

        # FORMATTING DONE

        export btrfsSubvols="0"
        local btrfsQuotas=""

        while true; do
                echo -e "${C_CYAN}:: ${C_WHITE}It seems that you've picked BTRFS, do you want a clean installation with subvolumes (0) or a regular one with only the filesystem (1)? (0=default) -> ${NO_FORMAT} \c"

                local ans_btrfs_subvols=""
                read ans_btrfs_subvols
                : "${ans_btrfs_subvols:=0}"
                echo ""

                case "${ans_btrfs_subvols}" in
                        [0])
                                btrfsSubvols="1"
                                echo -e "${C_WHITE}> ${INFO} ${C_GREEN}You chose to make subvolumes. Good choice.${NO_FORMAT}\n"
                                break
                                ;;
                        [1])
                                btrfsSubvols="0"
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
                        echo -e "${C_CYAN}:: ${C_WHITE}Do you want to enable quotas on your subvolumes? [Y/n] ${NO_FORMAT} \c"

                        local ans_btrfs_subvols_quotas=""
                        read ans_btrfs_subvols_quotas
                        : "${ans_btrfs_subvols_quotas:=Y}"
                        echo ""

                        case "${ans_btrfs_subvols_quotas}" in
                                "y"|"Y")
                                        btrfsQuotas="1"
                                        echo -e "${C_WHITE}> ${INFO} ${C_GREEN}You chose to enable quotas.${NO_FORMAT}\n"
                                        break
                                        ;;
                                "n"|"N")
                                        btrfsQuotas="0"
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
        mkfs.btrfs -f -L Archlinux "${root_part}" &> /dev/null

        if [[ "${btrfsSubvols}" -eq 1 ]]; then
                mount "${root_part}" /mnt 1> /dev/null 2>&1
                btrfs subvolume create /mnt/{@,@home,@usr,@tmp,@var} 1> /dev/null 2>&1

                echo -e "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}@${NO_FORMAT}"
                echo -e "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}@home${NO_FORMAT}"
                echo -e "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}@usr${NO_FORMAT}"
                echo -e "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}@tmp${NO_FORMAT}"
                echo -e "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}@var${NO_FORMAT}\n"

                umount -R /mnt 1> /dev/null 2>&1

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@${NO_FORMAT} to ${C_WHITE}/mnt${NO_FORMAT}"
                mount -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@ "${root_part}" /mnt

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@home${NO_FORMAT} to ${C_WHITE}/mnt/home${NO_FORMAT}"
                mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@home "${root_part}" /mnt/home

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@usr${NO_FORMAT} to ${C_WHITE}/mnt/usr${NO_FORMAT}"
                mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@usr "${root_part}" /mnt/usr

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@tmp${NO_FORMAT} to ${C_WHITE}/mnt/tmp${NO_FORMAT}"
                mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@tmp "${root_part}" /mnt/tmp

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@var${NO_FORMAT} to ${C_WHITE}/mnt/var${NO_FORMAT}"
                mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@var "${root_part}" /mnt/var

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}/dev/sda1${NO_FORMAT} to ${C_WHITE}/mnt/boot${NO_FORMAT}\n"
                mount --mkdir "${boot_part}" /mnt/boot
                echo ""

                lsblk -f
        elif [[ "${btrfsSubvols}" -eq 0 ]]; then
                mount_default
        fi


        if [[ "${btrfsSubvols}" -eq 1 && "${btrfsQuotas}" -eq 1 ]]; then

                # MUST BE REFORMATTED

                btrfs quota enable /mnt/var      
                btrfs quota enable /mnt/tmp      
                btrfs quota rescan /mnt/var
                btrfs quota rescan /mnt/tmp
                btrfs qgroup limit 2G /mnt/tmp
                btrfs qgroup limit 5G /mnt/var
        fi
}

fs_handling() {

        export LVM="0"

        # FORMATTING DONE
        while true; do
                echo -e "${C_CYAN}:: ${C_WHITE}It seems that you've picked ${filesystem}, do you want to use LVM? [Y/n] -> ${NO_FORMAT}\c"

                local ans_lvm=""
                read ans_lvm
                : "${ans_lvm:=Y}"
                echo ""

                case "${ans_lvm}" in
                        [yY])
                                LVM="1"
                                break
                                ;;            
                        [nN])
                                LVM="0"
                                echo -e "${C_WHITE}> ${NO_FORMAT}You won't use LVM."
                                break
                                ;;
                        *)
                                invalid_answer
                        ;;
                esac
        done
        lvm_handling
}
