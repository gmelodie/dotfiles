#ifndef CONFIG_H
#define CONFIG_H

// String used to delimit block outputs in the status.
#define DELIMITER " | "

// Maximum number of Unicode characters that a block can output.
#define MAX_BLOCK_OUTPUT_LENGTH 45

// Control whether blocks are clickable.
#define CLICKABLE_BLOCKS 1

// Control whether a leading delimiter should be prepended to the status.
#define LEADING_DELIMITER 0

// Control whether a trailing delimiter should be appended to the status.
#define TRAILING_DELIMITER 0

// Define blocks for the status feed as X(icon, cmd, interval, signal).
#define BLOCKS(X) \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-clock", 10, 1)  \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-memory", 10, 14) \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-forecast", 18000, 5) \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-nettraf", 3, 16)  \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-volume", 0, 10)   \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-internet", 5, 4)  \
    X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-battery", 5, 3) 
    /* X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-cpu", 10, 18) */
    /* X("", "/home/gmelodie/dotfiles/scripts/blocks/sb-iplocate", 0, 27) */

#endif  // CONFIG_H
