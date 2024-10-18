#
### File: f_set_mkinitcpio.sh
#
### Description: 
# Modify the mkinitcpio configuration.
#
### Author: 2ELCN0168
# Last updated: 2024-10-06
# 
### Dependencies:
# - mkinitcpio (default).
#
### Usage:
#
# 1. Uncomment Color;
# 2. Uncomment ParallelDownloads;
# 3. Update tealdeer (If installed).
#

set_mkinitcpio() {

        # INFO:
        # Making a clean backup of /mnt/etc/mkinitcpio.conf
        printf "${C_W}> ${INFO} ${N_F}Making a backup of "
        printf  "${C_P}/etc/mkinitcpio.conf${N_F}...\n"

        if [[ ! -e "/etc/mkinitcpio.conf.d" ]]; then
                mkdir "/etc/mkinitcpio.conf.d"
        fi

        cp -a "/etc/mkinitcpio.conf" \
        "/etc/mkinitcpio.conf.d/$(date +%Y%m%d)-mkinitcpio.conf.bak"      

        # INFO:
        # Setting up /etc/mkinitcpio.conf
        local isBTRFS=""
        local isLUKS=""
        local isLVM=""

        [[ "${filesystem}" == "BTRFS" ]] && isBTRFS="btrfs "

        [[ "${wantEncrypted}" -eq 1 ]] && isLUKS="sd-encrypt "

        [[ "${LVM}" -eq 1 ]] && isLVM="lvm2 "

        printf "${C_W}> ${INFO} ${N_F}Updating ${C_P}/etc/mkinitcpio.conf "
        printf "${N_F}with custom parameters...\n\n"

        local initcpio_hooks="HOOKS=(base systemd ${isBTRFS}autodetect modconf \
        kms keyboard sd-vconsole ${isLUKS}block ${isLVM}filesystems fsck)"

        local tempfile=$(mktemp)
        awk -v newLine="$initcpio_hooks" '
        !/^#/ && /HOOKS/ { 
                print newLine; 
                next 
        } 
        1
        ' "/etc/mkinitcpio.conf" 1> "${tempfile}" && mv "${tempfile}" "/etc/mkinitcpio.conf"

        # Generate initramfs
        if ! mkinitcpio -P; then
                printf "${C_R}> ${ERROR} Failed to generate initramfs with "
                printf "mkinitcpio. Exiting.\n\n"
                exit 1
        fi
}
