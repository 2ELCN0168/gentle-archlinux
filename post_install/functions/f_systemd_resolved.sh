systemd_resolved() {

        local ask_dns=0
        while true; do
                
                echo -e "${C_C}:: ${C_W}Do you want to configure DNS manually? If not, DNS will be set to ${C_Y}1.1.1.1${N_F} and ${C_Y}9.9.9.9${N_F} [y/N] -> ${N_F}\c"
                local ans_set_dns=""
                read ans_set_dns
                : "${ans_set_dns:=N}"

                case "${ans_set_dns}" in
                        [yY])
                                ask_dns=1
                                break
                                ;;
                        [nN])
                                echo -e "${C_W}> ${INFO} ${N_F}Changing DNS to ${C_Y}1.1.1.1${N_F} and ${C_Y}9.9.9.9${N_F}."
                                echo "DNS=1.1.1.1#cloudflare-dns.com" >> "/etc/systemd/resolved.conf"
                                echo "FallbackDNS=9.9.9.9#dns.quad9.net" >> "/etc/systemd/resolved.conf"

                                echo -e "${C_W}> ${INFO} ${N_F}Enabling ${C_P}DNSoverTLS${N_F}.\n"
                                echo "DNSOverTLS=yes" >> "/etc/systemd/resolved.conf"

                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        if [[ "${ask_dns}" -eq 1 ]]; then
                echo -e "${C_C}:: ${C_W}What will be the primary DNS? (e.g, 1.1.1.1) -> ${N_F}\c"
                
                local ans_prim_dns=""
                read ans_prim_dns
                
                echo -e "${C_W}> ${INFO} Primary DNS set to ${C_P}${ans_prim_dns}${N_F}."
                echo
                echo "DNS=${ans_prim_dns}" >> "/etc/systemd/resolved.conf"

                echo -e "${C_C}:: ${C_W}What will be the secondary DNS? (e.g, 9.9.9.9) -> ${N_F}\c"
                local ans_sec_dns=""
                read ans_sec_dns

                echo -e "${C_W}> ${INFO} Secondary DNS set to ${C_P}${ans_sec_dns}${N_F}."
                echo
                echo "FallbackDNS=${ans_sec_dns}" >> "/etc/systemd/resolved.conf"

                while true; do
                        echo -e "${C_C}:: ${C_W}Do you want to enable DNSoverTLS? [Y/n] -> ${N_F}\c"
                        local ans_dns_tls=""
                        read ans_dns_tls
                        : "${ans_dns_tls:=Y}"

                        case "${ans_dns_tls}" in
                                [yY])
                                        echo "DNSOverTLS=yes" >> "/etc/systemd/resolved.conf"
                                        echo -e "${C_W}> ${INFO} DNSoverTLS ${C_G}enabled${N_F}."
                                        break
                                        ;;
                                [nN])
                                        echo -e "${C_W}> ${INFO} DNSoverTLS ${C_Y}won't be enabled${N_F}."
                                        break
                                        ;;
                                *)
                                        invalid_answer
                                        ;;
                        esac
                done
        fi

        echo
        echo -e "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} systemd-resolved.service.${N_F}"
        systemctl enable systemd-resolved 1> "/dev/null" 2>&1
        if [[ "${?}" -eq 0 ]]; then
                echo -e "${C_W}> ${SUC} systemd-resolved ${C_G}enabled${N_F}."
        else
                echo -e "${C_W}> ${ERR} And error occured and systemd-resolved is ${C_R}not enabled${N_F}."
        fi

        echo "Domains=${domain}" >> "/etc/systemd/resolved.conf"
        echo
        }
