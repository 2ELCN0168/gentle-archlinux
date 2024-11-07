#
### File: f_lvm_luks_deletion.sh
#
### Description: 
# Delete LUKS partition or LVM if the user wants it because it's needed to
# pursuie the installation.
#
### Author: 2ELCN0168
# Last updated: 2024-10-07
#
### Dependencies:
# - lvm2;
# - cryptsetup. 
#
### Usage:
#
# 1. Check if there are present LVM or LUKS partition;
# 2. Ask the user what they want to do;
# 3. (Optional) Remove LVM and LUKS
#

lvm_luks_try() {

        local result=0

        if pvscan --cache | grep -q '/dev'; then
                printf "${C_W}> ${INFO} ${C_P}A LVM is detected.${N_F}\n\n"
                (( result += 1 ))
        fi

        if lsblk -o NAME,FSTYPE | grep -q '/dev/mapper' &&
        lsblk -o NAME,FSTYPE | grep -qi 'crypto_LUKS'; then
                printf "${C_W}> ${INFO} ${C_P}LUKS partition is detected."
                printf "${N_F}\n\n"
                (( result += 2 ))
        fi

        if [[ "${result}" -eq 0 ]]; then
                printf "${C_W}> ${INFO} ${C_Y}It seems that there is no "
                printf "${C_C}LVM ${C_Y}nor ${C_C}LUKS${C_Y}, continue..."
                printf "${N_F}\n\n"
        fi

        case "${result}" in 
                1) lvm_deletion ;;
                2) luks_deletion ;;
                3) luks_deletion && lvm_deletion ;;
        esac
}

lvm_deletion() {

        while true; do
                printf "${B_C} [?] - Do you want to wipe any present LVM? "
                printf "[y/N] -> ${N_F} "

                local ans_wipe_lvm=""
                read ans_wipe_lvm
                : "${ans_wipe_lvm:=N}"
                printf "\n"

                [[ "${ans_wipe_lvm}" =~ [yYnN] ]] && break || invalid_answer
        done

        # local vg_name=($(vgs --noheadings | awk '{ print $1 }'))
        # if [[ "${ans_wipe_lvm}" =~ [yY] ]]; then
        #         for i in "${vg_name}"; do
        #                 lvremove -f -y "/dev/mapper/${vg_name}-*" \
        #                 1> "/dev/null" 2>&1
        #                 vgremove -f -y "${vg_name}" \
        #                 1> "/dev/null" 2>&1
        #         done
        #         for i in $(pvs | tail -n +2 | awk '{ print $1 }'); do
        #                 pvremove -f -y "${i}" 1> "/dev/null" 2>&1
        #         done
        #         printf "${C_W}> ${SUC} ${C_P}LVM deleted.${N_F}\n\n"
        #         return
        # elif [[ "${ans_wipe_lvm}" =~ [nN] ]]; then 
        #         printf "${C_W}> ${WARN} ${C_P}No LVM will be "
        #         printf "deleted.${N_F}\n\n"
        #         return
        # fi
        #

        if [[ "${ans_wipe_lvm}" =~ [nN] ]]; then
                printf "${C_W}> ${WARN} ${C_P}No LVM will be "
                printf "deleted.${N_F}\n\n"
                return
        fi

        local err_counter=0

        for i in "$(vgs --noheadings | awk '{ print $1 }')"; do
                if ! lvremove -f -y "/dev/${i}"* 1> "/dev/null" 2>&1; then
                        ((err_counter++))
                fi
                if ! vgremove -f -y "${i}" 1> "/dev/null" 2>&1; then
                        ((err_counter++))
                fi
        done

        for i in $(pvs --noheadings | awk '{ print $1 }'); do
                if ! pvremove -f -y "${i}" 1> "/dev/null" 2>&1; then
                        ((err_counter++))
                fi
        done

        if [[ "${err_counter}" -eq 0 ]]; then
                printf "${C_W}> ${SUC} ${C_P}LVM deleted.${N_F}\n\n"
        else
                printf "${C_W}> ${ERR} ${C_R}LVM couldn't be "
                printf "deleted.${N_F}\n\n"
        fi
}

luks_deletion() {

        while true; do
                printf "${B_C} [?] - Do you want to close any present LUKS "
                printf "partition? [Y/n] -> ${N_F}"

                local ans_close_luks=""
                read ans_close_luks
                : "${ans_close_luks:=Y}"
                printf "\n"

                [[ "${ans_close_luks}" =~ [yYnN] ]] && break || invalid_answer
        done

        if [[ "${ans_close_luks}" =~ [yY] ]]; then
                if cryptsetup close root 1> "/dev/null" 2>&1; then
                        printf "${C_W}> ${SUC} ${C_P}LUKS partition "
                        printf "closed.${N_F}\n\n"
                else
                        printf "${C_W}> ${ERR} ${C_P}LUKS partition "
                        printf "could not be closed.${N_F}\n\n"
                        exit 1
                fi
        elif [[ "${ans_close_luks}" =~ [nN] ]]; then 
                printf "${C_W}> ${WARN} ${C_P}No LUKS partition will "
                printf "be closed.${N_F}\n\n"
        fi
}
