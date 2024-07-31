refind_theming() {
        
        # IF REFIND INSTALLED

        if [[ "$bootloader" != 'REFIND' ]]; then
                return 1
        fi

        mkdir -p /boot/EFI/refind/themes
        git clone https://github.com/catppuccin/refind /boot/EFI/refind/themes/catppuccin &> /dev/null

        if [[ "$theme_color" -eq 0 ]]; then
                echo include themes/catppuccin/latte.conf >> /boot/EFI/refind/refind.conf
                cp -a /boot/EFI/refind/themes/catppuccin/assets/latte/icons/os_arch.png /boot/vmlinuz-linux.png
        elif [[ "$theme_color" -eq 1 ]]; then
                echo include themes/catppuccin/mocha.conf >> /boot/EFI/refind/refind.conf
                cp -a /boot/EFI/refind/themes/catppuccin/assets/mocha/icons/os_arch.png /boot/vmlinuz-linux.png
        elif [[ "$theme_color" -eq 1 ]]; then
                rm -rf /boot/EFI/refind/themes/catppuccin &> /dev/null
        fi
}
