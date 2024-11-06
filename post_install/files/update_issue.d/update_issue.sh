#! /bin/bash

# This script is executed by a systemd service to update dynamically the 
# /etc/issue file.

R="\033[91m" # RED
G="\033[92m" # GREEN
Y="\033[93m" # YELLOW
B="\033[94m" # BLUE
P="\033[95m" # PINK
C="\033[96m" # CYAN
N="\033[0m"  # RESET

HOSTNAME=$(hostnamectl hostname)
KERNEL=$(printf "%s %s" "$(command uname -s)" "$(command uname -r)")
CPU=$(awk -F': ' '/model name/ {print $2; exit}' /proc/cpuinfo)
UPTIME=$(command uptime -p | cut -d " " -f 2-)
PACKAGES=$(pacman -Q | command wc -l)
MACHINETYPE="Workstation"
USERS=$(command who | command wc -l)
ACCESS="Not allowed !"

generate_line() {

        local label="${1}"
        local value="${2}"
        local color_1="${3}"
        local color_2="${4}"
        local target_length=60  # Total length of line

        local label_length=${#label}
        local value_length=${#value}
        local dots_length=$((target_length - label_length - value_length))

        local dots=$(printf '.%.0s' $(seq 1 "${dots_length}"))

        echo -e "${color_1}${label}${N} ${dots} ${color_2}${value}${N}"
}

display_ip_addresses() {

        interfaces=$(command ip -o link show | awk -F': ' '{ print $2 }' | 
        grep -v 'lo')

        for interface in ${interfaces}; do
                # IPv4 addresses
                ipv4_addresses=$(command ip -4 addr show "${interface}" |
                awk '/inet / { print $2 }' | cut -d/ -f1)

                for i in ${ipv4_addresses}; do
                        if [[ "${i}" != "127.0.0.1" ]]; then
                                generate_line "IPv4 (${interface})" "${i}" \
                                "${Y}" "${P}"
                        fi
                done

                # IPv6 addresses
                ipv6_addresses=$(ip -6 addr show "${interface}" |
                awk '/inet6 / { print $2 }' | cut -d/ -f1)

                for i in ${ipv6_addresses}; do
                        if [[ "${i}" != "::1" ]]; then
                                generate_line "IPv6 (${interface})" "${i}" \
                                "${Y}" "${P}"
                        fi
                done
        done
}

print_box() {

        # USAGE:
        # print_box "Some text" [<"${C_C}"> [<40>]]

        local text="${1}"
        local color="${2:-\033[0m}"
        local reset="\033[0m"

        # NOTE:
        # 30 the default total length of the box if nothing is provided 
        # as argument 3
        local total_width="${3:-63}"
        local text_length=${#text}

        local inner_width=$((total_width - 2))
        local padding=$(( (inner_width - text_length) / 2 ))

        local spaces_L=$(printf '%*s' "$padding" '')
        local spaces_R=$(
        printf '%*s' "$((inner_width - text_length - padding))" ''
        )

        local colored_text="${color}${spaces_L}${text}${spaces_R}${reset}"

        local border_top="┌$(printf '─%.0s' $(seq 1 ${inner_width}))┐"
        local border_bottom="└$(printf '─%.0s' $(seq 1 ${inner_width}))┘"

        printf "\n%s\n" "${border_top}"
        printf "│%b│\n" "${colored_text}"
        printf "%s\n\n" "${border_bottom}"
}

welcome_text="Welcome to Archlinux /\\ "
print_box "${welcome_text}" "${C}" > "/etc/issue"

generate_line "Hostname (FQDN)" "${HOSTNAME}" "${Y}" "${C}" 1>> "/etc/issue"
generate_line "Kernel" "${KERNEL}" "${Y}" "${G}" 1>> "/etc/issue"
display_ip_addresses 1>> "/etc/issue"
generate_line "CPU" "${CPU}" "${Y}" "${R}" 1>> "/etc/issue"
generate_line "Uptime" "${UPTIME}" "${Y}" "${G}" 1>> "/etc/issue"
generate_line "Packages (Pacman)" "${PACKAGES}" "${Y}" "${P}" 1>> "/etc/issue"
generate_line "Machine function" "${MACHINETYPE}" "${Y}" "${G}" 1>> "/etc/issue"
generate_line "Users logged in" "${USERS}" "${Y}" "${B}" 1>> "/etc/issue"
generate_line "Unauthorized access state" "${ACCESS}" "${R}" "${R}" \
1>> "/etc/issue"

echo "" 1>> "/etc/issue"


# Calculation of total length to not exceed (defined in LINE_LENGTH)
BAR_LENGTH=$((LINE_LENGTH - TEXT_LENGTH))

# Total line length
LINE_LENGTH=62

# Static length for mountpoints names
MOUNT_POINT_WIDTH=14

# Progress bar length
# 15  for " usage: [ ] 100%"
BAR_LENGTH=$((LINE_LENGTH - MOUNT_POINT_WIDTH - 15))

generate_disk_usage_bar() {

        local mount_point="${1}"
        local disk_usage=$(df "${mount_point}" | awk 'NR==2 { print $5 }' |
        sed 's/%//')

        # Change color depending on the filesystem usage
        if [[ "${disk_usage}" -ge 90 ]]; then
                color="${R}"
        elif [[ "${disk_usage}" -ge 70 ]]; then
                color="${Y}"
        else
                color="${G}"
        fi

        # Truncate the beginning of the path for too long names
        if [[ ${#mount_point} -gt $MOUNT_POINT_WIDTH ]]; then
                mount_point="...${mount_point: -11}"
        fi

        # Filled and empty blocks calculation
        local filled_blocks=$((disk_usage * BAR_LENGTH / 100))
        local empty_blocks=$((BAR_LENGTH - filled_blocks))

        # Generate progress bar
        local bar_filled=$(printf '%*s' "${filled_blocks}" '' | tr ' ' '#')
        local bar_empty=$(printf '%*s' "${empty_blocks}" '' | tr ' ' '-')
        local bar="${bar_filled}${bar_empty}"

        # Display with color
        printf "%-${MOUNT_POINT_WIDTH}s usage: [%b%b%b] %3d%%\n" \
        "${mount_point}" "${color}" "${bar}" "${N}" "${disk_usage}"
}

print_box "Filesystem(s) usage" "${G}" 1>> "/etc/issue"

# Gather the mountpoints with lsblk and generate a progress bar for each
lsblk -o MOUNTPOINTS -n | grep -v '^$' | while read -r mount_point; do
        generate_disk_usage_bar "${mount_point}" 1>> "/etc/issue"
done

echo "" 1>> "/etc/issue"
