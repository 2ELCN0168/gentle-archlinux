#! /bin/bash

source_files() {

    local f_path="./functions"

    source "./config/c_config.sh"
    source "./config/c_formatting.sh"
    source "./config/c_theme.sh"

    source "${f_path}/f_help.sh"
    source "${f_path}/f_greetings.sh"
    source "${f_path}/f_internet.sh"
    source "${f_path}/f_lvm_luks_deletion.sh"
    source "${f_path}/f_bios_mode.sh"
    source "${f_path}/f_cpu_manufacturer.sh"
    source "${f_path}/f_bootloader_choice.sh"
    source "${f_path}/f_luks_choice.sh"
    source "${f_path}/f_lvm_handling.sh"
    source "${f_path}/f_mount_default.sh"
    source "${f_path}/f_filesystem.sh"
    source "${f_path}/f_disk_choice.sh"
    source "${f_path}/f_partition_disks.sh"
    source "${f_path}/f_format_choice.sh"
    source "${f_path}/f_network_manager_choice.sh"
    source "${f_path}/f_kernel_choice.sh"
    source "${f_path}/f_pacstrap.sh"
    source "${f_path}/f_genfstab.sh"
}

main() {
        
        trap 'echo -e "\n\n${C_BLUE}:: ${C_RED}Program interrupted, exiting with code 1.${C_BLUE} ::\n" ; exit 1' INT
        
        # INIT
        greetings

        # TEST INTERNET CONNECTION
        test_internet

        # ASK FOR LVM AND LUKS DESTRUCTION
        lvm_luks_try

        # TEST UEFI/BIOS MODE
        get_bios_mode

        # DETECT CPU MANUFACTURER
        get_cpu_brand

        # ASK FOR BOOTLOADER
        bootloader_choice

        # ASK FOR LUKS
        luks_choice

        # ASK FOR FILESYSTEM
        filesystem_choice

        # ASK FOR BLOCK DEVICE
        disk_choice

        # INIT PARTITIONING
        partition_disk

        # START FORMATING PARTITIONS BTRFS|XFS|EXT4 WITH(OUT) LUKS
        format_partitions

        # ASK NETWORK MANAGER
        net_manager

        # ASK KERNEL
        ask_kernel

        # INSTALL THE SYSTEM
        pacstrap_install

        # GENERATE FSTAB
        gen_fstab

        cp -a "./config/c_config.sh" "post_install/config/c_config.sh"
        cp -a "./config/c_formatting.sh" "post_install/config/c_formatting.sh"
        cp -a "post_install" "/mnt"
        chmod +x "/mnt/post_install/Archlinux_Gentle_Installer_post_install.sh"
        arch-chroot "/mnt" "/post_install/Archlinux_Gentle_Installer_post_install.sh"
}

# SOURCE FILES
source_files

export param_minimal=0
export param_full=0
export param_hardening=0
export param_standard=1

while getopts "hemc" opts; do
                case "${opts}" in
                        h)
                                opt_h_help
                                ;;
                        e)
                                param_hardening=1
                                param_standard=0
                                ;;
                        m)
                                param_minimal=1
                                param_standard=0
                                ;;
                        c)
                                param_full=1
                                param_standard=0
                                ;;
                        \?)
                                opt_h_help
                                ;;
                esac
        done

if [[ "${param_hardening}" -eq 1 ]]; then
        __tty_theme_hard
else
        __tty_theme
fi

main
