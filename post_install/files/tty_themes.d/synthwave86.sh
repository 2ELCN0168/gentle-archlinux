__tty_theme() {

        [ "$TERM" = 'linux' ] || return # Only run in a TTY

	printf "\e]P0262335"       # black          #262335
	printf "\e]P1fe4450"       # red            #fe4450
	printf "\e]P272f1b8"       # green          #72f1b8
	printf "\e]P3f3e70f"       # brown          #f3e70f
	printf "\e]P403edf9"       # blue           #03edf9
	printf "\e]P5ff7edb"       # magenta        #ff7edb
	printf "\e]P603edf9"       # cyan           #03edf9
	printf "\e]P7ffffff"       # white          #ffffff
	printf "\e]P8614d85"       # bright-black   #614d85
	printf "\e]P9fe4450"       # bright-red     #fe4450
	printf "\e]PA62f1b8"       # bright-green   #72f1b8
	printf "\e]PBfede5d"       # bright-brown   #fede5d
	printf "\e]PC03edf9"       # bright-blue    #03edf9
	printf "\e]PDff7edb"       # bright-magenta #ff7edb
	printf "\e]PE03edf9"       # bright-cyan    #03edf9
	printf "\e]PFffffff"       # bright-white   #ffffff

        clear
}

__tty_theme
