__tty_theme() {

        [ "$TERM" = 'linux' ] || return # Only run in a TTY

	printf "\e]P0041412"       # black          #041412
	printf "\e]P126de9a"       # red            #26de9a
	printf "\e]P226de9a"       # green          #26de9a
	printf "\e]P326de9a"       # brown          #26de9a
	printf "\e]P426de9a"       # blue           #26de9a
	printf "\e]P526de9a"       # magenta        #26de9a
	printf "\e]P626de9a"       # cyan           #26de9a
	printf "\e]P726de9a"       # white          #26de9a
	printf "\e]P8041412"       # bright-black   #041412
	printf "\e]P926de9a"       # bright-red     #26de9a
	printf "\e]PA26de9a"       # bright-green   #26de9a
	printf "\e]PB26de9a"       # bright-brown   #26de9a
	printf "\e]PC26de9a"       # bright-blue    #26de9a
	printf "\e]PD26de9a"       # bright-magenta #26de9a
	printf "\e]PE26de9a"       # bright-cyan    #26de9a
	printf "\e]PF26de9a"       # bright-white   #26de9a

        clear
}

__tty_theme
