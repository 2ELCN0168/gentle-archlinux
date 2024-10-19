admin_method() {

        while true; do
                printf "==${C_C}ADMINISTRATION${N_F}====\n\n"

                printf "${C_W}[0] - ${C_Y}Complete with 'adm' groups${C_R} "
                printf "[Recommended]${N_F}\n"
                printf "${C_W}[1] - ${C_B}Standard usage of 'sudo' "
                printf "${N_F}[default]\n"
                
                printf "\n====================\n\n"

                printf "${C_C}:: ${C_W}Complete method will create a lot of "
                printf "groups for each type of usage (e.g., disk management "
                printf "packages, services, etc.).${N_F}\n"

                printf "${C_C}:: ${C_W}Standard method will enable 'wheel' "
                printf "only.${N_F}\n"

                printf "${C_C}:: ${C_W}Which method of administration do you "
                printf "want for your system? -> ${N_F}"

                local ans_method=""
                read ans_method
                : "${ans_method:=1}"
                printf "\n"


                # COMMAND:
                printf "\n\n# Options added by Archlinux Gentle Installer" \
                1>> "/etc/sudoers"

                printf "Defaults timestamp_timeout=0\n" 1>> "/etc/sudoers"
                printf "Defaults insults\n" 1>> "/etc/sudoers"
                printf "Defaults pwfeedback\n" 1>> "/etc/sudoers"


                if [[ "${ans_method}" -eq 0 ]]; then
                        local adm_groups=(
                        "adm-ssh"
                        "adm-disks"
                        "adm-services"
                        "adm-logs"
                        "adm-packages"
                        "adm-networking"
                        "adm-firewall"
                        "adm-filesystem"
                        "adm-kernel"
                        "adm-systemd"
                        )

                        for i in "${adm_groups}"; do 
                                groupadd "${i}" 1> "/dev/null" 2>&1
                                printf "${C_W}> ${SUC} Created group "
                                printf "${C_G}${i}${N_F}.\n"
                        done

                       cat <<-EOF > "/etc/sudoers.d/adm-ssh"
%adm-ssh ALL=(ALL) PASSWD: /usr/bin/systemctl start ssh, \
                           /usr/bin/systemctl stop ssh, \
                           /usr/bin/systemctl restart ssh, \
                           /usr/bin/systemctl reload ssh, \
                           /usr/bin/systemctl status ssh, \
                           /usr/bin/journalctl -u ssh, \
                           /usr/bin/cat /var/log/auth.log, \
                           /usr/bin/nano /etc/ssh/sshd_config, \
                           /usr/bin/vim /etc/ssh/sshd_config, \
                           /usr/bin/less /etc/ssh/sshd_config, \
                           /usr/sbin/sshd -t, \
                           /usr/bin/ssh-keygen, \
                           /usr/bin/ssh-add, \
                           /usr/bin/ssh-agent, \
                           /usr/bin/ssh
EOF
                        cat <<-EOF > "/etc/sudoers.d/adm-disks"
%adm-disks ALL=(ALL) PASSWD: /usr/bin/mount, \
                             /usr/bin/umount, \
                             /usr/bin/df, \
                             /usr/bin/du, \
                             /usr/sbin/fsck, \
                             /usr/bin/mkfs, \
                             /usr/sbin/fdisk, \
                             /usr/sbin/parted, \
                             /usr/sbin/gdisk, \
                             /usr/sbin/lvm, \
                             /usr/sbin/pvcreate, \
                             /usr/sbin/vgcreate, \
                             /usr/sbin/lvcreate, \
                             /usr/sbin/vgextend, \
                             /usr/sbin/lvextend, \
                             /usr/sbin/lsblk, \
                             /usr/bin/blkid, \
                             /usr/sbin/blkid, \
                             /usr/bin/mkfs.ext4, \
                             /usr/bin/mkfs.vfat, \
                             /usr/bin/mkswap, \
                             /usr/sbin/swapon, \
                             /usr/sbin/swapoff
EOF

                elif [[ "${ans_method}" -eq 1 ]]; then
                        usermod -aG wheel "${username}"
                        printf "%wheel ALL=(ALL:ALL) ALL\n" 1>> "/etc/sudoers"

                fi


        done
}

admin_method
