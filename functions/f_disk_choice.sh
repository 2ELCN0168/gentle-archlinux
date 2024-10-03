#
### File: f_disk_choice.sh
#
### Description: 
# Ask the user which disk(s) they want to use. It can be multiple disks if they
# want to use LVM.
#
### Author: 2ELCN0168
# Last updated: 2024-10-03
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
# OPTIMIZE:
# Even if this works well, I feel like the logic is not good. There are a lot of
# imbricated blocks (if) and it's not well written in my opinion.
#

disk_choice() {

        export user_disk=""
        export disks_array=()
        export partitionType=""
        export boot_part=""
        export root_part=""
        export LVM=""



        if [[ "${filesystem}" != 'BTRFS' ]]; then

                echo -e "${C_C}:: ${C_W}Do you plan to use LVM? [Y/n] -> ${N_F}\c"
                
                local ans_use_lvm=""
                read ans_use_lvm
                : "${ans_use_lvm:=Y}"

                case "${ans_use_lvm}" in
                        [yY])
                                LVM=1
                                local chosen_disks=()
                                while true; do
                                        display_disks ${chosen_disks[@]}

                                        #if [[ -z $(lsblk -d --output NAME | grep -vE "${exclude_pattern}") ]]; then
                                        #        break
                                        #fi
                                        
                                        local ans_block_device
                                        read ans_block_device
                                        : "${ans_block_device:=sda}"

                                        if [[ "${ans_block_device}" =~ [qQ] ]]; then
                                                break
                                        else
                                                if [[ -b "/dev/${ans_block_device}" ]]; then
                                                        if [[ "${disks_array[@]}" =~ "${ans_block_device}" ]]; then
                                                                echo -e "${C_W}> ${WARN} The chosen disk is already in the list!"
                                                        else
                                                                disks_array+=("/dev/${ans_block_device}")
                                                                chosen_disks+=("${ans_block_device}")
                                                        fi
                                                else
                                                        invalid_answer
                                                fi
                                        fi
                                done
                                echo -e "\n${C_W}> ${INFO} The selected disks" \
                                        "are ${C_G}${chosen_disks[@]}${N_F}\n"
                                ;;
                        [nN])

                                LVM=0
                                while true; do
                                        display_disks

                                        local ans_block_device
                                        read ans_block_device
                                        : "${ans_block_device:=sda}"

                                        if [[ -b "/dev/${ans_block_device}" ]]; then
                                                echo -e "${C_W}> ${INFO} ${N_F}" \
                                                        "The disk to use is ${C_G}/dev/" \
                                                        "${ans_block_device}${N_F}\n"
                                                disks_array+=("/dev/${ans_block_device}")
                                                break
                                        else
                                                invalid_answer
                                        fi
                                done
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac

        elif [[ "${filesystem}" == 'BTRFS' ]]; then

                while true; do
                        display_disks

                        local ans_block_device
                        read ans_block_device
                        : "${ans_block_device:=sda}"

                        if [[ -b "/dev/${ans_block_device}" ]]; then
                                echo -e "${C_W}> ${INFO} ${N_F}The disk"\
                                        "to use is ${C_G}/dev/${ans_block_device}" \
                                        "${N_F}\n"
                                disks_array+=("/dev/${ans_block_device}")
                                break
                        else
                                invalid_answer
                        fi
                done
        fi

        local disk="${ans_block_device}"

        [[ "${disk}" =~ nvme... ]] && partitionType="p"

        user_disk="${disks_array[0]}"
        boot_part="${user_disk}${partitionType}1"
        root_part="${user_disk}${partitionType}2"
}

display_disks() {

        local exclude_pattern="NAME|sr0|loop0"
        for disk in "${@}"; do
                exclude_pattern+="|${disk}"
        done

        echo -e "\n==${C_C}DISK${N_F}==============\n"

        lsblk --nodeps --output NAME | grep --invert-match --extended-regexp "${exclude_pattern}"
        echo -e ""

        echo -e "====================\n"

        echo -e "${C_C}:: ${C_W}Which block device do you want to use?" \
                "(default=sda) Type \"q\" to quit -> ${N_F}\c"
}
