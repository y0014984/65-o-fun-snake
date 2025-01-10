// Kick Assembler v5.25

.encoding "ascii"

// ========================================

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