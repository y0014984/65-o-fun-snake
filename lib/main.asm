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

// Game Constants

.const fps              = 60

.const borderWidth      = 1
.const borderHeight     = 1

.const startInfoAreaX   = 1
.const startInfoAreaY   = screenHeight-2
.const infoAreaWidth    = screenWidth-(2*borderWidth)
.const infoAreaHeight   = 1

.const startPlayAreaX   = 1
.const startPlayAreaY   = 1
.const playAreaWidth    = screenWidth-(2*borderWidth)
.const playAreaHeight   = screenHeight-(2*borderHeight)-infoAreaHeight-(1*borderHeight)

.const initSnakeLength  = 6                 // min 4; even numbers only

.const offsetScore      = 1                 // 3 digits; offset measured from start Info Area
.const offsetStrScore   = 5                 // offset measured from start Info Area
.const offsetMessage    = 13                // offset measured from start Info Area

.const speedBoost0      = 60
.const speedBoost1      = 35                // -25
.const speedBoost2      = 20                // -15
.const speedBoost3      = 10                // -10

// ========================================

// Game Variables

headDir:            .byte dirRight
headPosX:           .byte 0
headPosY:           .byte 0

prevHeadDir:        .byte dirRight
prevHeadPosX:       .byte 0
prevHeadPosY:       .byte 0

tailDir:            .byte dirRight
tailPosX:           .byte 0
tailPosY:           .byte 0

nextTailDir:        .byte dirRight
nextTailPosX:       .byte 0
nextTailPosY:       .byte 0

prevFrameCounter:   .byte 0

speed:              .byte speedBoost0       // move forward every X frames
speedCounter:       .byte 0

spawn:              .word 10*fps            // spawn collectable every 5 seconds
spawnCounter:       .word 0

grow:               .byte 4                 // grow 4 elements when consuming
growCounter:        .byte 0

collisionDetected:  .byte FALSE

score:              .byte 0
highScore:          .byte 0                 // won't be resetted upon restart

dirSetInFrame:      .byte FALSE

// ========================================

// Strings

strScore: .text @"Score\$00"
strHighScore: .text @"New High Score\$00"
strGameOver: .text @"Game Over - Press Space\$00"

// ========================================

main:
    jsr initGame
    jmp !gameLoop+

!gameOver:
    jsr gameOver
    jmp main

!gameLoop:
    lda collisionDetected
    cmp #TRUE
    beq !gameOver-

    lda frameCounter
    sta prevFrameCounter

    lda dirSetInFrame
    cmp #TRUE
    beq !skipKeyscan+

!keyscan:
    jsr getCharFromBuf
    cmp #ctrlArrowRight
    beq !right+
    cmp #ctrlArrowDown
    beq !down+
    cmp #ctrlArrowLeft
    beq !left+
    cmp #ctrlArrowUp
    beq !up+
    cmp #ctrlEscape
    beq !quitGame+
    jmp !checks+

!quitGame:
    rts

!right:
    lda headDir
    cmp #dirLeft
    beq !skipDirChange+
    lda #dirRight
    jmp !setHeadDir+
!down:
    lda headDir
    cmp #dirUp
    beq !skipDirChange+
    lda #dirDown
    jmp !setHeadDir+
!left:
    lda headDir
    cmp #dirRight
    beq !skipDirChange+
    lda #dirLeft
    jmp !setHeadDir+
!up:
    lda headDir
    cmp #dirDown
    beq !skipDirChange+
    lda #dirUp
    jmp !setHeadDir+

!setHeadDir:
    sta headDir
    lda #TRUE
    sta dirSetInFrame

!checks:
!skipKeyscan:
!skipDirChange:
!clearKeyscanBuffer:
    jsr getCharFromBuf
    cmp #$00
    bne !clearKeyscanBuffer-

!checkSpawn:
    lda spawnCounter+1
    cmp spawn+1
    beq !highByteEqual+
    jmp !incrSpawnCounter+
!highByteEqual:
    lda spawnCounter
    cmp spawn
    beq !spawn+
!incrSpawnCounter:
    addByteToWord(1, spawnCounter)
    jmp !checkMove+

!spawn:
    lda #0
    sta spawnCounter
    sta spawnCounter+1
    jsr spawnCollectable

!checkMove:
    lda speedCounter
    cmp speed
    beq !move+
    inc speedCounter
    jmp !waitNextFrame+

!move:
    jsr playBeep
    lda #FALSE
    sta dirSetInFrame
    lda #0
    sta speedCounter
    jsr moveHead
    lda growCounter
    cmp #0
    bne !grow+
    jsr moveTail
    jmp !waitNextFrame+

!grow:
    dec growCounter

!waitNextFrame:
    lda frameCounter
    cmp prevFrameCounter
    bne !waitNextFrameEnd+
    jmp !waitNextFrame-
!waitNextFrameEnd:

    jmp !gameLoop-

// ========================================

playBeep:
    lda #%00001010                          // sine + 100 ms
    sta waveformDuration
    lda #%10111000                          // frequency low byte
    sta startStopFrequency
    lda #%10000001                          // frequency high byte + start
    sta startStopFrequency+1

!return:
    rts

// ========================================

gameOver:
    lda #startInfoAreaX
    clc
    adc #offsetMessage
    sta curPosX
    lda #startInfoAreaY
    sta curPosY
!print:
    jsr resetTileSet
    ldx #<strGameOver
    ldy #>strGameOver
    jsr printString
    jsr setTileSet
!waitForKeypress:
    jsr getCharFromBuf
    cmp #ctrlEscape
    beq !return+
    cmp #charSpace
    bne !waitForKeypress-
!return:
    rts

// ========================================

drawTexts:
    lda #startInfoAreaX
    clc
    adc #offsetStrScore
    sta curPosX
    lda #startInfoAreaY
    sta curPosY
!print:
    jsr resetTileSet
    ldx #<strScore
    ldy #>strScore
    jsr printString
    jsr setTileSet
!return:
    rts

// ========================================

drawScore:
    jsr resetTileSet
    saveCurPosToStack()

    lda #startInfoAreaX
    sta curPosX
    lda #startInfoAreaY
    sta curPosY

    jsr calcCurPos

    lda score
    jsr print8

!copy:
    ldy #offsetScore+0
    lda num8Digits+0
    sta (cursor),y
    ldy #offsetScore+1
    lda num8Digits+1
    sta (cursor),y
    ldy #offsetScore+2
    lda num8Digits+2
    sta (cursor),y

!return:
    loadCurPosFromStack()
    jsr setTileSet
    rts

// ========================================

initGame:
    lda #$00
    jsr fillScreen
    
    jsr drawGameBorder

    jsr drawTexts

    lda #FALSE
    sta collisionDetected
    sta dirSetInFrame

    lda #speedBoost0
    sta speed

    // reset various variables
    lda #0
    sta prevFrameCounter
    sta score
    sta speedCounter
    sta spawnCounter
    sta spawnCounter+1
    sta growCounter

    jsr drawScore

    jsr setTileSet

    lda #round(screenWidth/2)-round(initSnakeLength/2)
    sta curPosX
    lda #round(screenHeight/2)
    sta curPosY
    sta prevHeadPosY
    sta headPosY
    sta tailPosY
    sta nextTailPosY

    lda #dirRight
    sta prevHeadDir
    sta headDir
    sta tailDir
    sta nextTailDir

    // tail
    lda #tileTailLeft
    jsr printChar
    lda curPosX
    sta tailPosX

    // next tail
    inc curPosX
    lda #tileRightLeft
    jsr printChar
    lda curPosX
    sta nextTailPosX

    .for (var i=0; i<initSnakeLength-3; i++) { 
        // body part
        inc curPosX
        lda #tileRightLeft
        jsr printChar
    }

    // head
    inc curPosX
    lda #tileHeadRight
    jsr printChar
    
    jsr spawnCollectable
    
!return:
    rts

// ========================================

spawnCollectable:
    saveCurPosToStack()

!randomize:
    lda #startPlayAreaX
    sta minRandom
    lda #startPlayAreaX+playAreaWidth
    sta maxRandom
    lda randomValue
    sta curPosX

    lda #startPlayAreaY
    sta minRandom
    lda #startPlayAreaY+playAreaHeight
    sta maxRandom
    lda randomValue
    sta curPosY

    jsr getCharOnCurPos
    cmp #$00                                // tile is already occupied; randomize again
    bne !randomize-

!drawCollectable:
    lda #tileMouse
    jsr printChar

!return:
    loadCurPosFromStack()
    rts

// ========================================

checkCollision:
    jsr getCharOnCurPos
    cmp #tileMouse
    beq !collectable+
    cmp #$00
    bne !collision+
    jmp !return+

!collectable:
    inc score
    lda score
    cmp highScore
    bcc !noHighScore+
    sta highScore
    saveCurPosToStack()
    lda #startInfoAreaX
    clc
    adc #offsetMessage
    sta curPosX
    lda #startInfoAreaY
    sta curPosY
    jsr resetTileSet
    ldx #<strHighScore
    ldy #>strHighScore
    jsr printString
    jsr setTileSet
    loadCurPosFromStack()
    lda score
!noHighScore:
    cmp #25
    beq !speedBoost1+
    cmp #50
    beq !speedBoost2+
    cmp #100
    beq !speedBoost3+
    jmp !draw+

!speedBoost1:
    lda #speedBoost1
    sta speed
    jmp !draw+
!speedBoost2:
    lda #speedBoost2
    sta speed
    jmp !draw+
!speedBoost3:
    lda #speedBoost3
    sta speed

!draw:
    jsr drawScore
    lda growCounter
    clc
    adc grow
    sta growCounter
    jmp !return+

!collision:
    lda #TRUE
    sta collisionDetected

!return:
    rts

// ========================================

moveHead:
    lda curPosX
    sta prevHeadPosX
    lda curPosY
    sta prevHeadPosY

    lda headDir
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
    jmp !checkCollision+
!moveDown:
    inc curPosY
    lda #tileHeadDown
    jmp !checkCollision+
!moveLeft:
    dec curPosX
    lda #tileHeadLeft
    jmp !checkCollision+
!moveUp:
    dec curPosY
    lda #tileHeadUp
    jmp !checkCollision+

!checkCollision:
    pha
    jsr checkCollision
    pla
!drawHead:
    jsr printChar

!drawPrevTile:
    saveCurPosToStack()

    lda prevHeadPosX
    sta curPosX
    lda prevHeadPosY
    sta curPosY

    lda prevHeadDir
    cmp headDir
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
    lda headDir
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
    lda headDir
    cmp #dirDown
    beq !fromRightToDown+
    cmp #dirUp
    beq !fromRightToUp+

!fromDown:
    lda headDir
    cmp #dirLeft
    beq !fromDownToLeft+
    cmp #dirRight
    beq !fromDownToRight+

!fromLeft:
    lda headDir
    cmp #dirDown
    beq !fromLeftToDown+
    cmp #dirUp
    beq !fromLeftToUp+

!fromUp:
    lda headDir
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

    loadCurPosFromStack()

    lda headDir
    sta prevHeadDir

!return:
    rts

// ========================================

moveTail:
    saveCurPosToStack()

    // clear last tail position
    lda tailPosX
    sta curPosX
    lda tailPosY
    sta curPosY
    lda #$00
    jsr printChar
    
    // draw new tail on next pos
    lda nextTailPosX
    sta tailPosX
    sta curPosX
    lda nextTailPosY
    sta curPosY
    sta tailPosY
    lda nextTailDir
    sta tailDir

    lda nextTailDir
    cmp #dirRight
    beq !right+
    cmp #dirDown
    beq !down+
    cmp #dirLeft
    beq !left+
    cmp #dirUp
    beq !up+

!right:
    inc nextTailPosX
    lda #tileTailLeft
    jmp !drawTail+
!down:
    inc nextTailPosY
    lda #tileTailUp
    jmp !drawTail+
!left:
    dec nextTailPosX
    lda #tileTailRight
    jmp !drawTail+
!up:
    dec nextTailPosY
    lda #tileTailDown
    jmp !drawTail+

!drawTail:
    jsr printChar

!getNewNextTailDir:
    lda nextTailPosX
    sta curPosX
    lda nextTailPosY
    sta curPosY

    jsr getCharOnCurPos
    cmp #tileRightLeft
    beq !rightLeft+
    cmp #tileDownUp
    beq !downUp+
    cmp #tileLeftUp
    beq !leftUp+
    cmp #tileUpRight
    beq !upRight+
    cmp #tileRightDown
    beq !rightDown+
    cmp #tileDownLeft
    beq !downLeft+

!rightLeft:
    lda tailDir
    cmp #dirRight
    beq !right+
    cmp #dirLeft
    beq !left+
!downUp:
    lda tailDir
    cmp #dirDown
    beq !down+
    cmp #dirUp
    beq !up+
!leftUp:
    lda tailDir
    cmp #dirRight
    beq !up+
    cmp #dirDown
    beq !left+
!upRight:
    lda tailDir
    cmp #dirDown
    beq !right+
    cmp #dirLeft
    beq !up+
!rightDown:
    lda tailDir
    cmp #dirLeft
    beq !down+
    cmp #dirUp
    beq !right+
!downLeft:
    lda tailDir
    cmp #dirUp
    beq !left+
    cmp #dirRight
    beq !down+

!right:
    lda #dirRight
    jmp !storeNextTailDir+
!left:
    lda #dirLeft
    jmp !storeNextTailDir+
!down:
    lda #dirDown
    jmp !storeNextTailDir+
!up:
    lda #dirUp
    jmp !storeNextTailDir+

!storeNextTailDir:
    sta nextTailDir

!return:
    loadCurPosFromStack()
    rts

// ========================================

drawGameBorder:
    // top, bottom and delimiter border
    lda #boxDrawingsLightHorizontal
    ldx #1
!loop:
    cpx #screenWidth-1
    beq !loopEnd+
    sta screenMemStart,x
    sta screenMemStart+((screenHeight-borderHeight) * screenWidth),x
    sta screenMemStart+((screenHeight-borderHeight-infoAreaHeight-borderHeight) * screenWidth),x
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
    sta screenMemStart+(screenWidth*(screenHeight-borderHeight))
    lda #boxDrawingsLightUpAndLeft
    sta screenMemStart+(screenWidth*screenHeight)-1

    // delimiter corners
    lda #boxDrawingsLightVerticalAndRight
    sta screenMemStart+(screenWidth*(screenHeight-borderHeight-infoAreaHeight-borderHeight))
    lda #boxDrawingsLightVerticalAndLeft
    sta screenMemStart+(screenWidth*(screenHeight-borderHeight-infoAreaHeight))-1

    // info area delimiters
    lda #boxDrawingsLightVertical
    sta screenMemStart+(screenWidth*(screenHeight-borderHeight-infoAreaHeight))+offsetMessage-1
    lda #boxDrawingsLightDownAndHorizontal
    sta screenMemStart+(screenWidth*(screenHeight-borderHeight-infoAreaHeight))+offsetMessage-1-screenWidth
    lda #boxDrawingsLightUpAndHorizontal
    sta screenMemStart+(screenWidth*(screenHeight-borderHeight-infoAreaHeight))+offsetMessage-1+screenWidth
    
!return:
    rts

// ========================================