#
### File: f_set_hostname.sh
#
### Description: 
# Set the machine hostname (FQDN).
#
### Author: 2ELCN0168
# Last updated: 2024-10-05
# 
### Dependencies:
# - none.
#
### Usage:
#
# 1. Set the hostname and check the validity with a regex;
# 2. Set the domain name and check the validify with a regex.
#

set_hostname() {

        # REGEX:
        # Must start with a-Z or A-Z or 0-9. Hyphens are allowed after the first
        # letter. Must not exceed 63 characters.
        local hostname_regex="^[a-zA-Z0-9][a-zA-Z0-9-]{0,62}$"

        # REGEX:
        # Must start with a-z, A-Z, 0-9. Cannot begin or end with a hyphen or a
        # dot. Must not exceed 255 characters.
        local domain_regex="^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$"

        # INFO: ============================================================
        # Hostname

        printf "${C_C}:: ${C_W}Enter your hostname without domain.\n"
        printf "${C_C}:: ${C_W}Recommended hostname length: 15 chars [a-z][A-Z]"
        printf "[0-9]. Default is 'localhost' -> ${N_F}"

        local ans_hostname=""

        while true; do
                read ans_hostname
                : "${ans_hostname:=localhost}"
                printf "\n"

                if [[ "${ans_hostname}" =~ "${hostname_regex}" ]]; then
                        break
                else
                        printf "${C_W}> ${WARN} ${C_R}Invalid hostname.${N_F} "
                        printf "Hostname must be 1-63 characters long, "
                        printf "containing only letters, digits, and hyphens "
                        printf ", and cannot start or end with a hyphen.\n\n"

                        printf "${C_C}:: ${C_W}Please re-enter a valid "
                        printf "hostname -> ${N_F}"
                fi
        done

        export hostname="${ans_hostname}"

        # INFO: ============================================================
        # Domain name

        printf "${C_C}:: ${C_W}Enter your domain name ([a-z][A-Z][0-9][.-]).\n"
        printf "${C_C}:: ${C_W}It must not begin or end with a dot or a hyphen."
        printf "\nDefault is 'home.arpa' (RFC 8375) -> ${N_F}"

        local ans_domain_name=""
        
        while true; do
                read ans_domain_name
                : "${ans_domain_name:=home.arpa}"
                printf "\n"

                if [[ "${ans_domain_name}" =~ "${hostname_regex}" ]]; then
                        break
                else
                        printf "${C_W}> ${WARN} ${C_R}Invalid domain name. "
                        printf "${N_F}Domain must be in the format "
                        printf "'example.com' or similar, containing letters, "
                        printf "digits, hyphens, and periods, and not starting "
                        printf "or ending with a hyphen or period.\n\n"

                        printf "${C_C}:: ${C_W}Please re-enter a valid "
                        printf "domain name -> ${N_F}"
                fi
        done

        export domain="${ans_domain_name}"

        # INFO: ============================================================
        # Ending
        
        printf "${hostname}.${domain}" > "/etc/hostname"
        printf "\n${C_W}> ${INFO} ${N_F}Your hostname will be ${C_C}"
        printf "${hostname}.${domain}${N_F} (FQDN).\n\n"
}