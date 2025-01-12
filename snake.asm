// Kick Assembler v5.25

.encoding "ascii"

// ========================================

/*
    The snake starts with a body of 6 elements.
    The first element is the head and the last
    element is the tail.
    The snake moves with a specific speed in 
    it's current direction. The player can 
    change the direction with the arrow keys.
    If the snake collides with itself or the 
    outer borders the game is over. 
    If the snake collides with (eats) the 
    randomly spawning items (mice, apples) 
    then the snake will grow in length each 
    time by 4 elements.
    For each consumed item the player will 
    earn 1 point.
    In a highscore list the best results are
    stored. The highscore list can be accessed
    by pressing the F1 key. (Space to continue)
    The player can leave the game by pressing
    the Escape key.

    TODOS:
    - add snake to computer fs (add 'load' command)
    - Start screen
    - High score
    - High score screen
    - Sound
    - alternating body parts
    - keyscan buffer hold a lot of keypresses

    Play Area = 38 x 26 = 988 fields
    Initial Length = 6
    Grow per Point = 4
    (988 - 6) / 4 = 245 (Max Points) 
*/

#import "labels.asm"
#import "constants.asm"
#import "macros.asm"

// ========================================

.segmentdef ZeroPage [start=$00, virtual]
.segmentdef Stack [start=$0100, virtual]
.segmentdef Registers [start=$0200, virtual]
.segmentdef Buffers [start=$0300, virtual]
.segmentdef ScreenMem [start=screenMemStart, virtual]
.segmentdef Snake [start=snakeStart, outPrg="snake.prg"]
.segmentdef BIOS [start=$D000, virtual]

// ========================================

.segment ZeroPage

.fill 256, $00

// ========================================

.segment Stack

.fill 256, $00

// ========================================

.segment Registers

.fill 256, $00

// ========================================

.segment Buffers

.fill 256, $00

// ========================================

.segment ScreenMem

.fill screenWidth*screenHeight, $00

// ========================================

.segment Snake

#import "lib/main.asm"

// ========================================

.segment BIOS

.fill $10000-$D000, $00

// ========================================