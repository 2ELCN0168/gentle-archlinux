systemd_resolved() {

        local ask_dns=0
        while true; do
                
                printf "${C_C}:: ${C_W}Do you want to configure DNS manually? "
                printf "If not, DNS will be set to ${C_Y}1.1.1.1${N_F} and "
                printf "${C_Y}9.9.9.9${N_F} [y/N] -> ${N_F}"

                local ans_set_dns=""
                read ans_set_dns
                : "${ans_set_dns:=N}"
                printf "\n"

                if [[ "${ans_set_dns}" =~ [yY] ]]; then
                        ask_dns=1
                        break
                elif [[ "${ans_set_dns}" =~ [nN] ]]; then
                        printf "${C_W}> ${INFO} ${N_F}Changing DNS to ${C_Y}"
                        printf "1.1.1.1${N_F} and ${C_Y}9.9.9.9${N_F}.\n"

                        printf "\nDNS=1.1.1.1#cloudflare-dns.com" \
                        1>> "/etc/systemd/resolved.conf"
                        printf "\nFallbackDNS=9.9.9.9#dns.quad9.net" \
                        1>> "/etc/systemd/resolved.conf"

                        printf "${C_W}> ${INFO} ${N_F}Enabling ${C_P}DNSoverTLS"
                        printf "${N_F}.\n\n"

                        printf "\nDNSOverTLS=yes" \
                        1>> "/etc/systemd/resolved.conf"

                        break
                else
                        invalid_answer
                fi
        done

        if [[ "${ask_dns}" -eq 1 ]]; then
                printf "${C_C}:: ${C_W}What will be the primary DNS? "
                printf "(e.g, 1.1.1.1) -> ${N_F}"
                
                local ans_prim_dns=""
                read ans_prim_dns
                
                printf "${C_W}> ${INFO} Primary DNS set to ${C_P}"
                printf "${ans_prim_dns}${N_F}.\n\n"
                
                printf "\nDNS=${ans_prim_dns}" 1>> "/etc/systemd/resolved.conf"

                printf "${C_C}:: ${C_W}What will be the secondary DNS? "
                printf "(e.g, 9.9.9.9) -> ${N_F}"

                local ans_sec_dns=""
                read ans_sec_dns

                printf "${C_W}> ${INFO} Secondary DNS set to ${C_P}"
                printf "${ans_sec_dns}${N_F}.\n\n"

                printf "\nFallbackDNS=${ans_sec_dns}" \
                1>> "/etc/systemd/resolved.conf"

                while true; do
                        printf "${C_C}:: ${C_W}Do you want to enable "
                        printf "DNSoverTLS? [Y/n] -> ${N_F}"

                        local ans_dns_tls=""
                        read ans_dns_tls
                        : "${ans_dns_tls:=Y}"

                        if [[ "${ans_dns_tls}" =~ [yY] ]]; then
                                printf "\nDNSOverTLS=yes" \
                                1>> "/etc/systemd/resolved.conf"
                                printf "${C_W}> ${INFO} DNSoverTLS "
                                printf "${C_G}enabled${N_F}.\n"
                                break
                        elif [[ "${ans_dns_tls}" =~ [nN] ]]; then
                                printf "${C_W}> ${INFO} DNSoverTLS ${C_Y}won't "
                                printf "be enabled${N_F}.\n"
                                break
                        else
                                invalid_answer
                done
        fi

        printf "\n"

        printf "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} "
        printf "systemd-resolved.service.${N_F}\n"

        if systemctl enable systemd-resolved 1> "/dev/null" 2>&1; then
                printf "${C_W}> ${SUC} systemd-resolved ${C_G}enabled${N_F}.\n"
        else
                printf "${C_W}> ${ERR} And error occured and systemd-resolved "
                printf "is ${C_R}not enabled${N_F}.\n"
        fi

        printf "\nDomains=${domain}" 1>> "/etc/systemd/resolved.conf"
        
        printf "\n"
}
