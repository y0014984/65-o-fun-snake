// ========================================

#importonce 

// ========================================

#import "../labels.asm"
#import "../constants.asm"
#import "../macros.asm"

// ========================================

setTileSet:
    lda #<tileSet
    sta tileSetAddr
    lda #>tileSet
    sta tileSetAddr+1

!return:
    rts

// ========================================

resetTileSet:
    lda #<fontStart
    sta tileSetAddr
    lda #>fontStart
    sta tileSetAddr+1

!return:
    rts

// ========================================

tileSet:

// $00 empty
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000
.byte %00000000

// $01 headRight
.byte %01110000
.byte %11111100
.byte %11101110
.byte %11111100
.byte %11111100
.byte %11101110
.byte %11111100
.byte %01110000

// $02 headDown
.byte %01111110
.byte %11111111
.byte %11111111
.byte %11011011
.byte %01111110
.byte %01111110
.byte %00100100
.byte %00000000

// $03 headLeft
.byte %00001110
.byte %00111111
.byte %01110111
.byte %00111111
.byte %00111111
.byte %01110111
.byte %00111111
.byte %00001110

// $03 headUp
.byte %00000000
.byte %00100100
.byte %01111110
.byte %01111110
.byte %11011011
.byte %11111111
.byte %11111111
.byte %01111110

// $05 rightLeft
.byte %00000000
.byte %00000000
.byte %11111111
.byte %11111001
.byte %10011111
.byte %11111111
.byte %00000000
.byte %00000000

// $06 downUp
.byte %00111100
.byte %00101100
.byte %00101100
.byte %00111100
.byte %00111100
.byte %00110100
.byte %00110100
.byte %00111100

// $07 leftUp
.byte %00111100
.byte %01101100
.byte %11101100
.byte %11111100
.byte %10011100
.byte %11111000
.byte %00000000
.byte %00000000

// $08 upRight
.byte %00111100
.byte %00101110
.byte %00101111
.byte %00111001
.byte %00111111
.byte %00011111
.byte %00000000
.byte %00000000

// $09 rightDown
.byte %00000000
.byte %00000000
.byte %00011111
.byte %00111001
.byte %00111111
.byte %00110111
.byte %00110110
.byte %00111100

// $0A downLeft
.byte %00000000
.byte %00000000
.byte %11111000
.byte %11111100
.byte %10011100
.byte %11110100
.byte %01110100
.byte %00111100

// $0B tailRight
.byte %00000000
.byte %00000000
.byte %11110000
.byte %11110101
.byte %10010101
.byte %11110000
.byte %00000000
.byte %00000000

// $0C tailDown
.byte %00111100
.byte %00101100
.byte %00101100
.byte %00111100
.byte %00000000
.byte %00011000
.byte %00000000
.byte %00011000

// $0D tailLeft
.byte %00000000
.byte %00000000
.byte %00001111
.byte %10101001
.byte %10101111
.byte %00001111
.byte %00000000
.byte %00000000

// $0E tailUp
.byte %00011000
.byte %00000000
.byte %00011000
.byte %00000000
.byte %00111100
.byte %00110100
.byte %00110100
.byte %00111100

// $0F mouse
.byte %00000000
.byte %10000000
.byte %01000100
.byte %01011100
.byte %00111110
.byte %00010100
.byte %00000000
.byte %00000000

// ========================================