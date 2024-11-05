#
### File: f_set_pacman.sh
#
### Description: 
# Modify the pacman configuration.
#
### Author: 2ELCN0168
# Last updated: 2024-11-05
# 
### Dependencies:
# - none.
#
### Usage:
#
# 1. Uncomment Color;
# 2. Uncomment ParallelDownloads;
# 3. Update tealdeer (If installed).
#

set_pacman() {

        # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf AGAIIIIN
        printf "${C_W}> ${INFO} ${N_F}Uncommenting ${C_G}'Color'${N_F} and "
        printf "${C_G}'ParallelDownloads 5'${N_F} in ${C_P}/mnt/etc/"
        printf "pacman.conf${N_F} AGAIIIIN.\n\n"

        #sed -i '/^\s*#\(Color\|ParallelDownloads\)/ s/^#//' /etc/pacman.conf
        sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' "/etc/pacman.conf"

        if tldr -v 1> "/dev/null" 2>&1; then
                tldr --update 1> "/dev/null" 2>&1
        fi
}
