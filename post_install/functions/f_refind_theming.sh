refind_theming() {
        
        # IF REFIND INSTALLED

        if [[ "${bootloader}" != "REFIND" ]]; then
                return 1
        fi


        if [[ "${theme_color}" -ne 2 ]]; then
                mkdir -p /boot/EFI/refind/themes
                git clone https://github.com/catppuccin/refind /boot/EFI/refind/themes/catppuccin 1> /dev/null 2>&1
        fi

        case "${theme_color}" in
                0)
                        echo include themes/catppuccin/latte.conf >> /boot/EFI/refind/refind.conf
                        cp -a /boot/EFI/refind/themes/catppuccin/assets/latte/icons/os_arch.png /boot/vmlinuz-"${linux_kernel}".png
                        ;;
                1)
                        echo include themes/catppuccin/mocha.conf >> /boot/EFI/refind/refind.conf
                        cp -a /boot/EFI/refind/themes/catppuccin/assets/mocha/icons/os_arch.png /boot/vmlinuz-"${linux_kernel}".png
                        ;;
        esac
}
