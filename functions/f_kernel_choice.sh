#
### File: f_kernel_choice.sh
#
### Description: 
# Ask the user for the kernel to use.
#
### Author: 2ELCN0168
# Last updated: 2024-10-03
#
### Dependencies:
# - none.
#
### Usage:
#
# 1. Export some variables about kernel and initramfs;
# 2. Select a default kernel if minimal install is chosen;
# 3. Just ask.
#

ask_kernel() {

        export linux_kernel=""
        export kernel_initramfs=""

        [[ "${bootloader}" == "SYSTEMDBOOT" ]] && \
        export kernel_name="vmlinuz-${linux_kernel}"

        [[ "${param_minimal}" -eq 1 ]] && linux_kernel="linux" && \
        kernel_initramfs="initramfs-linux.img" && return 

        while true; do

                printf "==${C_C}KERNEL${N_F}============\n\n"

                printf "${C_W}[0] - ${C_C}linux${N_F} (default)\n"
                printf "${C_W}[1] - ${C_R}linux-lts${N_F}\n"
                printf "${C_W}[2] - ${C_P}linux-hardened${N_F}\n"
                printf "${C_W}[3] - ${C_Y}linux-zen${N_F}\n"
                
                printf "\n====================\n\n"


                printf "${C_C}${BOLD}:: ${C_W}Which kernel do you want to "
                printf "install? -> ${N_F}"

                local ans_kernel=""
                read ans_kernel
                : "${ans_kernel:=0}"

                case "${ans_kernel}" in
                        0)
                                printf "${C_W}> ${INFO} You chose the " 
                                printf "standard linux kernel.\n\n"
                                linux_kernel="linux"
                                kernel_initramfs="initramfs-linux.img"
                                break
                                ;;
                        1)
                                printf "${C_W}> ${INFO} You chose the LTS " 
                                printf "linux kernel. Useful for servers.\n\n"
                                linux_kernel="linux-lts"
                                kernel_initramfs="initramfs-linux-lts.img"
                                break
                                ;;
                        2)
                                printf "${C_W}> ${INFO} You chose the "
                                printf "hardened linux kernel. I see you're "
                                printf "a paranoid, don't worry we're three."
                                printf "\n\n"
                                linux_kernel="linux-hardened"
                                kernel_initramfs="initramfs-linux-hardened.img"
                                break
                                ;;
                        3)
                                printf "${C_W}> ${INFO} You chose the "
                                printf "zen linux kernel. That's your choice."
                                printf "\n\n"
                                linux_kernel="linux-zen"
                                kernel_initramfs="initramfs-linux-zen.img"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done
}
