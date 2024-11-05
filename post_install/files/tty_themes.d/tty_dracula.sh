__tty_theme() {

        [ "$TERM" = 'linux' ] || return # Only run in a TTY

	printf %b '\e[40m' '\e[8]' # set default backgrougd to color 0
	printf %b '\e[37m' '\e[8]' # set default foreground to color 7
	printf "\e]P0282a36"       # black          #282a36
	printf "\e]P1ff5555"       # red            #ff5555
	printf "\e]P250fa7b"       # green          #50fa7b
	printf "\e]P3f1fa8c"       # brown          #f1fa8c
	printf "\e]P4bd93f9"       # blue           #bd93f9
	printf "\e]P5ff79c6"       # magenta        #ff79c6
	printf "\e]P68be9fd"       # cyan           #8be9fd
	printf "\e]P7f8f8f2"       # white          #f8f8f2
	printf "\e]P86272a4"       # bright-black   #6272a4
	printf "\e]P9ff7777"       # bright-red     #ff7777
	printf "\e]PA70fa9b"       # bright-green   #70fa9b
	printf "\e]PBffb86c"       # bright-brown   #ffb86c
	printf "\e]PCcfa9ff"       # bright-blue    #cfa9ff
	printf "\e]PDff88e8"       # bright-magenta #ff88e8
	printf "\e]PE97e2ff"       # bright-cyan    #97e2ff
	printf "\e]PFffffff"       # bright-white   #ffffff

        clear
}

__tty_theme
