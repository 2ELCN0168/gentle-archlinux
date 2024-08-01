# FUNCTION(S)
# ---
# This function asks the user which disk they want to use.
# It verifies if the input exists and asks again if it doesn't.
# ---

disk_choice() {

        declare -gx user_disk="" # Former was finalDisk
        declare -gx disk=""
        declare -gx partitionType=""
        declare -gx boot_part="" # Former was finalPartBoot
        declare -gx root_part="" # Former was finalPartRoot

        # finalDisk="/dev/${diskToUse}"
        # finalPartBoot="/dev/${diskToUse}${partitionType}1"
        # finalPartRoot="/dev/${diskToUse}${partitionType}2"

        while true; do
                echo -e "==DISK==============\n"

                lsblk -d --output NAME | grep -vE 'NAME|sr0|loop0'
                echo -e "\n"

                echo -e "====================\n"

                echo -e "${B_CYAN} Which block device do you want to use? Type it correctly -> ${NO_FORMAT} \c"

                declare ans_block_device="sda"
                read ans_block_device
                echo ""

                if [[ -b "/dev/${ans_block_device}" ]]; then
                        disk="${ans_block_device}"
                        echo -e "\n"
                        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}The disk to use is ${C_GREEN}/dev/${disk}${NO_FORMAT}"
                        echo -e "\n"

                        if [[ "${disk}" =~ nvme... ]]; then 
                                partitionType="p"
                        fi

                        user_disk="/dev/${disk}" # Former was finalDisk
                        boot_part="${user_disk}${partitionType}1" # Former was finalPartBoot
                        root_part="${user_disk}${partitionType}2" # Former was finalPartRoot

                        break

                else
                        echo -e "\n"
                        invalid_answer
                        continue
                fi
        done
}
