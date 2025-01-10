// ========================================

#importonce

// ========================================

#import "../labels.asm"
#import "../constants.asm"
#import "../macros.asm"

// ========================================

    jsr main

// ========================================

#import "tiles.asm"

// ========================================

direction: .byte $00
prevDirection: .byte $00
lastPosX: .byte $00
lastPosY: .byte $00
prevFrameCounter: .byte $00
speed: .byte $10
speedCounter: .byte $00

main:
    lda #$00
    jsr fillScreen
    
    jsr drawGameBorder

    jsr importTiles

    lda #$40
    sta screenMemStart

    lda #round(screenWidth/2)
    sta curPosX
    lda #round(screenHeight/2)
    sta curPosY

    lda #tileHeadRight
    jsr printChar

!gameLoop:
    lda frameCounter
    sta prevFrameCounter

    jsr getCharFromBuf
    cmp #ctrlArrowRight
    beq !right+
    cmp #ctrlArrowDown
    beq !down+
    cmp #ctrlArrowLeft
    beq !left+
    cmp #ctrlArrowUp
    beq !up+
    jmp !checkMove+

!right:
    lda #dirRight
    jmp !setDirection+
!down:
    lda #dirDown
    jmp !setDirection+
!left:
    lda #dirLeft
    jmp !setDirection+
!up:
    lda #dirUp
    jmp !setDirection+

!setDirection:
    sta direction

!checkMove:
    lda speedCounter
    cmp speed
    beq !move+
    inc speedCounter
    jmp !waitNextFrame+

!move:
    lda #0
    sta speedCounter

    lda curPosX
    sta lastPosX
    lda curPosY
    sta lastPosY

    lda direction
    cmp #dirRight
    beq !moveRight+
    cmp #dirDown
    beq !moveDown+
    cmp #dirLeft
    beq !moveLeft+
    cmp #dirUp
    beq !moveUp+

!moveRight:
    inc curPosX
    lda #tileHeadRight
    jmp !drawSnake+
!moveDown:
    inc curPosY
    lda #tileHeadDown
    jmp !drawSnake+
!moveLeft:
    dec curPosX
    lda #tileHeadLeft
    jmp !drawSnake+
!moveUp:
    dec curPosY
    lda #tileHeadUp
    jmp !drawSnake+

!drawSnake:
    jsr printChar

!drawPrevTile:
    lda curPosX
    pha
    lda curPosY
    pha

    lda lastPosX
    sta curPosX
    lda lastPosY
    sta curPosY

    lda prevDirection
    cmp direction
    beq !keepDir+
    cmp #dirRight
    beq !fromRight+
    cmp #dirDown
    beq !fromDown+
    cmp #dirLeft
    beq !fromLeft+
    cmp #dirUp
    beq !fromUp+

!keepDir:
    lda direction
    cmp #dirRight
    beq !rightLeft+
    cmp #dirDown
    beq !downUp+
    cmp #dirLeft
    beq !rightLeft+
    cmp #dirUp
    beq !downUp+

!rightLeft:
    lda #tileRightLeft
    jmp !drawPrev+

!downUp:
    lda #tileDownUp
    jmp !drawPrev+

!fromRight:
    lda direction
    cmp #dirDown
    beq !fromRightToDown+
    cmp #dirUp
    beq !fromRightToUp+

!fromDown:
    lda direction
    cmp #dirLeft
    beq !fromDownToLeft+
    cmp #dirRight
    beq !fromDownToRight+

!fromLeft:
    lda direction
    cmp #dirDown
    beq !fromLeftToDown+
    cmp #dirUp
    beq !fromLeftToUp+

!fromUp:
    lda direction
    cmp #dirLeft
    beq !fromUpToLeft+
    cmp #dirRight
    beq !fromUpToRight+

!fromRightToDown:
    lda #tileDownLeft
    jmp !drawPrev+

!fromRightToUp:
    lda #tileLeftUp
    jmp !drawPrev+

!fromDownToLeft:
    lda #tileLeftUp
    jmp !drawPrev+

!fromDownToRight:
    lda #tileUpRight
    jmp !drawPrev+

!fromLeftToDown:
    lda #tileRightDown
    jmp !drawPrev+

!fromLeftToUp:
    lda #tileUpRight
    jmp !drawPrev+

!fromUpToLeft:
    lda #tileDownLeft
    jmp !drawPrev+

!fromUpToRight:
    lda #tileRightDown
    jmp !drawPrev+

!drawPrev:
    jsr printChar

    pla
    sta curPosY
    pla
    sta curPosX

    lda direction
    sta prevDirection

!waitNextFrame:
    lda frameCounter
    cmp prevFrameCounter
    bne !waitNextFrameEnd+
    jmp !waitNextFrame-
!waitNextFrameEnd:

    jmp !gameLoop-

// ========================================

drawGameBorder:
    // top and bottom border
    lda #boxDrawingsLightHorizontal
    ldx #1
!loop:
    cpx #screenWidth-1
    beq !loopEnd+
    sta screenMemStart,x
    sta screenMemStart+((screenHeight-1) * screenWidth),x
    inx
    jmp !loop-
!loopEnd:

    // left and right border
    copyLabelToWord(screenMemStart, zpVar1);

    addByteToWord(screenWidth, zpVar1);

    ldx #0
!loop:
    cpx #screenHeight-2
    beq !loopEnd+
    lda #boxDrawingsLightVertical
    ldy #0
    sta (zpVar1),y
    ldy #screenWidth-1
    sta (zpVar1),y
    addByteToWord(screenWidth, zpVar1);
    inx
    jmp !loop-
!loopEnd:

    // corners
    lda #boxDrawingsLightDownAndRight
    sta screenMemStart
    lda #boxDrawingsLightDownAndLeft
    sta screenMemStart+screenWidth-1
    lda #boxDrawingsLightUpAndRight
    sta screenMemStart+(screenWidth*(screenHeight-1))
    lda #boxDrawingsLightUpAndLeft
    sta screenMemStart+(screenWidth*screenHeight)-1

!return:
    rts

// ========================================