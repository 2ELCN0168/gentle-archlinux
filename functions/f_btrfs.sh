#
### File: f_btrfs.sh
#
### Description: 
# Handle all the BTRFS filesystem if the user chose to use it. It is not intended
# to be used with LVM at the moment.
#
### Author: 2ELCN0168
# Last updated: 2024-09-30
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

                echo -e "==${C_C}SUBVOLUMES${N_F}========\n"

                echo -e "${C_W}[0] - ${C_Y}Make subvolumes!${N_F} (default)"
                echo -e "${C_W}[1] - ${C_C}No subvolumes this time${N_F}"
                
                echo -e "\n====================\n"

                echo -e "${C_C}:: ${C_W}Do you want to use subvolumes? [0/1] -> ${N_F}\c"
                
                local ans_btrfs_subvols=""
                read ans_btrfs_subvols
                : "${ans_btrfs_subvols:=0}"

                case "${ans_btrfs_subvols}" in
                        [0])
                                btrfsSubvols=1
                                echo -e "${C_W}> ${INFO} ${C_G}You chose" \
                                        "to make subvolumes. Good choice.${N_F}\n"
                                break
                                ;;
                        [1])
                                btrfsSubvols=0
                                echo -e "${C_W}> ${INFO} ${C_Y}No subvolume" \
                                        "will be created.${N_F}\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
        
        # INFO:
        # Formatting the root partition before creating subvolumes.
        echo -e "${C_W}> ${INFO} Formatting ${root_part}" \
                "to ${filesystem}.${N_F}\n"
        mkfs.btrfs --force --label "Archlinux" "${root_part}" 1> "/dev/null" 2>&1

        # INFO:
        # No need to pursuie if the user don't want subvolumes. The function
        # "mount_default" achieves this part.
        if [[ "${btrfsSubvols}" -eq 0 ]]; then
                mount_default
                return
        fi

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
        if ! mount "${root_part}" "/mnt" 1> "/dev/null" 2>&1; then
                echo -e "Cannot mount ${root_part} to /mnt"
                exit 1
        else
                echo "mounted ${root_part} to /mnt" 1> "/dev/null"
        fi

        # INFO:
        # Then, create the subvolumes defined above in the table.
        for i in "${btrfs_subvols[@]}"; do
                echo -e "${C_W}> ${INFO} Creating${N_F}" \
                        "${C_Y}subvolume ${C_G}${i}${N_F}"
                if ! btrfs subvolume create "/mnt/${i}" 1> "/dev/null" 2>&1; then
                        echo "Cannot create subvolume ${i}"
                else 
                        echo "Created subvolume ${i}" > "/dev/null"
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
                
                echo -e "${C_W}> ${INFO} Mounting ${C_G}${i}" \
                        "${N_F}to ${C_P}${_mountpoint}${N_F}"
                
                mount --mkdir --types btrfs --options \
                compress=zstd,discard=async,autodefrag,subvol="${i}" \
                "${root_part}" "${_mountpoint}"
        done
                
        echo -e "${C_W}> ${INFO} Mounting ${C_G}/dev/sda1${N_F}" \
                "to ${C_P}/mnt/boot${N_F}\n"
        mount --mkdir "${boot_part}" "/mnt/boot"

        # INFO:
        # Display the result to the user
        echo ""
        lsblk --fs
        echo ""

        # INFO:
        # Enable quotas? Quit the function if the user doesn't use subvolumes
        if [[ "${btrfsSubvols}" -eq 0 ]]; then
                return
        fi

        while true; do
                echo -e "${C_C}:: ${C_W}Do you want to enable" \
                        "quotas on your subvolumes? [Y/n] ${N_F}\c"

                local ans_btrfs_subvols_quotas=""
                read ans_btrfs_subvols_quotas
                : "${ans_btrfs_subvols_quotas:=Y}"

                case "${ans_btrfs_subvols_quotas}" in
                        [yY])
                                echo -e "${C_W}> ${INFO} ${C_G}You chose" \
                                        "to enable quotas.${N_F}\n"
                                break
                                ;;
                        [nN])
                                echo -e "${C_W}> ${INFO} ${C_Y}There will" \
                                        "be no quotas on your subvolumes.${N_F}\n"
                                return
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        for i in "${btrfs_subvols[@]:3:2}"; do
                local clean_i="${i//@/}"
                echo -e "${C_W}> ${INFO} Enabling quota for" \
                        "${C_G}@${clean_i}${N_F}"
                btrfs quota enable "/mnt/${clean_i}"
                btrfs quota rescan "/mnt/${clean_i}" 1> "/dev/null" 2>&1
                btrfs qgroup limit 5G "/mnt/${clean_i}"
        done
}
