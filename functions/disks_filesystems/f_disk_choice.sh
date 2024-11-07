#
### File: f_disk_choice.sh
#
### Description: 
# Ask the user which disk(s) they want to use. It can be multiple disks if they
# want to use LVM.
#
### Author: 2ELCN0168
# Last updated: 2024-11-07
#
### Dependencies:
# - none.
#
### Usage:
#
# 1. Check conditions about FS (BTRFS) or LVM;
# 2. Read the user input for selected disks.
#
# NOTE:
# BTRFS should not be compatible with LVM because the subvolume management it is
# capable of is the same thing as LVM.
#

disk_choice() {

        export user_disk=""
        export disks_array=()
        export LVM=""

        if [[ "${filesystem}" != 'BTRFS' ]]; then

                while true; do
                        printf "${C_C}:: ${C_W}Do you plan to use LVM? "
                        printf "[Y/n] -> ${N_F}"
                        
                        local ans_use_lvm=""
                        read ans_use_lvm
                        : "${ans_use_lvm:=Y}"

                        [[ "${ans_use_lvm}" =~ [yYnN] ]] && break
                done

                if [[ "${ans_use_lvm}" =~ [yY] ]]; then
                        LVM=1
                        local chosen_disks=()
                        while true; do
                                display_disks ${chosen_disks[@]}

                                #if [[ -z $(lsblk -d --output NAME | 
                                #grep -vE "${exclude_pattern}") ]]; then
                                #        break
                                #fi

                                local ans_block_dev
                                read ans_block_dev
                                : "${ans_block_dev:=sda}"

                                [[ "${ans_block_dev}" =~ [qQ] ]] && break

                                [[ ! -b "/dev/${ans_block_dev}" ]] && \
                                invalid_answer && continue

                                if [[ "${disks_array[@]}" \
                                =~ "${ans_block_dev}" ]]; then
                                        printf "${C_W}> ${WARN} The chosen "
                                        printf "disk is already in the list!\n"
                                else
                                        disks_array+=("/dev/${ans_block_dev}")
                                        chosen_disks+=("${ans_block_dev}")
                                fi
                        done
                        printf "\n${C_W}> ${INFO} The selected disks "
                        printf "are ${C_G}${chosen_disks[@]}${N_F}\n\n"
                elif [[ "${ans_use_lvm}" =~ [nN] ]]; then
                        LVM=0
                        while true; do
                                display_disks

                                local ans_block_dev
                                read ans_block_dev
                                : "${ans_block_dev:=sda}"

                                [[ -b "/dev/${ans_block_dev}" ]] && break ||
                                invalid_answer && continue
                        done
                        printf "${C_W}> ${INFO} ${N_F} The disk to use "
                        printf "is ${C_G}/dev/${ans_block_dev}"
                        printf "${N_F}\n\n"
                        disks_array+=("/dev/${ans_block_dev}")
                else
                        invalid_answer
                fi

        elif [[ "${filesystem}" == 'BTRFS' ]]; then
                while true; do
                        display_disks

                        local ans_block_dev
                        read ans_block_dev
                        : "${ans_block_dev:=sda}"

                        [[ -b "/dev/${ans_block_dev}" ]] && break ||
                        invalid_answer && continue
                done
                printf "${C_W}> ${INFO} ${N_F}The disk to use is "
                printf "${C_G}/dev/${ans_block_dev}${N_F}\n\n"
                disks_array+=("/dev/${ans_block_dev}")
        fi

        local disk="${ans_block_dev}"
        user_disk="${disks_array[0]}"
}

display_disks() {

        local exclude_pattern="NAME|sr0|loop0"

        for disk in "${@}"; do
                exclude_pattern+="|${disk}"
        done

        print_box "Disks" "${C_C}" 40 

        lsblk --nodeps --output NAME |
        grep --invert-match --extended-regexp "${exclude_pattern}"

        printf "\n────────────────────────────────────────\n\n"

        printf "${C_C}:: ${C_W}Which block device do you want to use? " 
        printf "(default=sda) Type \"[q]\" to quit -> ${N_F}"
}
