//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"",	"/home/gmelodie/dotfiles/scripts/blocks/sb-clock",	60,	1},
	{"",	"/home/gmelodie/dotfiles/scripts/blocks/sb-memory",	10,	14},
	//{"",	"/home/gmelodie/dotfiles/scripts/blocks/sb-cpu",		10,	18},
	{"",	"/home/gmelodie/dotfiles/scripts/blocks/sb-forecast",	18000,	5},
	{"",	"/home/gmelodie/dotfiles/scripts/blocks/sb-nettraf",	3, 16},
	{"",	"/home/gmelodie/dotfiles/scripts/blocks/sb-volume",	0,	10},
	{"",	"/home/gmelodie/dotfiles/scripts/blocks/sb-internet",	5,	4},
	{"",	"/home/gmelodie/dotfiles/scripts/blocks/sb-battery",	5,	3},
	/* {"",	"/home/gmelodie/dotfiles/scripts/blocks/sb-iplocate", 0,	27}, */
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = "|";
static int delimLen = 2;

// Have dwmblocks automatically recompile and run when you edit this file in
// vim with the following line in your vimrc/init.vim:

// autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }
