### COLOR VARIABLES

export C_R="\033[91m"
export C_G="\033[92m"
export C_Y="\033[93m"
export C_B="\033[94m"
export C_P="\033[95m"
export C_C="\033[96m"
export C_W="\033[97m"

export B_R="\033[41;30m"
export B_G="\033[42;30m"
export B_Y="\033[43;30m"
export B_B="\033[44;30m"
export B_P="\033[45;30m"
export B_C="\033[46;30m"
export B_W="\033[47;30m"

export BOLD="\033[1m"

# End of the color sequence
export N_F="\033[0m"

### MESSAGE TYPES

# export INFO="${C_W}[${C_C}INFO${C_W}]${N_F}"
# export WARN="${C_W}[${C_Y}WARNING${C_W}]${N_F}"
# export ERR="${C_W}[${C_R}ERROR${C_W}]${N_F}"
# export SUC="${C_W}[${C_G}SUCCESS${C_W}]${N_F}"

export INFO="${C_C}[>]${N_F}"
export WARN="${C_Y}[@]${N_F}"
export ERR="${C_R}[!]${N_F}"
export SUC="${C_G}[*]${N_F}"

# print_box() {
#
#     local text="${1}"
#     local color="${2}"
#     local reset="\033[0m"
#
#     # NOTE:
#     # 4 is equal to default spaces number if nothing is provided at argument 3
#     local padding="${3:-4}"
#     local width=$(( ${#text} + padding * 2 ))
#     
#     local colored_text="${color}$(printf ' %.0s' $(seq 1 $padding))${text}$(printf ' %.0s' $(seq 1 $padding))${reset}"
#
#     local border_top="┌$(printf '─%.0s' $(seq 1 $((width + 2))))┐"
#     local border_bottom="└$(printf '─%.0s' $(seq 1 $((width + 2))))┘"
#
#     printf "\n%s\n" "${border_top}"
#     printf "│%b│\n" "${colored_text}"
#     printf "%s\n\n" "${border_bottom}"
# }

print_box() {
    local text="${1}"
    local color="${2}"
    local reset="\033[0m"
    local padding="${3:-2}"  # Par défaut, 2 espaces de chaque côté
    local text_length=${#text}
    local total_length=$((text_length + padding * 2))
    
    # Génération des espaces de chaque côté
    local padding_left=$(printf ' %.0s' $(seq 1 $padding))
    local padding_right=$(printf ' %.0s' $(seq 1 $((total_length - text_length - padding))))

    # Génération du texte coloré avec padding
    local colored_text="${color}${padding_left}${text}${padding_right}${reset}"

    # Génération des bordures
    local border_top="┌$(printf '─%.0s' $(seq 1 $((total_length + 2))))┐"
    local border_bottom="└$(printf '─%.0s' $(seq 1 $((total_length + 2))))┘"

    # Affichage de la boîte
    printf "\n%s\n" "${border_top}"
    printf "│%b│\n" "${colored_text}"
    printf "%s\n\n" "${border_bottom}"
}
