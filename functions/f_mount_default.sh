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

        echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}${root_part}" \
                "${NO_FORMAT}to /mnt"
        if mount "${root_part}" "/mnt" 1> "/dev/null" 2>&1; then
                echo -e "${C_WHITE}> ${SUC} Mounted ${C_GREEN}${root_part}" \
                        "${NO_FORMAT}to /mnt/boot\n"
        else
                echo -e "${C_WHITE}> ${ERR} Error while mounting" \
                        "${C_GREEN}${root_part}${NO_FORMAT} to /mnt/boot\n"
                exit 1
        fi

        echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}${boot_part}" \
                "${NO_FORMAT}to /mnt/boot"
        if mount --mkdir "${boot_part}" "/mnt/boot" 1> "/dev/null" 2>&1; then
                echo -e "${C_WHITE}> ${SUC} Mounted ${C_GREEN}${boot_part}" \
                        "${NO_FORMAT}to /mnt/boot\n"
        else
                echo -e "${C_WHITE}> ${ERR} Error while mounting" \
                        "${C_GREEN}${boot_part}${NO_FORMAT} to /mnt/boot\n"
                exit 1
        fi
}
