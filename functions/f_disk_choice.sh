# FUNCTION(S)
# ---
# This function asks the user which disk they want to use.
# It verifies if the input exists and asks again if it doesn't.
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

disk_choice() {

        export user_disk="" # Former was finalDisk
        # export disk=""
        export disks_array=()
        export partitionType=""
        export boot_part="" # Former was finalPartBoot
        export root_part="" # Former was finalPartRoot



        if [[ "${filesystem}" != 'BTRFS' ]]; then

                echo -e "${C_CYAN}:: ${C_WHITE}Do you plan to use LVM? [Y/n] -> ${NO_FORMAT}\c"
                
                local ans_use_lvm=""
                read ans_use_lvm
                : "${ans_use_lvm:=Y}"

                case "${ans_use_lvm}" in
                        [yY])
                                local chosen_disks=()
                                while true; do
                                        display_disks ${chosen_disks[@]}

                                        local ans_block_device
                                        read ans_block_device

                                        if [[ -z "${ans_block_device}" ]]; then
                                                break
                                        else
                                                if [[ -b "/dev/${ans_block_device}" ]]; then
                                                        if [[ "${lvm_disks[@]}" =~ "${ans_block_device}" ]]; then
                                                                echo -e "${C_WHITE}> ${WARN} The chosen disk is already in the list!"
                                                        else
                                                                disks_array+=("/dev/${ans_block_device}")
                                                                chosen_disks+=(${ans_block_device})
                                                        fi
                                                else
                                                        invalid_answer
                                                fi
                                        fi
                                done
                                echo -e "\n${C_WHITE}> ${INFO} The selected disks are ${C_GREEN}${chosen_disks[@]}${NO_FORMAT}\n"
                                ;;
                        [nN])
                                while true; do
                                        display_disks

                                        local ans_block_device
                                        read ans_block_device
                                        : "${ans_block_device:=sda}"

                                        if [[ -b "/dev/${ans_block_device}" ]]; then
                                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}The disk to use is ${C_GREEN}/dev/${ans_block_device}${NO_FORMAT}\n"
                                                disks_array+=("/dev/${ans_block_device}")
                                                break
                                        else
                                                invalid_answer
                                        fi
                                done

                                disk="${ans_block_device}"

                                if [[ "${disk}" =~ nvme... ]]; then 
                                        partitionType="p"
                                fi

                                user_disk="${disks_array[0]}" # Former was finalDisk
                                boot_part="${user_disk}${partitionType}1" # Former was finalPartBoot
                                root_part="${user_disk}${partitionType}2" # Former was finalPartRoot

                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        fi

}

display_disks() {

        local exclude_pattern="NAME|sr0|loop0"
        for disk in "${@}"; do
                exclude_pattern+="|${disk}"
        done

        echo -e "\n==${C_CYAN}DISK${NO_FORMAT}==============\n"

        lsblk -d --output NAME | grep -vE "${exclude_pattern}"
        echo -e ""

        echo -e "====================\n"

        echo -e "${C_CYAN}:: ${C_WHITE}Which block device do you want to use? Type it correctly (default=sda) -> ${NO_FORMAT}\c"
}
