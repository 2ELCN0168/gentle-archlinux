set_term_env() {

        local xxxrc=(
                ".bashrc"
                ".zshrc"
        )

        for i in "${xxxrc[@]}"; do
                cp "/post_install/files/${i}" "/etc/skel/${i}"
        done

        local files=(
                ".bashrc"
                ".bash_profile"
                ".zshrc"
        )

        for i in "${files[@]}"; do
                cp "/etc/skel/${i}" "/root"
        done

        [[ ! -e "/etc/shell_config.d" ]] && mkdir "/etc/shell_conf.d"

        cp "/post_install/files/shell_conf.d/"* "/etc/shell_conf.d/"

        [[ "${nKorea}" -eq 1 ]] && \
        printf "\nalias fastfetch='fastfetch --logo redstaros'\n" \
        1>> "/etc/skel/.bashrc" \
        1>> "/etc/skel/.zshrc"
}
