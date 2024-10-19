#
### File: f_set_hosts.sh
#
### Description: 
# Set the /etc/hosts file and format it.
#
### Author: 2ELCN0168
# Last updated: 2024-10-18
# 
### Dependencies:
# - column.
#
### Usage:
#
# 1. Set the hosts file with ip and hostname (FQDN);
# 2. The file is modified later if the IP address is set to static.
#

set_hosts() {

        local tempfile=$(mktemp)

        printf "${C_W}> ${INFO} ${N_F}Setting up ${C_P}/etc/hosts${N_F}\n"
        printf "> ${C_G}Here is the file:${N_F}\n\n"

        cat <<-EOF 1> "/etc/hosts"
        127.0.0.1 localhost.localdomain localhost localhost-ipv4
        ::1       localhost.localdomain localhost localhost-ipv6
        127.0.0.1 ${hostname}.localdomain ${hostname}.${domain} \
        ${hostname}.${domain}-ipv4
        ::1       ${hostname}.localdomain ${hostname}.${domain} \
        ${hostname}.${domain}-ipv6
EOF

        column -t "/etc/hosts" 1> "${tempfile}"
        [[ -s "${tempfile}" ]] && mv "${tempfile}" "/etc/hosts"

        printf ":::::::::::::::::::::::::::::::::::::::::::::::::::\n\n"

        printf "\033[93m"
        cat "/etc/hosts"
        printf "\033[0m"
        
        printf "\n:::::::::::::::::::::::::::::::::::::::::::::::::::\n\n"
}
