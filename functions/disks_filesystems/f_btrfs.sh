#
### File: f_btrfs.sh
#
### Description: 
# Handle all the BTRFS filesystem if the user chose to use it. It is not 
# intended to be used with LVM at the moment.
#
### Author: 2ELCN0168
# Last updated: 2024-11-05
#
### Dependencies:
# - btrfs-progs.
#
### Usage:
#
# 1. Usage of subvolumes [Y/n];
# 2. Enabling quotas if subvolumes is set
# 3. Formatting + mounting everything
#
# NOTE:
# This part of the script is important to determine which bootloader can be used
# and how it should be installed.
#

btrfs_mgmt() {

        export btrfsSubvols="0"
        # WARNING:
        # Only add subvolumes after @tmp and @var! Don't change the order.
        local btrfs_subvols=(
                "@" 
                "@home" 
                "@usr" 
                "@tmp" 
                "@var"
        )

        while true; do

                print_box "Subvolumes" "${C_C}" 40 

                printf "${C_W}[0] - ${C_Y}Make subvolumes!${N_F} (default)\n"
                printf "${C_W}[1] - ${C_C}No subvolumes this time${N_F}\n\n"
                
                printf "────────────────────────────────────────\n\n"

                printf "${C_C}:: ${C_W}Do you want to use subvolumes? "
                printf "[0/1] -> ${N_F}"
                
                local ans_btrfs_subvols=""
                read ans_btrfs_subvols
                : "${ans_btrfs_subvols:=0}"

                case "${ans_btrfs_subvols}" in
                        [0])
                                btrfsSubvols=1
                                printf "${C_W}> ${INFO} ${C_G}You chose to "
                                printf "make subvolumes. Good choice.${N_F}\n\n"
                                break
                                ;;
                        [1])
                                btrfsSubvols=0
                                printf "${C_W}> ${INFO} ${C_Y}No subvolume "
                                printf "will be created.${N_F}\n\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
        
        # INFO:
        # Formatting the root partition before creating subvolumes.
        printf "${C_W}> ${INFO} Formatting ${C_C}${root_part}${N_F} to "
        printf "${C_Y}BTRFS.${N_F}\n\n"

        mkfs.btrfs --force --label "Archlinux" "${root_part}" \
        1> "/dev/null" 2>&1

        # INFO:
        # No need to pursuie if the user don't want subvolumes. The function
        # "mount_default" achieves this part.

        [[ "${btrfsSubvols}" -eq 0 ]] && mount_default && return

        # TEST:
        # This part should not be used anymore. Unmounting actions are done in 
        # f_greetings.sh
        #
        # if mountpoint --quiet "/mnt" 1> "/dev/null" 2>&1; then
        #         umount --recursive "/mnt" 1> "/dev/null" 2>&1
        # fi

        # INFO:
        # For BTRFS subvolumes, we first need to mount the root partition before
        # being able to create the subvolumes.
        printf "${C_W}> ${INFO} Mounting ${C_G}${root_part}${N_F} to ${C_P}"
        printf "${C_P}/mnt${N_F}\n"
        if mount "${root_part}" "/mnt" 1> "/dev/null" 2>&1; then
                printf "${C_W}> ${SUC} Mounted ${C_C}${root_part}${N_F} to "
                printf "${C_P}/mnt${N_F}\n"
        else
                printf "${C_W}> ${ERR} Cannot mount ${C_C}${root_part} to "
                printf "${C_P}/mnt${N_F}\n\n"
                exit 1
        fi

        # INFO:
        # Then, create the subvolumes defined above in the table.
        for i in "${btrfs_subvols[@]}"; do
                printf "${C_W}> ${INFO} Creating ${C_Y}subvolume "
                printf "${C_G}${i}${N_F}\n"
                if btrfs subvolume create "/mnt/${i}" 1> "/dev/null" 2>&1; then
                        printf "${C_W}> ${SUC} Created ${C_G}subvolume ${C_Y}"
                        printf "${i}${N_F}\n"
                else 
                        printf "${C_W}> ${ERR} Cannot create subvolume ${C_Y}"
                        printf "${i}${N_F}\n\n"
                        exit 1
                fi
        done

        echo ""
        
        # INFO:
        # Unmount /dev/sdX2 to free the mountpoint for @ subvolume
        umount --recursive "/mnt" 1> "/dev/null" 2>&1

        # INFO:
        # Creating subvolumes and mount them + mount boot partition
        local _mountpoint=""
        for i in "${btrfs_subvols[@]}"; do
                if [[ "${i}" == '@' ]]; then
                        _mountpoint="/mnt"
                else
                        _mountpoint="/mnt/${i//@/}"
                fi
                
                printf "${C_W}> ${INFO} Mounting ${C_G}${i}${N_F} to ${C_P}"
                printf "${_mountpoint}${N_F}\n"
                
                if mount --mkdir --types btrfs --options \
                compress=zstd,discard=async,autodefrag,subvol="${i}" \
                "${root_part}" "${_mountpoint}"; then
                        printf "${C_W}> ${SUC} Mounted ${C_Y}${i}${N_F} to "
                        printf "${C_G}${_mountpoint}${N_F}\n"
                else
                        printf "${C_W}> ${ERR} Cannot Mount ${C_Y}${i}${N_F} "
                        printf "to ${C_R}${_mountpoint}${N_F}\n\n"
                        exit 1
                fi
        done
                
        printf "${C_W}> ${INFO} Mounting ${C_G}/dev/sda1${N_F} to "
        printf "${C_P}/mnt/boot${N_F}\n"

        mount --mkdir "${boot_part}" "/mnt/boot"

        # INFO:
        # Display the result to the user
        printf "\n${C_Y}%s\n\n${N_F}" "$(lsblk --fs)"

        # INFO:
        # Enable quotas? Quit the function if the user doesn't use subvolumes
        [[ "${btrfsSubvols}" -eq 0 ]] && return

        while true; do
                printf "${C_C}:: ${C_W}Do you want to enable quotas on your "
                printf "subvolumes? [Y/n] ${N_F}"

                local ans_btrfs_subvols_quotas=""
                read ans_btrfs_subvols_quotas
                : "${ans_btrfs_subvols_quotas:=Y}"

                case "${ans_btrfs_subvols_quotas}" in
                        [yY])
                                printf "${C_W}> ${INFO} ${C_G}You chose to "
                                printf "enable quotas.${N_F}\n\n"
                                break
                                ;;
                        [nN])
                                printf "${C_W}> ${INFO} ${C_Y}There will be no "
                                printf "quotas on your subvolumes.${N_F}\n\n"
                                return
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        for i in "${btrfs_subvols[@]:3:2}"; do
                local clean_i="${i//@/}"
                printf "${C_W}> ${INFO} Enabling quota for ${C_G}@"
                printf "${clean_i}${N_F}"
                btrfs quota enable "/mnt/${clean_i}"
                btrfs quota rescan "/mnt/${clean_i}" 1> "/dev/null" 2>&1
                btrfs qgroup limit 5G "/mnt/${clean_i}"
        done
}
