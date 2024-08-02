# FUNCTION(S)
# ---
# This function initiates the partitioning depending on the BIOS mode.
# ---

partition_disk() {

        # FORMATTING DONE

        if [[ "${UEFI}" -eq 1 ]]; then
                echo -e "\n${C_WHITE}> ${INFO} Creating two partitions for ${C_CYAN}GPT${NO_FORMAT} disk.\n"

                # PROBLEM HERE, NEED TO REMOVE THE IF TO GET IT WORKING
                # if parted -s $user_disk mklabel gpt; then
                #         #parted -s $user_disk mkpart ESP fat32 1Mib 512Mib && \
                #         sgdisk -n 1::+512M -t 1:ef00 $user_disk
                #         parted -s $user_disk mkpart Archlinux 600Mib 100%
                #         echo -e "\n"
                #         echo -e "${C_WHITE}> ${SUC} ${C_GREEN}Partitions created successfully for UEFI mode (GPT).${NO_FORMAT}"
                #         jump
                # else
                #         echo -e "${C_WHITE}> ${ERR} ${C_RED}Error during partitionning ${user_disk} for UEFI mode (GPT).${NO_FORMAT}"
                #         jump
                #         exit 1
                # fi
                
                if parted -s "${user_disk}" mklabel gpt 1> /dev/null 2>&1; then
                        sgdisk -n 1::+512M -t 1:ef00 "${user_disk}" 1> /dev/null 2>&1
                        parted -s "${user_disk}" mkpart Archlinux 600Mib 100% 1> /dev/null 2>&1
                        
                        if [[ -b "${user_disk}1" && -b "${user_disk}2" ]]; then
                                echo -e "${C_WHITE}> ${SUC} ${C_GREEN}Partitions created successfully for UEFI mode (GPT).${NO_FORMAT}\n"
                        else
                                echo -e "${C_WHITE}> ${ERR} ${C_RED}Error during partitionning ${user_disk} for UEFI mode (GPT).${NO_FORMAT\n}"
                                exit 1
                        fi
                fi
                
        elif [[ "${UEFI}" -eq 0 ]]; then

                echo -e "${C_WHITE}> ${INFO} Creating two partitions for MBR disk.${NO_FORMAT}\n"
                
                # if parted -s $user_disk mklabel msdos && \
                #         parted -s $user_disk mkpart primary ESP fat32 1Mib 512Mib && \
                #         parted -s $user_disk mkpart primary Archlinux 512Mib 100%; then
                #         echo -e "${C_WHITE}> ${SUC} ${C_GREEN}Partitions created successfully for BIOS mode (MBR).${NO_FORMAT}"
                #         jump
                # else
                #         echo -e "${C_WHITE}> ${ERR} ${C_RED}Error during partitionning ${user_disk} for BIOS mode (MBR).${NO_FORMAT}"
                #         jump
                #         exit 1
                # fi
                
                if parted -s "${user_disk}" mklabel msdos 1> /dev/null 2>&1; then
                        parted -s "${user_disk}" mkpart primary EST fat32 1Mib 512Mib 1> /dev/null 2>&1
                        parted -s "${user_disk}" mkpart primary Archlinux 512Mib 100% 1> /dev/null 2>&1
                        
                        if [[ -b "${user_disk}1" && -b "${user_disk}2" ]]; then
                                echo -e "${C_WHITE}> ${SUC} ${C_GREEN}Partitions created successfully for UEFI mode (GPT).${NO_FORMAT}\n"
                        else
                                echo -e "${C_WHITE}> ${ERR} ${C_RED}Error during partitionning ${user_disk} for UEFI mode (GPT).${NO_FORMAT\n}"
                                exit 1
                        fi
                fi


        fi
        sleep 1
}
