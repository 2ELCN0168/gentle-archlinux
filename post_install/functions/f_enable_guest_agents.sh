#
### File: f_enable_guest_agents.sh
#
### Description: 
# If the user installed guest agent, enable it.
#
### Author: 2ELCN0168
# Last updated: 2024-11-08
# 
### Dependencies:
# - the guest agents listed in the case.
#
### Usage:
#
# 1. Enabling the services.
#
# WARN:
# HYPERV doesn't work (Don't worry it's a Microsoft habit).

enable_guest_agents() {

        [[ -z "${guest_agent}" ]] && return

        case "${guest_agent}" in
                "QEMU")
                        printf "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable"
                        printf "${C_W} qemu-guest-agent.service.${N_F}\n"

                        if systemctl enable qemu-guest-agent \
                        1> "/dev/null" 2>&1; then
                                printf "${C_W}> ${SUC} Successfully enabled "
                                printf "${C_G}qemu-guest-agent.service.${N_F}"
                        else
                                printf "${C_W}> ${ERR} Error while enabling "
                                printf "${C_R}qemu-guest-agent.service.${N_F}"
                        fi
                        ;;
                "VIRTUALBOX")
                        printf "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable"
                        printf "${C_W} vboxservice.service.${N_F}\n"

                        if systemctl enable vboxservice \
                        1> "/dev/null" 2>&1; then
                                printf "${C_W}> ${SUC} Successfully enabled "
                                printf "${C_G}vboxservice.service.${N_F}"
                        else
                                printf "${C_W}> ${ERR} Error while enabling "
                                printf "${C_R}vboxservice.service.${N_F}"
                        fi
                        ;;
                "VMWARE")
                        printf "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable"
                        printf "${C_W} vmtoolsd.service.${N_F}\n"

                        if systemctl enable vmtoolsd 1> "/dev/null" 2>&1; then
                                printf "${C_W}> ${SUC} Successfully enabled "
                                printf "${C_G}vmtoolsd.service.${N_F}"
                        else
                                printf "${C_W}> ${ERR} Error while enabling "
                                printf "${C_R}vmtoolsd.service.${N_F}"
                        fi
                        ;;
                "HYPERV")

                        # WARN: 
                        # HYPERV guest agent is not working!
                        #
                        # printf "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable"
                        # printf "${C_W} hv_fcopy_uio_daemon.service.${N_F}"
                        # if systemctl enable hv_fcopy_uio_daemon \
                        # 1> /dev/null 2>&1; then
                        #         printf "${C_W}> ${SUC} Successfully enabled "
                        #         printf "${C_G}hv_fcopy_uio_daemon.service."
                        #         printf "${N_F}"
                        # else
                        #         printf "${C_W}> ${ERR} Error while enabling "
                        #         printf "${C_R}hv_fcopy_uio_daemon.service."
                        #         printf "${N_F}"
                        # fi

                        printf "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable"
                        printf "${C_W} hv_kvp_daemon.service.${N_F}\n"

                        if systemctl enable hv_kvp_daemon \
                        1> "/dev/null" 2>&1; then
                                printf "${C_W}> ${SUC} Successfully enabled "
                                printf "${C_G}hv_kvp_daemon.service.${N_F}"
                        else
                                printf "${C_W}> ${ERR} Error while enabling "
                                printf "${C_R}hv_kvp_daemon.service.${N_F}"
                        fi

                        printf "\n\n"

                        printf "${C_W}> ${INFO} ${C_W}systemctl ${C_G}enable"
                        printf "${C_W} hv_vss_daemon.service.${N_F}\n"

                        if systemctl enable hv_vss_daemon \
                        1> "/dev/null" 2>&1; then
                                printf "${C_W}> ${SUC} Successfully enabled "
                                printf "${C_G}hv_vss_daemon.service.${N_F}"
                        else
                                printf "${C_W}> ${ERR} Error while enabling "
                                printf "${C_R}hv_vss_daemon.service.${N_F}"
                        fi
                        ;;
        esac

        printf "\n\n"
}
