// ========================================

#importonce 

// ========================================

.label snakeStart           = $1000

// ========================================

// BIOS routines, labels, constants, registers

.import source "bios.sym"

// ========================================

// Zeropage variables

.label zpVar1               = $00

// ========================================

// Registers

.label frameCounter         = $0220

.label minRandom            = $0221
.label maxRandom            = $0222
.label randomValue          = $0223

.label waveformDuration     = $0224
.label startStopFrequency   = $0225

// ========================================