admin_method() {

         [[ "${createUser}" =~ [nN] ]] && return

         while true; do
                printf "${C_C}:: ${C_W}Will this user be administrator? \n"
                printf "${C_C}:: ${C_Y}Warning, if you answer 'No' "
                printf "while having deactivated the root account, "
                printf "you won't be able to perform administrative tasks "
                printf "at all! ${C_W}[Y/n] -> ${N_F}"

                read ans_sudoer
                : "${ans_sudoer:=Y}"
                printf "\n"

                if [[ "${ans_sudoer}" =~ [yY] ]]; then
                        printf "\n"
                        break
                elif [[ "${ans_sudoer}" =~ [nN] ]]; then
                        return
                else
                        invalid_answer
                fi
        done

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
                printf "group only.${N_F}\n"

                printf "${C_C}:: ${C_W}Which method of administration do you "
                printf "want for your system? -> ${N_F}"

                local ans_method=""
                read ans_method
                : "${ans_method:=1}"
                printf "\n"


                # COMMAND:
                echo -e "\n# Options added by Archlinux Gentle Installer" \
                1>> "/etc/sudoers"

                echo -e "Defaults timestamp_timeout=0" 1>> "/etc/sudoers"
                echo -e "Defaults insults" 1>> "/etc/sudoers"
                echo -e "Defaults pwfeedback" 1>> "/etc/sudoers"


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
                        "adm-elevate"
                        )

                        for i in "${adm_groups}"; do 
                                groupadd "${i}" 1> "/dev/null" 2>&1
                                printf "${C_W}> ${SUC} Created group "
                                printf "${C_G}${i}${N_F}.\n"
                        done

                       cat <<EOF > "/etc/sudoers.d/adm-ssh"
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
                        cat <<EOF > "/etc/sudoers.d/adm-disks"
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
                             /usr/bin/mkfs.btrfs, \
                             /usr/bin/mkfs.xfs, \
                             /usr/bin/mkswap, \
                             /usr/sbin/swapon, \
                             /usr/sbin/swapoff
EOF
                        cat <<EOF > "/etc/sudoers.d/adm-services"
%adm-services ALL=(ALL) PASSWD: /usr/bin/systemctl, \
                                /usr/bin/journalctl, \
EOF
                        cat <<EOF > "/etc/sudoers.d/adm-logs"
%adm-logs ALL=(ALL) PASSWD:     /usr/bin/journalctl, \
                                /usr/bin/dmesg, \
                                /usr/bin/cat /var/log/
EOF
                        cat <<EOF > "/etc/sudoers.d/adm-packages"
%adm-packages ALL=(ALL) PASSWD: /usr/bin/pacman
EOF
                        cat <<EOF > "/etc/sudoers.d/adm-networking"
%adm-networking ALL=(ALL) PASSWD:       /usr/bin/networkctl, \
                                        /usr/bin/resolvectl, \
                                        /usr/bin/nmtui
                                        /usr/bin/systemctl start NetworkManager
                                        /usr/bin/systemctl stop NetworkManager
                                        /usr/bin/systemctl restart NetworkManager
                                        /usr/bin/systemctl disable NetworkManager
                                        /usr/bin/systemctl enable NetworkManager
                                        /usr/bin/systemctl start
                                        /usr/bin/systemctl start
                                        /usr/bin/systemctl start
                                        /usr/bin/systemctl start
                                        /usr/bin/systemctl start
                                        /usr/bin/systemctl start
                                        /usr/bin/systemctl start
                                        /usr/bin/systemctl start
                                        /usr/bin/systemctl start
                                        /usr/bin/systemctl start
                                        /usr/bin/systemctl start
                                        /usr/bin/systemctl start
                                        /usr/bin/systemctl start
EOF
                break
                elif [[ "${ans_method}" -eq 1 ]]; then
                        usermod -aG wheel "${username}"
                        printf "${C_W}> ${SUC} Added ${C_Y}${username}${N_F} "
                        printf "to ${C_C}wheel${N_F} group.\n\n"
                        echo -e "%wheel ALL=(ALL:ALL) ALL" 1>> "/etc/sudoers"
                        break
                fi
        done
}
