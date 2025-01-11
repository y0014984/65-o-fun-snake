// ========================================

#importonce 

// ========================================

.label screenMemStart       = $0400
.label snakeStart           = $1000
.label fontStart            = $F400

// ========================================

.label sourceAddr           = $F8           // WORD $F8 + $F9
.label destinationAddr      = $FA           // WORD $FA + $FB

// ========================================

// BIOS variables

.label curPosX              = $0340
.label curPosY              = $0341

.label num8Digits           = $D705

// ========================================

// BIOS routines (need update after BIOS change)

.label getCharFromBuf       = $D65B
.label print8               = $D6BF

.label getCharOnCurPos      = $DCF9
.label fillScreen           = $DD8A
.label calcCurPos           = $DB8B
.label printChar            = $DBBA
.label printString          = $DBC4

// ========================================

// Zeropage variables

.label zpVar1               = $00

// ========================================

// BIOS Zeropage variables

.label cursor               = $FE           // WORD $FE + $FF = current pos in screen mem

// ========================================

// Registers

.label frameCounter         = $0220

.label minRandom            = $0221
.label maxRandom            = $0222
.label randomValue          = $0223

// ========================================