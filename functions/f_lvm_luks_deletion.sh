#
### File: f_lvm_luks_deletion.sh
#
### Description: 
# Delete LUKS partition or LVM if the user wants it because it's needed to
# pursuie the installation.
#
### Author: 2ELCN0168
# Last updated: 2024-10-02
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
                echo -e "${C_WHITE}> ${INFO} ${C_PINK}A LVM is" \
                        "detected.${NO_FORMAT}\n"
                #result=$result+1
                (( result += 1 ))
        fi

        if lsblk -f | grep -qi 'LUKS'; then
                echo -e "${C_WHITE}> ${INFO} ${C_PINK}LUKS partition is" \
                        "detected.${NO_FORMAT}\n"

                # COMMAND:
                # result=$result+2
                (( result += 2 ))
        fi

        [[ "${result}" -eq 0 ]] && echo -e "${C_WHITE}> ${INFO} ${C_YELLOW}It" \
                "seems that there is no ${C_CYAN}LVM ${C_YELLOW}nor" \
                "${C_CYAN}LUKS${C_YELLOW}, continue...${NO_FORMAT}\n"
        [[ "${result}" -eq 1 ]] && lvm_deletion
        [[ "${result}" -eq 2 ]] && luks_deletion
        [[ "${result}" -eq 3 ]] && luks_deletion && lvm_deletion
}

lvm_deletion() {

        while true; do
                echo -e "${B_CYAN} [?] - Do you want to wipe any present" \
                        "LVM? [y/N] -> ${NO_FORMAT} \c"

                local ans_wipe_lvm=""
                read ans_wipe_lvm
                : "${ans_wipe_lvm:=N}"
                echo ""

                local vg_name=($(vgs --noheadings | awk '{ print $1 }'))
                if [[ "${ans_wipe_lvm}" =~ [yY] ]]; then
                        for i in "${vg_name}"; do
                                lvremove -f -y "/dev/mapper/${vg_name}-*" \
                                1> "/dev/null" 2>&1
                                vgremove -f -y "${vg_name}" \
                                1> "/dev/null" 2>&1
                        done
                        for i in $(pvs | tail -n +2 | awk '{ print $1 }'); do
                                pvremove -f -y "${i}" 1> "/dev/null" 2>&1
                        done
                        echo -e "${C_WHITE}> ${SUC} ${C_PINK}LVM" \
                                "deleted.${NO_FORMAT}\n"
                        return
                elif [[ "${ans_wipe_lvm}" =~ [nN] ]]; then 
                        echo -e "${C_WHITE}> ${WARN} ${C_PINK}No LVM will" \
                                "be deleted.${NO_FORMAT}\n"
                        return
                else
                        invalid_answer
                fi

        done
}

luks_deletion() {

        while true; do
                echo -e "${B_CYAN} [?] - Do you want to close any present" \
                        "LUKS partition? [Y/n] -> ${NO_FORMAT}\c"

                local ans_close_luks=""
                read ans_close_luks
                : "${ans_close_luks:=Y}"
                echo ""

                if [[ "${ans_close_luks}" =~ [yY] ]]; then
                        cryptsetup close root 1> "/dev/null" 2>&1
                        echo -e "${C_WHITE}> ${SUC} ${C_PINK}LUKS" \
                                "partition closed.${NO_FORMAT}\n"
                        return
                elif [[ "${ans_close_luks}" =~ [nN] ]]; then 
                        echo -e "${C_WHITE}> ${WARN} ${C_PINK}No LUKS" \
                                "parititon will be closed.${NO_FORMAT}\n"
                        return
                else
                        invalid_answer
                fi
        done
}
