// ========================================

#importonce 

// ========================================

#import "labels.asm"
#import "constants.asm"

// ========================================

.macro addByteToWord(byte, wordAddress) {
    lda wordAddress
    clc
    adc #byte
    sta wordAddress
    lda wordAddress+1
    adc #0
    sta wordAddress+1
}

// ========================================

.macro copyLabelToWord(label, wordAddress) {
    lda #<label
    sta wordAddress
    lda #>label
    sta wordAddress+1
}

// ========================================

.macro saveCurPosToStack() {
    lda terminal.curPosX
    pha
    lda terminal.curPosY
    pha
}

// ========================================
.macro loadCurPosFromStack() {
    pla 
    sta terminal.curPosY
    pla
    sta terminal.curPosX
}

// ========================================