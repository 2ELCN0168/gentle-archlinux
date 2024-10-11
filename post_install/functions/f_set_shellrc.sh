set_term_env() {

        [[ "${nKorea}" -eq 1 ]] && \
        printf "\nalias fastfetch='fastfetch --logo redstaros'\n" \
        1>> "/etc/skel/.{bashrc,zshrc}"

        cp "/post_install/files/.bashrc_template" "/etc/skel"
        cp "/post_install/files/.zshrc_template" "/etc/skel"

        cp "/etc/skel/.bashrc" "/root"
        cp "/etc/skel/.bash_profile" "/root"
        cp "/etc/skel/.zshrc" "/root"

        cp "/post_install/files/profile.d/*" "/etc/profile.d/"
}