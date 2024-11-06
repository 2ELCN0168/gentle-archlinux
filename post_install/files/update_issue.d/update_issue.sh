#! /bin/bash

# This script is executed by a systemd service to update dynamically the /etc/issue file.

R="\033[91m"
G="\033[92m"
Y="\033[93m"
B="\033[94m"
P="\033[95m"
C="\033[96m"
N="\033[0m"

HOSTNAME=$(hostnamectl hostname)
KERNEL=$(printf "%s %s" "$(command uname -s)" "$(command uname -r)")
IPV4=$(command ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '^127\.0\.0\.1$')
CPU=$(command cat /proc/cpuinfo | grep "model name" | uniq | xargs | sed 's/.*:\s*//')
UPTIME=$(command uptime -p | cut -d " " -f 2-)
PACKAGES=$(pacman -Q | command wc -l)
MACHINETYPE="Workstation"
USERS=$(command who | command wc -l)
ACCESS="Not allowed !"

generate_line() {
    local label="$1"
    local value="$2"
    local color_1="$3"
    local color_2="$4"
    local target_length=60  # Total length of line

    local label_length=${#label}
    local value_length=${#value}
    local dots_length=$((target_length - label_length - value_length))

    local dots=$(printf '.%.0s' $(seq 1 $dots_length))

    echo -e "${color_1}${label}${N} ${dots} ${color_2}${value}${N}"
}

display_ip_addresses() {
    # Récupère les interfaces actives
    interfaces=$(command ip -o link show | awk -F': ' '{print $2}')

    for interface in $interfaces; do
        # Récupère les adresses IPv4
        ipv4_addresses=$(command ip -4 addr show "$interface" | awk '/inet / {print $2}' | cut -d/ -f1)
        for ip in $ipv4_addresses; do
            generate_line "IPv4 ($interface)" "$ip" "${Y}" "${P}"
        done

        # Récupère les adresses IPv6
        ipv6_addresses=$(ip -6 addr show "$interface" | awk '/inet6 / {print $2}' | cut -d/ -f1)
        for ip in $ipv6_addresses; do
            generate_line "IPv6 ($interface)" "$ip" "${Y}" "${P}"
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

        local border_top="╒$(printf '═%.0s' $(seq 1 $inner_width))╕"
        local border_bottom="└$(printf '─%.0s' $(seq 1 $inner_width))┘"

        printf "\n%s\n" "${border_top}"
        printf "╡%b╞\n" "${colored_text}"
        printf "%s\n\n" "${border_bottom}"
}

welcome_text="Welcome to Archlinux /\\"
print_box "${welcome_text}" "${C}" > "/etc/issue"

generate_line "Hostname (FQDN)" "${HOSTNAME}" "${Y}" "${C}">> "/etc/issue"
generate_line "Kernel" "${KERNEL}" "${Y}" "${G}" >> "/etc/issue"
display_ip_addresses >> "/etc/issue"
generate_line "CPU" "${CPU}" "${Y}" "${R}" >> "/etc/issue"
generate_line "Uptime" "${UPTIME}" "${Y}" "${G}">> "/etc/issue"
generate_line "Packages (Pacman)" "${PACKAGES}" "${Y}" "${P}" >> "/etc/issue"
generate_line "Machine function" "${MACHINETYPE}" "${Y}" "${G}" >> "/etc/issue"
generate_line "Users logged in" "${USERS}" "${Y}" "${B}" >> "/etc/issue"
generate_line "Unauthorized access state" "${ACCESS}" "${R}" "${R}" >> "/etc/issue"

echo "" 1>> "/etc/issue"


# Calcul de la longueur de la barre pour respecter la longueur totale de 60 caractères
BAR_LENGTH=$((LINE_LENGTH - TEXT_LENGTH))

# Longueur totale de la ligne
LINE_LENGTH=62

# Largeur fixe pour l'affichage des points de montage
MOUNT_POINT_WIDTH=14

# Largeur de la barre de progression
BAR_LENGTH=$((LINE_LENGTH - MOUNT_POINT_WIDTH - 15))  # 15 pour " usage: [ ] 100%"

# Fonction pour générer la barre de progression
generate_disk_usage_bar() {
    local mount_point="$1"
    local disk_usage=$(df "$mount_point" | awk 'NR==2 {print $5}' | sed 's/%//')

    # Déterminer la couleur en fonction du pourcentage d'utilisation
    if [ "$disk_usage" -ge 90 ]; then
        color=$R
    elif [ "$disk_usage" -ge 70 ]; then
        color=$Y
    else
        color=$G
    fi

    # Tronquer le début des chemins de points de montage longs
    if [ ${#mount_point} -gt $MOUNT_POINT_WIDTH ]; then
        mount_point="...${mount_point: -11}"
    fi

    # Calcul du nombre de blocs remplis et vides
    local filled_blocks=$((disk_usage * BAR_LENGTH / 100))
    local empty_blocks=$((BAR_LENGTH - filled_blocks))

    # Générer la barre de progression
    local bar_filled=$(printf '%*s' "$filled_blocks" '' | tr ' ' '#')
    local bar_empty=$(printf '%*s' "$empty_blocks" '' | tr ' ' '-')
    local bar="${bar_filled}${bar_empty}"

    # Affichage avec couleur
    printf "%-${MOUNT_POINT_WIDTH}s usage: [%b%b%b] %3d%%\n" "$mount_point" "$color" "$bar" "$N" "$disk_usage"
}


print_box "Filesystem(s) usage" "${G}" 1>> "/etc/issue"

# Récupérer les points de montage en utilisant lsblk et générer une barre de chargement pour chacun
lsblk -o MOUNTPOINTS -n | grep -v '^$' | while read -r mount_point; do
    generate_disk_usage_bar "$mount_point" 1>> "/etc/issue"
done
