# kwm

# toggle kwm
toggle_kwm () {
	if pgrep kwm > /dev/null; then
		brew services stop kwm
	else
		brew services start kwm
	fi
}

alias kwm=toggle_kwm