refind_theming() {
        
        # IF REFIND INSTALLED

        [[ "${bootloader}" != "REFIND" ]] && return 1

        local dest_path="/boot/EFI/refind/themes/catppuccin"
        
        if [[ "${theme_brightness}" =~ [01] ]]; then
                mkdir -p "/boot/EFI/refind/themes"
                git clone "https://github.com/catppuccin/refind" \
                "${dest_path}" 1> "/dev/null" 2>&1
        fi

        if [[ "${theme_brightness}" -eq 1 ]]; then
                printf "\ninclude themes/catppuccin/latte.conf" \
                1>> "/boot/EFI/refind/refind.conf"

                cp -a "${dest_path}/assets/latte/icons/os_arch.png" \
                "/boot/vmlinuz-${linux_kernel}.png"
        elif [[ "${theme_brightness}" -eq 0 ]]; then
                printf "\ninclude themes/catppuccin/mocha.conf" \
                1>> "/boot/EFI/refind/refind.conf"
                
                cp -a "${dest_path}/assets/mocha/icons/os_arch.png" \
                "/boot/vmlinuz-${linux_kernel}.png"
        fi
}
