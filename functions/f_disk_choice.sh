# FUNCTION(S)
# ---
# This function asks the user which disk they want to use.
# It verifies if the input exists and asks again if it doesn't.
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

disk_choice() {

        export user_disk="" # Former was finalDisk
        export disk=""
        export partitionType=""
        export boot_part="" # Former was finalPartBoot
        export root_part="" # Former was finalPartRoot



        while true; do 

                if [[ "${filesystem}" == 'BTRFS' ]]; then
                        break
                fi

                echo -e "${C_CYAN}:: ${C_WHITE}Do you plan to use LVM? [Y/n] -> ${NO_FORMAT}\c"
                
                local ans_use_lvm=""
                read ans_use_lvm
                : "${ans_use_lvm:=Y}"

                case "${ans_use_lvm}" in
                        [yY])
                                export lvm_disks=()
                                while true; do
                                        local lvm_disk=$(ask_disk)

                                        if [[ -z "${lvm_disk}" ]]; then
                                                break
                                        fi

                                        lvm_disks+=("/dev/${lvm_disk}")
                                done
                                echo -e "${lvm_disks[@]}"
                                break
                                ;;
                        [nN])
                                disk=$(ask_disk "sda")
                                if [[ "${disk}" =~ nvme... ]]; then 
                                        partitionType="p"
                                fi

                                user_disk="/dev/${disk}" # Former was finalDisk
                                boot_part="${user_disk}${partitionType}1" # Former was finalPartBoot
                                root_part="${user_disk}${partitionType}2" # Former was finalPartRoot

                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac

        done
}

ask_disk() {

        while true; do
                echo -e "==${C_CYAN}DISK${NO_FORMAT}==============\n"

                lsblk -d --output NAME | grep -vE 'NAME|sr0|loop0'
                echo -e ""

                echo -e "====================\n"

                echo -e "${C_CYAN}:: ${C_WHITE}Which block device do you want to use? Type it correctly (default=sda) -> ${NO_FORMAT}\c"

                local ans_block_device=""
                read ans_block_device
                : "${ans_block_device:=${1}}"

                if [[ -z "${ans_block_device}" ]]; then
                        return
                fi

                if [[ -b "/dev/${ans_block_device}" ]]; then
                        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}The disk to use is ${C_GREEN}/dev/${ans_block_device}${NO_FORMAT}\n"
                        break
                else
                        invalid_answer
                fi
        done

        echo "${ans_block_device}"
}
