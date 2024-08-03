### COLOR VARIABLES

declare -gx C_RED="\033[91m"
declare -gx C_GREEN="\033[92m"
declare -gx C_YELLOW="\033[93m"
declare -gx C_BLUE="\033[94m"
declare -gx C_PINK="\033[95m"
declare -gx C_CYAN="\033[96m"
declare -gx C_WHITE="\033[97m"

declare -gx B_RED="\033[41;30m"
declare -gx B_GREEN="\033[42;30m"
declare -gx B_YELLOW="\033[43;30m"
declare -gx B_BLUE="\033[44;30m"
declare -gx B_PINK="\033[45;30m"
declare -gx B_CYAN="\033[46;30m"
declare -gx B_WHITE="\033[47;30m"

declare -gx BOLD="\033[1m"

# End of the color sequence
declare -gx NO_FORMAT="\033[0m"

### MESSAGE TYPES

declare -gx INFO="${C_WHITE}[${C_CYAN}INFO${C_WHITE}]${NO_FORMAT}"
declare -gx WARN="${C_WHITE}[${C_YELLOW}WARNING${C_WHITE}]${NO_FORMAT}"
declare -gx ERR="${C_WHITE}[${C_RED}ERROR${C_WHITE}]${NO_FORMAT}"
declare -gx SUC="${C_WHITE}[${C_GREEN}SUCCESS${C_WHITE}]${NO_FORMAT}"
