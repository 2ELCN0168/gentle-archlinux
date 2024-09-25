# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.

# ask_lvm() {
#
#         export LVM="0"
#
#         # FORMATTING DONE
#         while true; do
#                 echo -e "${C_CYAN}:: ${C_WHITE}It seems that you've picked ${filesystem}, do you want to use LVM? [Y/n] -> ${NO_FORMAT}\c"
#
#                 local ans_lvm=""
#                 read ans_lvm
#                 : "${ans_lvm:=Y}"
#
#                 case "${ans_lvm}" in
#                         [yY])
#                                 echo ""
#                                 LVM="1"
#                                 break
#                                 ;;            
#                         [nN])
#                                 LVM="0"
#                                 echo -e "${C_WHITE}> ${NO_FORMAT}You won't use LVM."
#                                 break
#                                 ;;
#                         *)
#                                 invalid_answer
#                         ;;
#                 esac
#         done
#         lvm
# }

# lvm() {
#
#         # FORMATTING DONE
#
#         local logical_volumes=("root" "usr" "home" "var" "tmp")
#         
#         if [[ "${LVM}" -eq 0 ]]; then
#                 echo -e "${C_WHITE}> ${INFO} ${C_CYAN}Formatting ${root_part} to ${filesystem}.${NO_FORMAT}\n"
#                 case "${filesystem}" in
#                         "XFS")
#                                 mkfs.xfs -f -L Archlinux "${root_part}" 1> "/dev/null" 2>&1
#                                 ;;
#                         "EXT4")
#                                 mkfs.ext4 -L Archlinux "${root_part}" 1> "/dev/null" 2>&1
#                                 ;;
#                 esac 
#                 mount_default
#
#         elif [[ "${LVM}" -eq 1 ]]; then
#                 
#
#                 # echo -e "\n${C_WHITE}> ${INFO} ${NO_FORMAT}You will use LVM.\n"
#                 echo -e "${C_WHITE}> ${INFO} ${C_WHITE}Creating LVM with ${C_CYAN}${disks_array[@]}${NO_FORMAT} with ${C_YELLOW}${filesystem}${NO_FORMAT}...\n"
#
#                 disks_array[0]="${disks_array[0]}2"
#                 pv_array=()
#                 for i in "${disks_array[@]}"; do
#                         sgdisk -Z "${i}" 1> "/dev/null" 2>&1
#                         pvcreate "${i}" 1> "/dev/null" 2>&1
#                         if [[ "${?}" -eq 0 ]]; then
#                                 echo -e "${C_WHITE}> ${INFO} ${C_WHITE}Created PV with ${C_CYAN}${i}${NO_FORMAT}"
#                                 pv_array+=("${i}")
#                         else
#                                 echo -e "${C_WHITE}> ${C_ERR} Error while creating the physical volume with ${C_YELLOW}${i}${NO_FORMAT}. We will not use it."
#                         fi
#                 done
#
#                 echo ""
#
#                 vgcreate VG_Archlinux "${pv_array[@]}" 1> "/dev/null" 2>&1
#
#                 lvcreate -l 20%VG VG_Archlinux -n root
#                 lvcreate -l 40%VG VG_Archlinux -n home
#                 lvcreate -l 20%VG VG_Archlinux -n usr
#                 lvcreate -l 10%VG VG_Archlinux -n var
#                 lvcreate -l 10%VG VG_Archlinux -n tmp
#
#                 local fs=""
#
#                 for i in "${logical_volumes[@]}"; do
#                         # lvcreate -l ${logical_volumes} VG_Archlinux -n ${i} 1> "/dev/null" 2>&1
#                         case "${filesystem}" in
#                                 "XFS")
#                                         fs="xfs"
#                                         ;;
#                                 "EXT4")
#                                         fs=ext4
#                                         ;;
#                         esac
#                         mkfs.${fs} -L Arch_${i} "/dev/mapper/VG_Archlinux-${i}" 1> "/dev/null" 2>&1
#                         echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-${i}${NO_FORMAT} to /mnt/${i}"
#                         if [[ "${i}" == "root" ]]; then
#                                 mount --mkdir "/dev/mapper/VG_Archlinux-${i}" "/mnt"
#                         else 
#                                 mount --mkdir "/dev/mapper/VG_Archlinux-${i}" "/mnt/${i}"
#                         fi
#
#                         if [[ "${?}" -ne 0 ]]; then
#                                 echo -e "${C_WHITE}> ${ERR} Error mounting ${C_CYAN}VG_Archlinux-${i}${NO_FORMAT} to /mnt/${i}"
#                                 exit 1
#                         fi
#                 done
#
#
#
#
#                 # case "${filesystem}" in
#                 #         "XFS")
#                 #                 #TODO: Make a loop for and complete names with vars
#                 #                 
#                 #                 mkfs.xfs -f -L Arch_root "/dev/mapper/VG_Archlinux-root" 1> "/dev/null" 2>&1
#                 #                 mkfs.xfs -f -L Arch_home "/dev/mapper/VG_Archlinux-home" 1> "/dev/null" 2>&1
#                 #                 mkfs.xfs -f -L Arch_usr "/dev/mapper/VG_Archlinux-usr" 1> "/dev/null" 2>&1
#                 #                 mkfs.xfs -f -L Arch_var "/dev/mapper/VG_Archlinux-var" 1> "/dev/null" 2>&1
#                 #                 mkfs.xfs -f -L Arch_tmp "/dev/mapper/VG_Archlinux-tmp" 1> "/dev/null" 2>&1
#                 #                 ;;
#                 #         "EXT4")
#                 #                 mkfs.ext4 -L Arch_root "/dev/mapper/VG_Archlinux-root" 1> "/dev/null" 2>&1
#                 #                 mkfs.ext4 -L Arch_home "/dev/mapper/VG_Archlinux-home" 1> "/dev/null" 2>&1
#                 #                 mkfs.ext4 -L Arch_usr "/dev/mapper/VG_Archlinux-usr" 1> "/dev/null" 2>&1
#                 #                 mkfs.ext4 -L Arch_var "/dev/mapper/VG_Archlinux-var" 1> "/dev/null" 2>&1
#                 #                 mkfs.ext4 -L Arch_tmp "/dev/mapper/VG_Archlinux-tmp" 1> "/dev/null" 2>&1
#                 #                 ;;
#                 # esac 
#
#                 # echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-root${NO_FORMAT} to /mnt\n"
#                 # mount "/dev/mapper/VG_Archlinux-root" "/mnt"
#                 #
#                 # echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-home${NO_FORMAT} to /mnt/home\n"
#                 # mount --mkdir "/dev/mapper/VG_Archlinux-home" "/mnt/home"
#                 #
#                 # echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-usr${NO_FORMAT} to /mnt/usr\n"
#                 # mount --mkdir "/dev/mapper/VG_Archlinux-usr" "/mnt/usr"
#                 #
#                 # echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-var${NO_FORMAT} to /mnt/var\n"
#                 # mount --mkdir "/dev/mapper/VG_Archlinux-var" "/mnt/var"
#                 #
#                 # echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-tmp${NO_FORMAT} to /mnt/tmp\n"
#                 # mount --mkdir "/dev/mapper/VG_Archlinux-tmp" "/mnt/tmp"
#
#                 echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}${boot_part}${NO_FORMAT} to /mnt/boot\n"
#                 mount --mkdir "${boot_part}" "/mnt/boot"
#
#                 root_part="/dev/mapper/VG_Archlinux-root"
#         fi
# }

get_vg_free_space() {
        vgs --noheadings -o vg_free --units G "${1}" | awk '{ print $1 }' | sed 's/G//'
}

lvm_mgmt() {

        # FORMATTING DONE

        local logical_volumes=("root" "usr" "home" "var" "tmp")
        local vg_name="VG_Archlinux"
        declare -A lv_size

        
        
        if [[ "${LVM}" -eq 0 ]]; then
                echo -e "${C_WHITE}> ${INFO} ${C_CYAN}Formatting ${root_part} to ${filesystem}.${NO_FORMAT}\n"
                case "${filesystem}" in
                        "XFS")
                                mkfs.xfs -f -L Archlinux "${root_part}" 1> "/dev/null" 2>&1
                                ;;
                        "EXT4")
                                mkfs.ext4 -L Archlinux "${root_part}" 1> "/dev/null" 2>&1
                                ;;
                esac 
                mount_default

        elif [[ "${LVM}" -eq 1 ]]; then
                

                # echo -e "\n${C_WHITE}> ${INFO} ${NO_FORMAT}You will use LVM.\n"
                echo -e "${C_WHITE}> ${INFO} ${C_WHITE}Creating LVM with ${C_CYAN}${disks_array[@]}${NO_FORMAT} with ${C_YELLOW}${filesystem}${NO_FORMAT}...\n"

                disks_array[0]="${disks_array[0]}2"
                pv_array=()
                for i in "${disks_array[@]}"; do
                        sgdisk -Z "${i}" 1> "/dev/null" 2>&1
                        pvcreate "${i}" 1> "/dev/null" 2>&1
                        if [[ "${?}" -eq 0 ]]; then
                                echo -e "${C_WHITE}> ${INFO} ${C_WHITE}Created PV with ${C_CYAN}${i}${NO_FORMAT}"
                                pv_array+=("${i}")
                        else
                                echo -e "${C_WHITE}> ${C_ERR} Error while creating the physical volume with ${C_YELLOW}${i}${NO_FORMAT}. We will not use it."
                        fi
                done

                echo ""

                vgcreate "${vg_name}" "${pv_array[@]}" 1> "/dev/null" 2>&1
                local vg_free_space=$(get_vg_free_space "${vg_name}")

                echo -e "Espace libre : ${vg_free_space}"

                for lv in "root" "usr" "home" "var" "tmp"; do
                        while true; do
                                read -rp "Taille pour ${lv} ? Max ${vg_free_space} : "  ans_size_lv

                                if (( $(echo "${lv_size[${lv}]} > ${vg_free_space}" | bc -l) )); then
                                        echo -e "Error: Not enough size available"
                                else
                                        break
                                fi
                        done
                        vg_free_space="$(echo ${vg_free_space} - ${lv_size[${lv}]} | bc -l)"

                done

                for i in "${!lv_size[@]}"; do
                        lvcreate -L ${lv_size[${i}]}G "${vg_name}" -n ${i} 1> "/dev/null" 2>&1
                        if [[ "${?}" - ne 0 ]]; then
                                echo -e "Error while creating LV ${i}"
                                exit 1
                        fi
                done



                local fs=""

                for i in "${logical_volumes[@]}"; do
                        # lvcreate -l ${logical_volumes} VG_Archlinux -n ${i} 1> "/dev/null" 2>&1
                        case "${filesystem}" in
                                "XFS")
                                        fs="xfs"
                                        ;;
                                "EXT4")
                                        fs=ext4
                                        ;;
                        esac
                        mkfs.${fs} -L Arch_${i} "/dev/mapper/${vg_name}-${i}" 1> "/dev/null" 2>&1
                        echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}${vg_name}-${i}${NO_FORMAT} to /mnt/${i}"
                        if [[ "${i}" == "root" ]]; then
                                mount --mkdir "/dev/mapper/${vg_name}-${i}" "/mnt"
                        else 
                                mount --mkdir "/dev/mapper/${vg_name}-${i}" "/mnt/${i}"
                        fi

                        if [[ "${?}" -ne 0 ]]; then
                                echo -e "${C_WHITE}> ${ERR} Error mounting ${C_CYAN}${vg_name}-${i}${NO_FORMAT} to /mnt/${i}"
                                exit 1
                        fi
                done




                # case "${filesystem}" in
                #         "XFS")
                #                 #TODO: Make a loop for and complete names with vars
                #                 
                #                 mkfs.xfs -f -L Arch_root "/dev/mapper/VG_Archlinux-root" 1> "/dev/null" 2>&1
                #                 mkfs.xfs -f -L Arch_home "/dev/mapper/VG_Archlinux-home" 1> "/dev/null" 2>&1
                #                 mkfs.xfs -f -L Arch_usr "/dev/mapper/VG_Archlinux-usr" 1> "/dev/null" 2>&1
                #                 mkfs.xfs -f -L Arch_var "/dev/mapper/VG_Archlinux-var" 1> "/dev/null" 2>&1
                #                 mkfs.xfs -f -L Arch_tmp "/dev/mapper/VG_Archlinux-tmp" 1> "/dev/null" 2>&1
                #                 ;;
                #         "EXT4")
                #                 mkfs.ext4 -L Arch_root "/dev/mapper/VG_Archlinux-root" 1> "/dev/null" 2>&1
                #                 mkfs.ext4 -L Arch_home "/dev/mapper/VG_Archlinux-home" 1> "/dev/null" 2>&1
                #                 mkfs.ext4 -L Arch_usr "/dev/mapper/VG_Archlinux-usr" 1> "/dev/null" 2>&1
                #                 mkfs.ext4 -L Arch_var "/dev/mapper/VG_Archlinux-var" 1> "/dev/null" 2>&1
                #                 mkfs.ext4 -L Arch_tmp "/dev/mapper/VG_Archlinux-tmp" 1> "/dev/null" 2>&1
                #                 ;;
                # esac 

                # echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-root${NO_FORMAT} to /mnt\n"
                # mount "/dev/mapper/VG_Archlinux-root" "/mnt"
                #
                # echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-home${NO_FORMAT} to /mnt/home\n"
                # mount --mkdir "/dev/mapper/VG_Archlinux-home" "/mnt/home"
                #
                # echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-usr${NO_FORMAT} to /mnt/usr\n"
                # mount --mkdir "/dev/mapper/VG_Archlinux-usr" "/mnt/usr"
                #
                # echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-var${NO_FORMAT} to /mnt/var\n"
                # mount --mkdir "/dev/mapper/VG_Archlinux-var" "/mnt/var"
                #
                # echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-tmp${NO_FORMAT} to /mnt/tmp\n"
                # mount --mkdir "/dev/mapper/VG_Archlinux-tmp" "/mnt/tmp"

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}${boot_part}${NO_FORMAT} to /mnt/boot\n"
                mount --mkdir "${boot_part}" "/mnt/boot"

                root_part="/dev/mapper/VG_Archlinux-root"
        fi
}
