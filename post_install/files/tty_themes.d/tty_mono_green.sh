__tty_theme() {

        [ "$TERM" = 'linux' ] || return # Only run in a TTY

	printf "\e]P0031f1a"       # black          #031f1a
	printf "\e]P183cdb1"       # red            #83cdb1
	printf "\e]P283cdb1"       # green          #83cdb1
	printf "\e]P383cdb1"       # brown          #83cdb1
	printf "\e]P483cdb1"       # blue           #83cdb1
	printf "\e]P583cdb1"       # magenta        #83cdb1
	printf "\e]P683cdb1"       # cyan           #83cdb1
	printf "\e]P783cdb1"       # white          #83cdb1
	printf "\e]P8031f1a"       # bright-black   #031f1a
	printf "\e]P983cdb1"       # bright-red     #83cdb1
	printf "\e]PA83cdb1"       # bright-green   #83cdb1
	printf "\e]PB83cdb1"       # bright-brown   #83cdb1
	printf "\e]PC83cdb1"       # bright-blue    #83cdb1
	printf "\e]PD83cdb1"       # bright-magenta #83cdb1
	printf "\e]PE83cdb1"       # bright-cyan    #83cdb1
	printf "\e]PF83cdb1"       # bright-white   #83cdb1

        clear
}

__tty_theme
