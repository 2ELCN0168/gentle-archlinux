# FUNCTION(S)
# ---
# The first function will test internet.
# The second will launch iwctl utility to let the user configure internet
# EDIT 1 : Modified variables declarations and tests in conditions + replaced by echo.
# ---

test_internet() {

        declare -igx attempt=3

        while (( "${attempt}" > 0 )); do
                if ping -c 3 1.1.1.1 &> /dev/null; then
                        echo -e "${C_WHITE}> ${SUC} ${C_GREEN}Internet connection detected.${NO_FORMAT}\n"
                        break
                elif ! ping -c 3 1.1.1.1 &> /dev/null; then
                        echo -e "${C_WHITE}> ${WARN} ${C_RED}No Internet connection detected.${NO_FORMAT}\n"
                        run_iwctl
                fi
                (( attempt-- ))
        done

        if [[ "${attempt}" -eq 0 ]]; then
                echo -e "${C_WHITE}> ${ERR} ${C_RED}Max attempts reached. Exiting.${NO_FORMAT}\n"
                exit 1
        fi
        }

run_iwctl() {

        echo -e "${B_YELLOW}:: ${C_WHITE}Would you like to run the iwctl utility to setup a wifi connection? [Y/n] -> ${NO_FORMAT} \c"

        declare ans_iwctl=""
        read ans_iwctl
        : "${ans_iwctl:=Y}"
        echo ""

        case "${ans_iwctl}" in 
                "y"|"Y")
                        iwctl
                        ;;
                "n"|"N")
                        exit 1
                        ;;
                *)
                        invalid_answer
                        ;;
        esac
}
