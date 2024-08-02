# FUNCTION(S)
# ---
# lvm_luks_deletion() will try to delete any present LVM even if it's on another disk.
# It will also try to close a LUKS partition before we format it in a next step.
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

lvm_luks_try() {

        declare -i result=0

        if pvscan --cache | grep -q '/dev'; then
                echo -e "${C_WHITE}> ${INFO} ${C_PINK} A LVM is detected.${NO_FORMAT}\n"
                #result=$result+1
                (( result + 1 ))
                echo "result = $result"
        fi

        if lsblk -f | grep -qi 'LUKS'; then
                echo -e "${C_WHITE}> ${INFO} ${C_PINK} LUKS partition is detected.${NO_FORMAT}\n"
                #result=$result+2
                (( result + 2 ))
                echo "result = $result"
        fi

        case "${result}" in
                [0])
                        echo -e "${C_WHITE}> ${INFO} ${C_YELLOW}It seems that there is no ${C_CYAN}LVM ${C_YELLOW}nor${C_CYAN} LUKS${C_YELLOW}, continue...${NO_FORMAT}"
                        ;;
                [1])
                        lvm_deletion
                        ;;
                [2])
                        luks_deletion 
                        ;;
                [3])
                        luks_deletion
                        lvm_deletion
                        ;;
        esac
}

lvm_deletion() {

        while true; do
                echo -e "${B_CYAN} [?] - Do you want to wipe any present LVM? [Y/n] -> ${NO_FORMAT} \c"

                declare ans_wipe_lvm=""
                read ans_wipe_lvm
                : "{$ans_wipe_lvm:=Y}"
                echo ""

                case "${ans_wipe_lvm}" in
                        [yY])
                                lvremove -f -y /dev/mapper/VG_Archlinux-* 1> /dev/null 2>&1
                                vgremove -f -y VG_Archlinux 1> /dev/null 2>&1
                                pvremove -f -y $(pvscan | head -1 | awk '{ print $2 }') 1> /dev/null 2>&1
                                echo -e "${C_WHITE}> ${SUC} ${C_PINK} LVM deleted.${NO_FORMAT}\n"
                                break
                                ;;
                        [nN])
                                echo -e "${C_WHITE}> ${WARN} ${C_PINK} No LVM will be deleted.${NO_FORMAT}\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}

luks_deletion() {

        while true; do
                echo -e "${B_CYAN} [?] - Do you want to close any present LUKS partition? [Y/n] -> ${NO_FORMAT} \c"

                declare ans_close_luks=""
                read ans_close_luks
                : "${ans_close_luks:=Y}"
                echo ""

                case "${ans_close_luks}" in
                        "y"|"Y")
                                cryptsetup close root 1> /dev/null 2>&1
                                echo -e "${C_WHITE}> ${SUC} ${C_PINK} LUKS partition closed.${NO_FORMAT}\n"
                                break
                                ;;
                        "n"|"N")
                                echo -e "${C_WHITE}> ${WARN} ${C_PINK} No LUKS parititon will be closed.${NO_FORMAT}\n"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}
