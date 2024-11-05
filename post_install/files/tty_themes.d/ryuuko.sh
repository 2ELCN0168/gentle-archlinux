__tty_theme() {

        [ "$TERM" = 'linux' ] || return # Only run in a TTY

	printf "\e]P02c3941"       # black          #2c3941
	printf "\e]P1865f5b"       # red            #865f5b
	printf "\e]P266907d"       # green          #66907d
	printf "\e]P3b1a990"       # brown          #b1a990
	printf "\e]P46a8e95"       # blue           #6a8e95
	printf "\e]P5b18a73"       # magenta        #b18a73
	printf "\e]P688b2ac"       # cyan           #88b2ac
	printf "\e]P7ececec"       # white          #ececec
	printf "\e]P85d7079"       # bright-black   #5d7079
	printf "\e]P9865f5b"       # bright-red     #865f5b
	printf "\e]PA66907d"       # bright-green   #66907d
	printf "\e]PBb1a990"       # bright-brown   #b1a990
	printf "\e]PC6a8e95"       # bright-blue    #6a8e95
	printf "\e]PDb18a73"       # bright-magenta #b18a73
	printf "\e]PE88b2ac"       # bright-cyan    #88b2ac
	printf "\e]PFececec"       # bright-white   #ececec

        clear
}

__tty_theme
