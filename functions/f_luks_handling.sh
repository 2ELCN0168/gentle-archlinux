# FUNCTION(S)
# ---
# This function creates a LUKS format partition if the user answered "yes" to one of the first questions.
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

luks_handling() {

        # FORMATTING DONE
        echo -e "${C_WHITE}> ${INFO} Starting to encrypt your new system...\n"

        if cryptsetup luksFormat "${root_part}"; then
                echo -e "\n${C_WHITE}> ${SUC} ${C_GREEN}Successfully created LUKS partition on ${root_part}.${NO_FORMAT}\n"
        else
                echo -e "\n${C_WHITE}> ${ERR} ${C_RED}Error during LUKS partition creation on ${root_part}.${NO_FORMAT}\n"
                exit 1
        fi

        echo -e "${C_WHITE}> ${INFO} Opening the new encrypted volume.\n"

        cryptsetup open "${root_part}" root

        echo -e "\n${C_WHITE}> ${INFO} Replacing ${root_part} by ${C_PINK}/dev/mapper/root.${NO_FORMAT}\n"

        root_part="/dev/mapper/root"
}
