__tty_theme() {

        [ "$TERM" = 'linux' ] || return # Only run in a TTY

	printf "\e]P01b1d1e"       # black          #1b1d1e
	printf "\e]P1e6dc44"       # red            #e6dc44
	printf "\e]P2c8be46"       # green          #c8be46
	printf "\e]P3f4fd22"       # brown          #f4fd22
	printf "\e]P4737174"       # blue           #737174
	printf "\e]P5747271"       # magenta        #747271
	printf "\e]P662605f"       # cyan           #62605f
	printf "\e]P7c6c5bf"       # white          #c6c5bf
	printf "\e]P8505354"       # bright-black   #505354
	printf "\e]P9fff78e"       # bright-red     #fff78e
	printf "\e]PAfff27d"       # bright-green   #fff27d
	printf "\e]PBfeed6c"       # bright-brown   #feed6c
	printf "\e]PC919495"       # bright-blue    #919495
	printf "\e]PD9a9a9d"       # bright-magenta #9a9a9d
	printf "\e]PEa3a3a6"       # bright-cyan    #a3a3a6
	printf "\e]PFdadbd6"       # bright-white   #dadbd6

        clear
}

__tty_theme
