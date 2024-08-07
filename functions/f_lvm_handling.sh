# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.

lvm_handling() {

        # FORMATTING DONE
        if [[ "${LVM}" -eq 0 ]]; then
                echo -e "${C_WHITE}> ${INFO} ${C_CYAN}Formatting ${root_part} to ${filesystem}.${NO_FORMAT}\n"
                case "${filesystem}" in
                        "XFS")
                                mkfs.xfs -f -L Archlinux "${root_part}" 1> /dev/null 2>&1
                                ;;
                        "EXT4")
                                mkfs.ext4 -L Archlinux "${root_part}" 1> /dev/null 2>&1
                                ;;
                esac 
                mount_default

        elif [[ "${LVM}" -eq 1 ]]; then
                echo -e "\n${C_WHITE}> ${INFO} ${NO_FORMAT}You will use LVM.\n"
                echo -e "${C_WHITE}> ${INFO} ${C_CYAN}Creating LVM to ${root_part} with ${filesystem}...${NO_FORMAT}\n"

                pvcreate "${root_part}"
                vgcreate VG_Archlinux "${root_part}"
                lvcreate -l 20%VG VG_Archlinux -n root
                lvcreate -l 40%VG VG_Archlinux -n home
                lvcreate -l 20%VG VG_Archlinux -n usr
                lvcreate -l 10%VG VG_Archlinux -n var
                lvcreate -l 10%VG VG_Archlinux -n tmp

                case "${filesystem}" in
                        "XFS")
                                mkfs.xfs -f -L Arch_root /dev/mapper/VG_Archlinux-root 1> /dev/null 2>&1
                                mkfs.xfs -f -L Arch_home /dev/mapper/VG_Archlinux-home 1> /dev/null 2>&1
                                mkfs.xfs -f -L Arch_usr /dev/mapper/VG_Archlinux-usr 1> /dev/null 2>&1
                                mkfs.xfs -f -L Arch_var /dev/mapper/VG_Archlinux-var 1> /dev/null 2>&1
                                mkfs.xfs -f -L Arch_tmp /dev/mapper/VG_Archlinux-tmp 1> /dev/null 2>&1
                                ;;
                        "EXT4")
                                mkfs.ext4 -L Arch_root /dev/mapper/VG_Archlinux-root 1> /dev/null 2>&1
                                mkfs.ext4 -L Arch_home /dev/mapper/VG_Archlinux-home 1> /dev/null 2>&1
                                mkfs.ext4 -L Arch_usr /dev/mapper/VG_Archlinux-usr 1> /dev/null 2>&1
                                mkfs.ext4 -L Arch_var /dev/mapper/VG_Archlinux-var 1> /dev/null 2>&1
                                mkfs.ext4 -L Arch_tmp /dev/mapper/VG_Archlinux-tmp 1> /dev/null 2>&1
                                ;;
                esac 

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-root${NO_FORMAT} to /mnt\n"
                mount /dev/mapper/VG_Archlinux-root /mnt

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-home${NO_FORMAT} to /mnt/home\n"
                mount --mkdir /dev/mapper/VG_Archlinux-home /mnt/home

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-usr${NO_FORMAT} to /mnt/usr\n"
                mount --mkdir /dev/mapper/VG_Archlinux-usr /mnt/usr

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-var${NO_FORMAT} to /mnt/var\n"
                mount --mkdir /dev/mapper/VG_Archlinux-var /mnt/var

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-tmp${NO_FORMAT} to /mnt/tmp\n"
                mount --mkdir /dev/mapper/VG_Archlinux-tmp /mnt/tmp

                echo -e "${C_WHITE}> ${INFO} Mounting ${C_CYAN}${boot_part}${NO_FORMAT} to /mnt/boot\n"
                mount --mkdir "${boot_part}" /mnt/boot

                root_part="/dev/mapper/VG_Archlinux-root"
        fi
}
