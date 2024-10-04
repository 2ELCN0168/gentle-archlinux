#
### File: f_partition_disks.sh
#
### Description: 
# This function initiates the partitioning depending on the BIOS mode.
#
### Author: 2ELCN0168
# Last updated: 2024-10-04
#
### Dependencies:
# - parted (included); 
# - sgdisk (gdisk) (included). 
#
### Usage:
#
# 1. Create GPT table + partitions;
# 2. or create MBR table + partitions.
#

partition_disk() {

        if [[ "${UEFI}" -eq 1 ]]; then
                printf "${C_W}> ${INFO} Creating two partitions for "
                printf "${C_C}GPT${N_F} disk.\n"

                parted -s "${user_disk}" mklabel gpt 1> "/dev/null" 2>&1
                sgdisk -n 1::+512M -t 1:ef00 "${user_disk}" 1> "/dev/null" 2>&1
                parted -s "${user_disk}" mkpart Archlinux 600Mib 100% \
                1> "/dev/null" 2>&1
                
                if [[ -b "${user_disk}1" && -b "${user_disk}2" ]]; then
                        printf "${C_W}> ${SUC} ${C_G}Partitions created "
                        printf "successfully for UEFI mode (GPT).${N_F}\n\n"
                else
                        printf "${C_W}> ${ERR} ${C_R}Error during "
                        printf "partitionning ${user_disk} for UEFI mode "
                        printf "(GPT).${N_F}\n\n"
                        exit 1
                fi
                
        elif [[ "${UEFI}" -eq 0 ]]; then

                printf "${C_W}> ${INFO} Creating two partitions for "
                printf "MBR disk.${N_F}\n"
                
                parted -s "${user_disk}" mklabel msdos 1> "/dev/null" 2>&1
                parted -s "${user_disk}" mkpart primary fat32 1Mib 512Mib \
                1> "/dev/null" 2>&1
                parted -s "${user_disk}" mkpart primary 512Mib 100% \
                1> "/dev/null" 2>&1
                        
                if [[ -b "${user_disk}1" && -b "${user_disk}2" ]]; then
                        printf "${C_W}> ${SUC} ${C_G}Partitions created "
                        printf "successfully for BIOS mode (MBR).${N_F}\n\n"
                else
                        printf "${C_W}> ${ERR} ${C_R}Error during "
                        printf "partitionning ${user_disk} for BIOS mode "
                        printf "(MBR).${N_F}\n\n"
                        exit 1
                fi
        fi
        sleep 1
}
