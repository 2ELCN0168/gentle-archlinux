set_term_env() {

        local xxxrc=(
                ".bashrc"
                ".zshrc"
        )

        for i in "${xxxrc[@]}"; do
                cp "/post_install/files/${i}" "/etc/skel/${i}"
        done

        cp -r "/post_install/files/.config" "/etc/skel"

        local files=(
                ".bashrc"
                ".bash_profile"
                ".zshrc"
                ".config"
        )

        for i in "${files[@]}"; do
                cp -r "/etc/skel/${i}" "/root"
        done

        [[ ! -e "/etc/shell_config.d" ]] && mkdir "/etc/shell_conf.d"

        cp "/post_install/files/shell_conf.d/"* "/etc/shell_conf.d/"

        [[ "${nKorea}" -eq 1 ]] && \
        printf "\nalias fastfetch='fastfetch --logo redstaros'\n" \
        1>> "/etc/skel/.bashrc" \
        1>> "/etc/skel/.zshrc"



        printf "${C_W}> ${INFO} Cloning ${C_G}zsh-fast-syntax-highlighting "
        printf "${N_F} into ${C_P}/usr/share/zsh/plugins${N_F}...\n"

        if git clone \
        "https://github.com/zdharma-continuum/fast-syntax-highlighting" \
        "/usr/share/zsh/plugins/zsh-fast-syntax-highlighting/"; then
                printf "${C_W}> ${SUC} Cloned ${C_G}zsh-fast-syntax-"
                printf "highlighting repository."
        else
                printf "${C_W}> ${ERR} Could not clone ${C_G}zsh-fast-syntax-"
                printf "highlighting repository."
        fi
}
