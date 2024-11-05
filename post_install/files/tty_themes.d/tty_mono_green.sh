__tty_theme() {

        [ "$TERM" = 'linux' ] || return # Only run in a TTY

	printf "\e]P0142e2c"       # black          #142e2c
	printf "\e]P150deac"       # red            #50deac
	printf "\e]P250deac"       # green          #50deac
	printf "\e]P350deac"       # brown          #50deac
	printf "\e]P450deac"       # blue           #50deac
	printf "\e]P550deac"       # magenta        #50deac
	printf "\e]P650deac"       # cyan           #50deac
	printf "\e]P750deac"       # white          #50deac
	printf "\e]P8142e2c"       # bright-black   #142e2c
	printf "\e]P950deac"       # bright-red     #50deac
	printf "\e]PA50deac"       # bright-green   #50deac
	printf "\e]PB50deac"       # bright-brown   #50deac
	printf "\e]PC50deac"       # bright-blue    #50deac
	printf "\e]PD50deac"       # bright-magenta #50deac
	printf "\e]PE50deac"       # bright-cyan    #50deac
	printf "\e]PF50deac"       # bright-white   #50deac

        clear
}

__tty_theme
