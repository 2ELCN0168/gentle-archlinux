enable_guest_agents() {

        if [[ -z "${guest_agent}" ]]; then
                return
        fi

        case "${guest_agent}" in
                "QEMU")
                        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} qemu-guest-agent.service.${NO_FORMAT}"

                        if systemctl enable qemu-guest-agent 1> /dev/null 2>&1; then
                                echo -e "${C_WHITE}> ${SUC} Successfully enabled ${C_GREEN}qemu-guest-agent.service.${NO_FORMAT}"
                        else
                                echo -e "${C_WHITE}> ${ERR} Error while enabling ${C_RED}qemu-guest-agent.service.${NO_FORMAT}"
                        fi
                        ;;
                "VIRTUALBOX")
                        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} vboxservice.service.${NO_FORMAT}"

                        if systemctl enable vboxservice 1> /dev/null 2>&1; then
                                echo -e "${C_WHITE}> ${SUC} Successfully enabled ${C_GREEN}vboxservice.service.${NO_FORMAT}"
                        else
                                echo -e "${C_WHITE}> ${ERR} Error while enabling ${C_RED}vboxservice.service.${NO_FORMAT}"
                        fi
                        ;;
                "VMWARE")
                        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} vmtoolsd.service.${NO_FORMAT}"

                        if systemctl enable vmtoolsd 1> /dev/null 2>&1; then
                                echo -e "${C_WHITE}> ${SUC} Successfully enabled ${C_GREEN}vmtoolsd.service.${NO_FORMAT}"
                        else
                                echo -e "${C_WHITE}> ${ERR} Error while enabling ${C_RED}vmtoolsd.service.${NO_FORMAT}"
                        fi
                        ;;
                "HYPERV")
                        # echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} hv_fcopy_uio_daemon.service.${NO_FORMAT}"
                        # if systemctl enable hv_fcopy_uio_daemon 1> /dev/null 2>&1; then
                        #         echo -e "${C_WHITE}> ${SUC} Successfully enabled ${C_GREEN}hv_fcopy_uio_daemon.service.${NO_FORMAT}"
                        # else
                        #         echo -e "${C_WHITE}> ${ERR} Error while enabling ${C_RED}hv_fcopy_uio_daemon.service.${NO_FORMAT}"
                        # fi

                        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} hv_kvp_daemon.service.${NO_FORMAT}"
                        if systemctl enable hv_kvp_daemon 1> /dev/null 2>&1; then
                                echo -e "${C_WHITE}> ${SUC} Successfully enabled ${C_GREEN}hv_kvp_daemon.service.${NO_FORMAT}"
                        else
                                echo -e "${C_WHITE}> ${ERR} Error while enabling ${C_RED}hv_kvp_daemon.service.${NO_FORMAT}"
                        fi

                        echo -e "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} hv_vss_daemon.service.${NO_FORMAT}"
                        if systemctl enable hv_vss_daemon 1> /dev/null 2>&1; then
                                echo -e "${C_WHITE}> ${SUC} Successfully enabled ${C_GREEN}hv_vss_daemon.service.${NO_FORMAT}"
                        else
                                echo -e "${C_WHITE}> ${ERR} Error while enabling ${C_RED}hv_vss_daemon.service.${NO_FORMAT}"
                        fi
                        ;;
        esac
        echo ""
}
