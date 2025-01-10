// ========================================

#importonce 

// ========================================

#import "../labels.asm"
#import "../constants.asm"
#import "../macros.asm"

// ========================================

importTiles:
    copyLabelToWord(tilesStart, sourceAddr);
    
    lda #<fontStart+($E0*8)
    sta destinationAddr
    lda #>fontStart+($E0*8)
    sta destinationAddr+1

    ldx #0
!loopTiles:
    cpx #14
    beq !return+

    ldy #0
!loopRows:
    cpy #8
    beq !loopRowsEnd+
    lda (sourceAddr),y
    sta (destinationAddr),y
    iny
    jmp !loopRows-
!loopRowsEnd:

    addByteToWord(8, sourceAddr);
    addByteToWord(8, destinationAddr);
    inx
    jmp !loopTiles-

!return:
    rts

// ========================================

tilesStart:

// $E0 headRight
.byte %01110000
.byte %11111100
.byte %11101110
.byte %11111100
.byte %11111100
.byte %11101110
.byte %11111100
.byte %01110000

// $E1 headDown
.byte %01111110
.byte %11111111
.byte %11111111
.byte %11011011
.byte %01111110
.byte %01111110
.byte %00100100
.byte %00000000

// $E2 headLeft
.byte %00001110
.byte %00111111
.byte %01110111
.byte %00111111
.byte %00111111
.byte %01110111
.byte %00111111
.byte %00001110

// $E3 headUp
.byte %00000000
.byte %00100100
.byte %01111110
.byte %01111110
.byte %11011011
.byte %11111111
.byte %11111111
.byte %01111110

// $E4 rightLeft
.byte %00000000
.byte %00000000
.byte %11111111
.byte %11111001
.byte %10011111
.byte %11111111
.byte %00000000
.byte %00000000

// $E5 downUp
.byte %00111100
.byte %00101100
.byte %00101100
.byte %00111100
.byte %00111100
.byte %00110100
.byte %00110100
.byte %00111100

// $E6 leftUp
.byte %00111100
.byte %01101100
.byte %11101100
.byte %11111100
.byte %10011100
.byte %11111000
.byte %00000000
.byte %00000000

// $E7 upRight
.byte %00111100
.byte %00101110
.byte %00101111
.byte %00111001
.byte %00111111
.byte %00011111
.byte %00000000
.byte %00000000

// $E8 rightDown
.byte %00000000
.byte %00000000
.byte %00011111
.byte %00111001
.byte %00111111
.byte %00110111
.byte %00110110
.byte %00111100

// $E9 downLeft
.byte %00000000
.byte %00000000
.byte %11111000
.byte %11111100
.byte %10011100
.byte %11110100
.byte %01110100
.byte %00111100

// $EA tailRight
.byte %00000000
.byte %00000000
.byte %11110000
.byte %11110101
.byte %10010101
.byte %11110000
.byte %00000000
.byte %00000000

// $EB tailDown
.byte %00111100
.byte %00101100
.byte %00101100
.byte %00111100
.byte %00000000
.byte %00011000
.byte %00000000
.byte %00011000

// $EC tailLeft
.byte %00000000
.byte %00000000
.byte %00001111
.byte %10101001
.byte %10101111
.byte %00001111
.byte %00000000
.byte %00000000

// $ED tailUp
.byte %00011000
.byte %00000000
.byte %00011000
.byte %00000000
.byte %00111100
.byte %00110100
.byte %00110100
.byte %00111100

// ========================================