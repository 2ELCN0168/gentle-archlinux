#
### File: f_format_partitions.sh
#
### Description: 
# Format the boot partition to FAT32 and then call other functions,
# depending on the filesystem the user chose. Works with LUKS.
#
### Author: 2ELCN0168
# Last updated: 2024-10-03
#
### Dependencies:
# - none.
#
### Usage:
#
# 1. Format the boot partition to FAT32;
# 2. Call luks_handling() (optional);
# 3. Call btrfs_mgmt() or lvm_mgmt().
#
# NOTE:
# Long parameters for "mkfs.fat" don't exist.
#

source "./functions/f_luks_handling.sh"
source "./functions/f_btrfs.sh"
source "./functions/f_lvm.sh"

format_partitions() {

        printf "${C_W}> ${INFO} ${C_C}Formatting ${boot_part} to FAT32.${N_F}\n"

        # COMMAND:
        # mkfs.fat --fat-size 32 --volume-name "ESP" "${boot_part}"
        if mkfs.fat -F 32 -n ESP "${boot_part}" 1> "/dev/null" 2>&1; then
                printf "${C_W}> ${SUC} ${C_G}Successfully formatted "
                printf "${boot_part} to FAT32.${N_F}\n\n"
        else
                printf "${C_W}> ${ERR} ${C_R}Error during formatting "
                printf "${boot_part} to FAT32.${N_F}\n\n"
                exit 1
        fi

        # INFO:
        # Invoke luks_handling() if the user want to encrypt its disk(s).
        [[ "${wantEncrypted}" -eq 1 ]] && luks_handling

        # INFO:
        # Call btrfs_mgmt() if the user chose BTRFS as filesystem, else, 
        # call lvm_mgmt().
        [[ "${filesystem}" == "BTRFS" ]] && btrfs_mgmt || lvm_mgmt
}
