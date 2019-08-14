os=$(uname)

die () { $@; exit 1; }

std_paste () {
	case "$os" in
		Darwin) pbpaste ;;
		*) die "Err: os $os not implemented yet" ;;
	esac
}

#paste_clipboard

