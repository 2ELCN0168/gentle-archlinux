
ask_kernel() {

        declare -gx linux_kernel=""
        declare -gx kernel_initramfs=""

        while true; do
                echo -e "==KERNEL============\n"

                echo -e "${C_WHITE}[0] - ${C_CYAN}linux${NO_FORMAT} (default)"
                echo -e "${C_WHITE}[1] - ${C_RED}linux-lts${NO_FORMAT}"
                echo -e "${C_WHITE}[2] - ${C_PINK}linux-hardened${NO_FORMAT}"
                echo -e "${C_WHITE}[3] - ${C_YELLOW}linux-zen${NO_FORMAT}"
                
                echo -e "\n====================\n"


                echo -e "${C_CYAN}${BOLD}:: ${C_WHITE}Which kernel do you want to install? ->${NO_FORMAT} \c"

                declare -i ans_kernel=0
                read ans_kernel
                : $"{$ans_kernel:=0}"
                echo ""

                case "${ans_kernel}" in
                        0)
                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose the standard linux kernel.\n"
                                linux_kernel="linux"
                                kernel_initramfs="initramfs-linux.img"
                                break
                                ;;
                        1)
                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose the LTS linux kernel. Useful for servers.\n"
                                linux_kernel="linux-lts"
                                kernel_initramfs="initramfs-linux-lts.img"
                                break
                                ;;
                        2)
                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose the hardened linux kernel. I see you're a paranoid, don't worry we're three.\n"
                                linux_kernel="linux-hardened"
                                kernel_initramfs="initramfs-linux-hardened.img"
                                break
                                ;;
                        3)
                                echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose the zen linux kernel. That's your choice.\n"
                                linux_kernel="linux-zen"
                                kernel_initramfs="initramfs-linux-zen.img"
                                break
                                ;;
                        *)
                                invalid_answer
                                ;;
                esac
        done

        if [[ "${bootloader}" == "SYSTEMDBOOT" ]]; then
                declare -gx kernel_name="vmlinuz-${linux_kernel}"
        fi
}
