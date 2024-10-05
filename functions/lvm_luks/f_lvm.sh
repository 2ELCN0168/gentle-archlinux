#
### File: f_lvm.sh
#
### Description: 
# Create LVM if the user chose to do so in a previous question.
# It can be used on several disks at the same time.
#
### Author: 2ELCN0168
# Last updated: 2024-10-04
#
### Dependencies:
# - sgdisk;
# - lvm2;
# - wipefs;
# - bc. 
#
### Usage:
#
# 1. Check the main variables (${LVM} and ${wantEncrypted});
# 2. If it's 1 for ${LVM}, it will install it;
# 3. Else, it will install with default options.
#
# NOTE:
# This part of the script is actually working with EXT4 and XFS.
#
# OPTIMIZE:
# It must be rearranged to be used with LUKS and multiple disks at the same 
# time. Actually, only the first disk will be encrypted, which is not very 
# useful...
#


default_formatting() {

        printf "${C_W}> ${INFO} Formatting ${C_C}${root_part}${N_F} to "
        printf "${C_C}${filesystem}${N_F}.\n\n"

        [[ "${filesystem}" == 'XFS' ]] && mkfs.xfs -f -L Archlinux \
        "${root_part}" 1> "/dev/null" 2>&1
        
        [[ "${filesystem}" == 'EXT4' ]] && mkfs.ext4 -L Archlinux \
        "${root_part}" 1> "/dev/null" 2>&1

        # INFO: 
        # "mount_default()" is defined in "./f_mount_default.sh"
        mount_default
}

lvm_mgmt() {

        # INFO: 
        # Define logical volumes names and disk usage percentages
        logical_volumes=(
                "root;20" 
                "home;20" 
                "usr;20" 
                "var;10" 
                "tmp;10"
        )
        
        # INFO: 
        # Volume Group name for LVM
        local vg_name="VG_Archlinux"

        # INFO: 
        # If LVM is not used, format the root partition with the previous
        # chosen filesystem
        [[ "${LVM}" -eq 0 ]] && default_formatting

        if [[ "${LVM}" -eq 1 ]]; then

                # INFO: 
                # Creating LVM and initialize PVs
                printf "${C_W}> ${INFO} ${C_W}Creating LVM with "
                printf "${C_C}${disks_array[*]}${N_F} with "
                printf "${C_Y}${filesystem}${N_F}...\n\n"

                [[ "${wantEncrypted}" -eq 1 ]] && \
                disks_array[0]="/dev/mapper/root"

                [[ "${wantEncrypted}" -eq 0 ]] && \
                disks_array[0]="${disks_array[0]}2"

                # INFO: 
                # Loop on each disk to initialize the partition table and
                # to create the Physical Volume (LVM)
                pv_array=()
                for i in "${disks_array[@]}"; do
                        sgdisk -Z "${i}" 1> "/dev/null" 2>&1
                        
                        [[ "${i}" != "/dev/mapper/root" ]] && wipefs --all -q \
                        "${i}" 1> "/dev/null" 2>&1

                        pvcreate "${i}" 1> "/dev/null" 2>&1
                        if [[ "${?}" -eq 0 ]]; then
                                printf "${C_W}> ${INFO} ${C_W}Created PV with "
                                printf "${C_C}${i}${N_F}.\n"
                                pv_array+=("${i}")
                        else
                                printf "${C_W}> ${C_ERR} Error while creating "
                                printf "the physical volume with ${C_Y}${i}"
                                printf "${N_F}. We will not use it.\n"
                        fi
                done

                echo ""

                # INFO: 
                # Creating the Volume Group (LVM)

                vgcreate "${vg_name}" "${pv_array[@]}" 1> "/dev/null" 2>&1

                # INFO: 
                # Creating the Logical Volumes (LVM)

                # INFO: 
                # Fetch the Volume Group free space
                local vg_free_space=$(vgs --noheadings -o vg_free \
                --units G "${vg_name}" | awk '{ print int($1) }')
                local ratio=""
                local lv_size=""

                for i in "${logical_volumes[@]}"; do
                        # INFO: 
                        # Get the second part for each index
                        # in ${logical_volumes[@]}
                        local ratio=$(echo ${i} | cut -d ";" -f 2)

                        # INFO: 
                        # And then the first part: the name
                        local lv_name=$(echo ${i} | cut -d ";" -f 1)

                        # INFO: 
                        # Calculate size
                        local lv_size=$(echo "${vg_free_space} * \
                        ${ratio} / 100" | bc)

                        # INFO: 
                        # Round size 
                        local lv_size=$(echo "${lv_size}" | 
                        awk '{printf "%d\n", $1}')

                        printf "${C_W}> ${INFO} ${C_W}Creating LV "
                        printf "${C_C}${lv_name}${N_F} with size "
                        printf "${C_Y}${lv_size}G${N_F}.\n"

                        lvcreate -L "${lv_size}"G "${vg_name}" \
                        -n "${lv_name}" -y 1> "/dev/null" 2>&1

                        if [[ "${?}" -ne 0 ]]; then
                                printf "${C_W}> ${C_ERR} Error while "
                                printf "creating the logical volume "
                                printf "${C_Y}${lv_name}${N_F}. Exiting.\n"
                                exit 1
                        fi
                done

                # INFO: 
                # Formatting and mounting Logical Volumes
                local fs=""

                for i in "${logical_volumes[@]}"; do
                        local lv_name=$(echo "${i}" | cut -d ';' -f 1)

                        [[ "${filesystem}" == "XFS" ]] && fs="xfs"
                        [[ "${filesystem}" == "EXT4" ]] && fs="ext4"

                        
                        mkfs."${fs}" -L Arch_${lv_name} \
                        "/dev/mapper/${vg_name}-${lv_name}" 1> "/dev/null" 2>&1

                        if [[ "${lv_name}" == "root" ]]; then
                                printf "${C_W}> ${INFO} Mounting "
                                printf "${C_C}${vg_name}-${lv_name}${N_F} "
                                printf "to /mnt \n"
                                mount "/dev/mapper/${vg_name}-${lv_name}" "/mnt"
                        else 
                                printf "${C_W}> ${INFO} Mounting "
                                printf "${C_C}${vg_name}-${lv_name}${N_F} "
                                printf "to /mnt/${lv_name}\n"
                                mount --mkdir "/dev/mapper/
                                ${vg_name}-${lv_name}" "/mnt/${lv_name}"
                        fi

                        if [[ "${?}" -ne 0 ]]; then
                                printf "${C_W}> ${ERR} Error while mounting "
                                printf "${C_C}${vg_name}-${lv_name}${N_F} "
                                printf "to /mnt/${lv_name}\n"
                                exit 1
                        fi
                done

                printf "${C_W}> ${INFO} Mounting ${C_C}${boot_part}${N_F} "
                printf "to /mnt/boot\n\n"
                mount --mkdir "${boot_part}" "/mnt/boot"

                # INFO: 
                # Replace ${root_part} with the new LVM root volume 
                # located in "/dev/mapper"
                root_part="/dev/mapper/${vg_name}-root"
        fi
        
        # INFO:
        # Display the result to the user
        printf "\n${C_Y}$(lsblk --fs)\n\n${N_F}"
}
