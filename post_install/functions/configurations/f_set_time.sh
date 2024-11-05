#
### File: f_set_time.sh
#
### Description: 
# Ask the user their country and then applying local time.
#
### Author: 2ELCN0168
# Last updated: 2024-10-05
# 
### Dependencies:
# - none.
#
### Usage:
#
# 1. Link /usr/share/zoneinfo/xxx/xxx to /etc/localtime.
#
# NOTE:
# Easter egg is set if North Korea is chosen. It changes the last fasfetch logo
# and put an alias in .zshrc/.bashrc to make it permanent.

set_time() {

        printf "${C_W}> ${INFO} Setting system clock to UTC.\n"

        if hwclock --systohc 1> "/dev/null" 2>&1; then
                printf "${C_W}> ${SUC} ${C_G}Successfully set up system clock "
                printf "to UTC.${N_F}\n\n"
        else
                printf "${C_W}> ${WARN} ${C_Y}Failed to setting system clock "
                printf "to UTC.${N_F}\n\n"
        fi

        printf "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} "
        printf "systemd-timesyncd.${N_F}\n"
        
        if systemctl enable systemd-timesyncd 1> "/dev/null" 2>&1; then
                printf "${C_W}> ${SUC} ${C_G}Successfully set up NTP.${N_F}\n\n"
        else
                printf "${C_W}> ${WARN} ${C_Y}Failed to setting up NTP."
                printf "${N_F}\n\n"
        fi

        nKorea=0
        local country=""
        export locales=""

        while true; do

                print_box "Time" "${C_C}" 40 

                printf "${C_W}[0] - ${C_C}France${N_F} [default]\n"
                printf "${C_W}[1] - ${C_W}England${N_F}\n"
                printf "${C_W}[2] - ${C_W}US (New-York)${N_F}\n"
                printf "${C_W}[3] - ${C_R}Japan${N_F}\n"
                printf "${C_W}[4] - ${C_C}South Korea (Seoul)${N_F}\n"
                printf "${C_W}[5] - ${C_R}Russia (Moscow)${N_F}\n"
                printf "${C_W}[6] - ${C_R}China (CST - Shanghai)${N_F}\n"
                printf "${C_W}[7] - ${C_R}North Korea (Pyongyang)${N_F}\n\n"
                
                printf "────────────────────────────────────────\n\n"

                printf "${C_C}:: ${C_W}Where do you live? -> ${N_F}"

                local ans_localtime=""
                read ans_localtime
                : "${ans_localtime:=0}"
                printf "\n"

                case "${ans_localtime}" in
                        [0])
                                country="France"
                                locales="fr"
                                ln -sf "/usr/share/zoneinfo/Europe/Paris" \
                                "/etc/localtime"
                                break
                                ;;
                        [1])
                                country="England"
                                locales="gb"
                                ln -sf "/usr/share/zoneinfo/Europe/London" \
                                "/etc/localtime"
                                break
                                ;;
                        [2])
                                country="the US"
                                ln -sf "/usr/share/zoneinfo/America/New_York" \
                                "/etc/localtime"
                                break
                                ;;
                        [3])
                                country="Japan"
                                locales="ja"
                                ln -sf "/usr/share/zoneinfo/Japan" \
                                "/etc/localtime"
                                break
                                ;;
                        [4])
                                country="South Korea"
                                locales="ko"
                                ln -sf "/usr/share/zoneinfo/Asia/Seoul" \
                                "/etc/localtime"
                                break
                                ;;
                        [5])
                                country="Russia"
                                locales="ru"
                                ln -sf "/usr/share/zoneinfo/Europe/Moscow" \
                                "/etc/localtime"
                                break
                                ;;
                        [6])
                                country="China"
                                locales="zh"
                                ln -sf "/usr/share/zoneinfo/Asia/Shanghai" \
                                "/etc/localtime"
                                break
                                ;;
                        [7])
                                country="North Korea >:) "
                                locales="ko"
                                ln -sf "/usr/share/zoneinfo/Asia/Pyongyang" \
                                "/etc/localtime"
                                nKorea=1
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        printf "${C_W}> ${INFO} You live in ${C_Y}${country}${N_F}.\n\n"
}
