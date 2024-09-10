systemd_resolved() {

        local ask_dns=0
        while true; do
                
                echo -e "${C_CYAN}:: ${C_WHITE}Do you want to configure DNS manually? If not, DNS will be set to ${C_YELLOW}1.1.1.1${NO_FORMAT} and ${C_YELLOW}9.9.9.9${NO_FORMAT} [y/N] -> ${NO_FORMAT}\c"
                local ans_set_dns=""
                read ans_set_dns
                : "${ans_set_dns:=N}"

                case "${ans_set_dns}" in
                        [yY])
                                ask_dns=1
                                break
                                ;;
                        [nN])
                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Changing DNS to ${C_YELLOW}1.1.1.1${NO_FORMAT} and ${C_YELLOW}9.9.9.9${NO_FORMAT}."
                                echo "DNS=1.1.1.1#cloudflare-dns.com" >> "/etc/systemd/resolved.conf"
                                echo "FallbackDNS=9.9.9.9#dns.quad9.net" >> "/etc/systemd/resolved.conf"

                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Enabling ${C_PINK}DNSoverTLS${NO_FORMAT}.\n"
                                echo "DNSOverTLS=yes" >> "/etc/systemd/resolved.conf"

                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        if [[ "${ask_dns}" -eq 1 ]]; then
                echo -e "${C_CYAN}:: ${C_WHITE}What will be the primary DNS? (e.g, 1.1.1.1) -> ${NO_FORMAT}\c"
                
                local ans_prim_dns=""
                read ans_prim_dns
                
                echo -e "${C_WHITE}> ${INFO} Primary DNS set to ${C_PINK}${ans_prim_dns}${NO_FORMAT}."
                echo
                echo "DNS=${ans_prim_dns}" >> "/etc/systemd/resolved.conf"

                echo -e "${C_CYAN}:: ${C_WHITE}What will be the secondary DNS? (e.g, 9.9.9.9) -> ${NO_FORMAT}\c"
                local ans_sec_dns=""
                read ans_sec_dns

                echo -e "${C_WHITE}> ${INFO} Secondary DNS set to ${C_PINK}${ans_sec_dns}${NO_FORMAT}."
                echo
                echo "FallbackDNS=${ans_sec_dns}" >> "/etc/systemd/resolved.conf"

                while true; do
                        echo -e "${C_CYAN}:: ${C_WHITE}Do you want to enable DNSoverTLS? [Y/n] -> ${NO_FORMAT}\c"
                        local ans_dns_tls=""
                        read ans_dns_tls
                        : "${ans_dns_tls:=Y}"

                        case "${ans_dns_tls}" in
                                [yY])
                                        echo "DNSOverTLS=yes" >> "/etc/systemd/resolved.conf"
                                        echo -e "${C_WHITE}> ${INFO} DNSoverTLS ${C_GREEN}enabled${NO_FORMAT}."
                                        echo
                                        break
                                        ;;
                                [nN])
                                        break
                                        ;;
                                *)
                                        invalid_answer
                                        ;;
                        esac
                done

        fi

        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} systemd-resolved.service.${NO_FORMAT}"
        systemctl enable systemd-resolved 1> "/dev/null" 2>&1
        if [[ "${?}" -eq 0 ]]; then
                echo -e "${C_WHITE}> ${SUC} systemd-resolved ${C_GREEN}enabled${NO_FORMAT}."
        else
                echo -e "${C_WHITE}> ${ERR} And error occured and systemd-resolved is ${C_RED}not enabled${NO_FORMAT}."
        fi

        echo "Domains=${domain}" >> "/etc/systemd/resolved.conf"
        echo
        }
