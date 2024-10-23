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
