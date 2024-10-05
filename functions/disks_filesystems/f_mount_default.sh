#
### File: f_mount_default.sh
#
### Description: 
# This is the default function for mounting the root partition after a simple 
# formatting with no lvm or subvolumes. It mounts the boot partition too.
#
### Author: 2ELCN0168
# Last updated: 2024-10-04
#
### Dependencies:
# - none. 
#
### Usage:
#
# 1. Mount the root partition;
# 2. Mount the boot partition.
#

mount_default() {

        printf "${C_W}> ${INFO} Mounting ${C_G}${root_part}${N_F} to /mnt\n"
        if mount "${root_part}" "/mnt" 1> "/dev/null" 2>&1; then
                printf "${C_W}> ${SUC} Mounted ${C_G}${root_part}${N_F} "
                printf "to /mnt/boot\n"
        else
                printf "${C_W}> ${ERR} Error while mounting "
                printf  "${C_G}${root_part}${N_F} to /mnt/boot\n\n"
                exit 1
        fi

        printf "${C_W}> ${INFO} Mounting ${C_G}${boot_part}${N_F} to /mnt/boot"
        if mount --mkdir "${boot_part}" "/mnt/boot" 1> "/dev/null" 2>&1; then
                printf "${C_W}> ${SUC} Mounted ${C_G}${boot_part}"
                printf  "${N_F} to /mnt/boot\n\n"
        else
                printf "${C_W}> ${ERR} Error while mounting"
                printf  "${C_G}${boot_part}${N_F} to /mnt/boot\n\n"
                exit 1
        fi
}
