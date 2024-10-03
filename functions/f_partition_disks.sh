# FUNCTION(S)
# ---
# This function initiates the partitioning depending on the BIOS mode.
# ---

partition_disk() {

        # FORMATTING DONE

        if [[ "${UEFI}" -eq 1 ]]; then
                echo -e "${C_W}> ${INFO} Creating two partitions for ${C_C}GPT${N_F} disk."

                # PROBLEM HERE, NEED TO REMOVE THE IF TO GET IT WORKING
                # if parted -s $user_disk mklabel gpt; then
                #         #parted -s $user_disk mkpart ESP fat32 1Mib 512Mib && \
                #         sgdisk -n 1::+512M -t 1:ef00 $user_disk
                #         parted -s $user_disk mkpart Archlinux 600Mib 100%
                #         echo -e "\n"
                #         echo -e "${C_W}> ${SUC} ${C_G}Partitions created successfully for UEFI mode (GPT).${N_F}"
                #         jump
                # else
                #         echo -e "${C_W}> ${ERR} ${C_R}Error during partitionning ${user_disk} for UEFI mode (GPT).${N_F}"
                #         jump
                #         exit 1
                # fi
                
                parted -s "${user_disk}" mklabel gpt 1> "/dev/null" 2>&1
                sgdisk -n 1::+512M -t 1:ef00 "${user_disk}" 1> "/dev/null" 2>&1
                parted -s "${user_disk}" mkpart Archlinux 600Mib 100% 1> "/dev/null" 2>&1
                
                if [[ -b "${user_disk}1" && -b "${user_disk}2" ]]; then
                        echo -e "${C_W}> ${SUC} ${C_G}Partitions created successfully for UEFI mode (GPT).${N_F}\n"
                else
                        echo -e "${C_W}> ${ERR} ${C_R}Error during partitionning ${user_disk} for UEFI mode (GPT).${N_F\n}"
                        exit 1
                fi
                
        elif [[ "${UEFI}" -eq 0 ]]; then

                echo -e "${C_W}> ${INFO} Creating two partitions for MBR disk.${N_F}"
                
                # if parted -s $user_disk mklabel msdos && \
                #         parted -s $user_disk mkpart primary ESP fat32 1Mib 512Mib && \
                #         parted -s $user_disk mkpart primary Archlinux 512Mib 100%; then
                #         echo -e "${C_W}> ${SUC} ${C_G}Partitions created successfully for BIOS mode (MBR).${N_F}"
                #         jump
                # else
                #         echo -e "${C_W}> ${ERR} ${C_R}Error during partitionning ${user_disk} for BIOS mode (MBR).${N_F}"
                #         jump
                #         exit 1
                # fi
                
                if parted -s "${user_disk}" mklabel msdos 1> "/dev/null" 2>&1; then
                        parted -s "${user_disk}" mkpart primary EST fat32 1Mib 512Mib 1> "/dev/null" 2>&1
                        parted -s "${user_disk}" mkpart primary Archlinux 512Mib 100% 1> "/dev/null" 2>&1
                        
                        if [[ -b "${user_disk}1" && -b "${user_disk}2" ]]; then
                                echo -e "${C_W}> ${SUC} ${C_G}Partitions created successfully for UEFI mode (GPT).${N_F}\n"
                        else
                                echo -e "${C_W}> ${ERR} ${C_R}Error during partitionning ${user_disk} for UEFI mode (GPT).${N_F\n}"
                                exit 1
                        fi
                fi


        fi
        sleep 1
}
