enable_guest_agents() {

        if [[ -z "${guest_agent}" ]]; then
                return
        fi

        case "${guest_agent}" in
                "QEMU")
                        echo -e "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} qemu-guest-agent.service.${N_F}"

                        if systemctl enable qemu-guest-agent 1> "/dev/null" 2>&1; then
                                echo -e "${C_W}> ${SUC} Successfully enabled ${C_G}qemu-guest-agent.service.${N_F}"
                        else
                                echo -e "${C_W}> ${ERR} Error while enabling ${C_R}qemu-guest-agent.service.${N_F}"
                        fi
                        ;;
                "VIRTUALBOX")
                        echo -e "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} vboxservice.service.${N_F}"

                        if systemctl enable vboxservice 1> "/dev/null" 2>&1; then
                                echo -e "${C_W}> ${SUC} Successfully enabled ${C_G}vboxservice.service.${N_F}"
                        else
                                echo -e "${C_W}> ${ERR} Error while enabling ${C_R}vboxservice.service.${N_F}"
                        fi
                        ;;
                "VMWARE")
                        echo -e "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} vmtoolsd.service.${N_F}"

                        if systemctl enable vmtoolsd 1> "/dev/null" 2>&1; then
                                echo -e "${C_W}> ${SUC} Successfully enabled ${C_G}vmtoolsd.service.${N_F}"
                        else
                                echo -e "${C_W}> ${ERR} Error while enabling ${C_R}vmtoolsd.service.${N_F}"
                        fi
                        ;;
                "HYPERV")
                        # echo -e "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} hv_fcopy_uio_daemon.service.${N_F}"
                        # if systemctl enable hv_fcopy_uio_daemon 1> /dev/null 2>&1; then
                        #         echo -e "${C_W}> ${SUC} Successfully enabled ${C_G}hv_fcopy_uio_daemon.service.${N_F}"
                        # else
                        #         echo -e "${C_W}> ${ERR} Error while enabling ${C_R}hv_fcopy_uio_daemon.service.${N_F}"
                        # fi

                        echo -e "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} hv_kvp_daemon.service.${N_F}"
                        if systemctl enable hv_kvp_daemon 1> "/dev/null" 2>&1; then
                                echo -e "${C_W}> ${SUC} Successfully enabled ${C_G}hv_kvp_daemon.service.${N_F}"
                        else
                                echo -e "${C_W}> ${ERR} Error while enabling ${C_R}hv_kvp_daemon.service.${N_F}"
                        fi

                        echo -e "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable${C_W} hv_vss_daemon.service.${N_F}"
                        if systemctl enable hv_vss_daemon 1> "/dev/null" 2>&1; then
                                echo -e "${C_W}> ${SUC} Successfully enabled ${C_G}hv_vss_daemon.service.${N_F}"
                        else
                                echo -e "${C_W}> ${ERR} Error while enabling ${C_R}hv_vss_daemon.service.${N_F}"
                        fi
                        ;;
        esac
        echo ""
}
