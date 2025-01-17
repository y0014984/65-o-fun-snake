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

.label getCharOnCurPos      = $DD44
.label fillScreen           = $DDD5
.label calcCurPos           = $DBD6
.label printChar            = $DC05
.label printString          = $DC0F

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

.label waveformDuration     = $0224
.label startStopFrequency   = $0225

.label tileSetAddr          = $022F         // WORD $022F + §0230

// ========================================