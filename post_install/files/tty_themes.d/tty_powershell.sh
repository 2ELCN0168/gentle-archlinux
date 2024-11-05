__tty_theme() {

        [ "$TERM" = 'linux' ] || return # Only run in a TTY

	printf "\e]P0052454"       # black          #052454
	printf "\e]P17e0008"       # red            #7e0008
	printf "\e]P2098003"       # green          #098003
	printf "\e]P3c4a000"       # brown          #c4a000
	printf "\e]P4010083"       # blue           #010083
	printf "\e]P5d33682"       # magenta        #d33682
	printf "\e]P60e807f"       # cyan           #0e807f
	printf "\e]P7c1c2c3"       # white          #c1c2c3
	printf "\e]P8000000"       # bright-black   #000000
	printf "\e]P9ef2929"       # bright-red     #ef2929
	printf "\e]PA1cfe3c"       # bright-green   #1cfe3c
	printf "\e]PBfefe45"       # bright-brown   #fefe45
	printf "\e]PC268ad2"       # bright-blue    #268ad2
	printf "\e]PDfe13fa"       # bright-magenta #fe13fa
	printf "\e]PE29fffe"       # bright-cyan    #29fffe
	printf "\e]PF7f7c7f"       # bright-white   #7f7c7f

        clear
}

__tty_theme
