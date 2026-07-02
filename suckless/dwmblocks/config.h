#ifndef CONFIG_H
#define CONFIG_H

// String used to delimit block outputs in the status.
#define DELIMITER " ^c#bdae93^·^d^ "

// Maximum number of Unicode characters that a block can output.
// Room for status2d ^c#rrggbb^ color escapes emitted by the sb-* scripts.
#define MAX_BLOCK_OUTPUT_LENGTH 64

// Control whether blocks are clickable.
#define CLICKABLE_BLOCKS 1

// Control whether a leading delimiter should be prepended to the status.
#define LEADING_DELIMITER 0

// Control whether a trailing delimiter should be appended to the status.
#define TRAILING_DELIMITER 0

// Define blocks for the status feed as X(icon, cmd, interval, signal).
// Icons and their colors are emitted by the scripts themselves via status2d
// escape codes, so the icon field is left empty here.
#define BLOCKS(X) \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-cpu",   2,  0) \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-mem",   2,  0) \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-disk", 60,  0) \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-vol",   0, 11) \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-date", 30,  0) \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-battery", 30, 12)

#endif  // CONFIG_H
