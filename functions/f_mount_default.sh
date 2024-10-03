#
### File: f_mount_default.sh
#
### Description: 
# This is the default function for mounting the root partition after a simple 
# formatting with no lvm or subvolumes. It mounts the boot partition too.
#
### Author: 2ELCN0168
# Last updated: 2024-10-02
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

        echo -e "${C_W}> ${INFO} Mounting ${C_G}${root_part}" \
                "${N_F}to /mnt"
        if mount "${root_part}" "/mnt" 1> "/dev/null" 2>&1; then
                echo -e "${C_W}> ${SUC} Mounted ${C_G}${root_part}" \
                        "${N_F}to /mnt/boot\n"
        else
                echo -e "${C_W}> ${ERR} Error while mounting" \
                        "${C_G}${root_part}${N_F} to /mnt/boot\n"
                exit 1
        fi

        echo -e "${C_W}> ${INFO} Mounting ${C_G}${boot_part}" \
                "${N_F}to /mnt/boot"
        if mount --mkdir "${boot_part}" "/mnt/boot" 1> "/dev/null" 2>&1; then
                echo -e "${C_W}> ${SUC} Mounted ${C_G}${boot_part}" \
                        "${N_F}to /mnt/boot\n"
        else
                echo -e "${C_W}> ${ERR} Error while mounting" \
                        "${C_G}${boot_part}${N_F} to /mnt/boot\n"
                exit 1
        fi
}
