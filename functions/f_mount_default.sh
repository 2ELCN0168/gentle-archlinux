# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.

mount_default() {

        # FORMATTING DONE
        echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}${root_part}${NO_FORMAT} to /mnt"
        if mount "${root_part}" "/mnt" 1> "/dev/null" 2>&1; then
                echo -e "${C_WHITE}> ${SUC} Mounted ${C_GREEN}${boot_part}${NO_FORMAT} to /mnt/boot\n"
        else
                echo -e "${C_WHITE}> ${ERR} Error while mounting ${C_GREEN}${boot_part}${NO_FORMAT} to /mnt/boot\n"
                exit 1
        fi

        echo -e "${C_WHITE}> ${INFO} Mounting ${C_GREEN}${boot_part}${NO_FORMAT} to /mnt/boot"
        if mount --mkdir "${boot_part}" "/mnt/boot" 1> "/dev/null" 2>&1; then
                echo -e "${C_WHITE}> ${SUC} Mounted ${C_GREEN}${boot_part}${NO_FORMAT} to /mnt/boot\n"
        else
                echo -e "${C_WHITE}> ${ERR} Error while mounting ${C_GREEN}${boot_part}${NO_FORMAT} to /mnt/boot\n"
                exit 1
        fi
}
