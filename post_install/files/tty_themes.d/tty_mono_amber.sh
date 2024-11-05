__tty_theme() {

        [ "$TERM" = 'linux' ] || return # Only run in a TTY

	printf "\e]P02b1900"       # black          #2b1900
	printf "\e]P1ff9400"       # red            #ff9400
	printf "\e]P2ff9400"       # green          #ff9400
	printf "\e]P3ff9400"       # brown          #ff9400
	printf "\e]P4ff9400"       # blue           #ff9400
	printf "\e]P5ff9400"       # magenta        #ff9400
	printf "\e]P6ff9400"       # cyan           #ff9400
	printf "\e]P7ff9400"       # white          #ff9400
	printf "\e]P8402500"       # bright-black   #402500
	printf "\e]P9ff9400"       # bright-red     #ff9400
	printf "\e]PAff9400"       # bright-green   #ff9400
	printf "\e]PBff9400"       # bright-brown   #ff9400
	printf "\e]PCff9400"       # bright-blue    #ff9400
	printf "\e]PDff9400"       # bright-magenta #ff9400
	printf "\e]PEff9400"       # bright-cyan    #ff9400
	printf "\e]PFff9400"       # bright-white   #ff9400

        clear
}

__tty_theme
