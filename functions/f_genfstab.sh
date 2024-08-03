# FUNCTION(S)
# ---
# This function just generates the fstab file. 
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

gen_fstab() {

        # Generate /etc/fstab of the new system
        echo -e "${C_WHITE}> ${INFO} ${NO_FORMAT}Generating ${C_PINK}/mnt/etc/fstab${NO_FORMAT} file."
        if genfstab -U /mnt >> /mnt/etc/fstab; then
                echo -e "${C_WHITE}> ${SUC} ${NO_FORMAT}Generated ${C_PINK}/mnt/etc/fstab${NO_FORMAT} file.\n"
        else
                echo -e "${C_WHITE}> ${WARN} ${NO_FORMAT}Failed to generate ${C_PINK}/mnt/etc/fstab${NO_FORMAT} file.\n"
        fi
}
