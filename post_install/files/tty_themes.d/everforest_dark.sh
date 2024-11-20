__tty_theme() {

        [ "$TERM" = 'linux' ] || return # Only run in a TTY

	printf "\e]P02d353b"       # black          #2d353b
	printf "\e]P1e67e80"       # red            #e67e80
	printf "\e]P2a7c080"       # green          #a7c080
	printf "\e]P3dbbc7f"       # brown          #dbbc7f
	printf "\e]P47fbbb3"       # blue           #7fbbb3
	printf "\e]P5d699b6"       # magenta        #d699b6
	printf "\e]P683c092"       # cyan           #83c092
	printf "\e]P7d3c6aa"       # white          #d3c6aa
	printf "\e]P8475258"       # bright-black   #475258
	printf "\e]P9e67e80"       # bright-red     #e67e80
	printf "\e]PAa7c080"       # bright-green   #a7c080
	printf "\e]PBdbbc7f"       # bright-brown   #dbbc7f
	printf "\e]PC7fbbb3"       # bright-blue    #7fbbb3
	printf "\e]PDd699b6"       # bright-magenta #d699b6
	printf "\e]PE83c092"       # bright-cyan    #83c092
	printf "\e]PFd3c6aa"       # bright-white   #d3c6aa

        clear
}

__tty_theme
