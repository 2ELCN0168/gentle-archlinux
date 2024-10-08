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

        # finalDisk="/dev/${diskToUse}"
        # finalPartBoot="/dev/${diskToUse}${partitionType}1"
        # finalPartRoot="/dev/${diskToUse}${partitionType}2"

        while true; do
                echo -e "==${C_CYAN}DISK${NO_FORMAT}==============\n"

                lsblk -d --output NAME | grep -vE 'NAME|sr0|loop0'
                echo -e ""

                echo -e "====================\n"

                echo -e "${C_CYAN}:: ${C_WHITE}Which block device do you want to use? Type it correctly (default=sda) -> ${NO_FORMAT}\c"

                local ans_block_device=""
                read ans_block_device
                : "${ans_block_device:=sda}"
                # echo ""

                if [[ -b "/dev/${ans_block_device}" ]]; then
                        disk="${ans_block_device}"
                        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}The disk to use is ${C_GREEN}/dev/${disk}${NO_FORMAT}\n"

                        if [[ "${disk}" =~ nvme... ]]; then 
                                partitionType="p"
                        fi

                        user_disk="/dev/${disk}" # Former was finalDisk
                        boot_part="${user_disk}${partitionType}1" # Former was finalPartBoot
                        root_part="${user_disk}${partitionType}2" # Former was finalPartRoot

                        break
                else
                        invalid_answer
                fi
        done
}
