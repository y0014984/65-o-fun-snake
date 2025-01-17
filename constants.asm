// ========================================

#importonce 

// ========================================

.const FALSE                = $00
.const TRUE                 = $FF

// ========================================

.const screenWidth          = 40            // 40 chars width * 8 = 320px
.const screenHeight         = 30            // 30 chars height * 8 = 240px

// ========================================

// Codepage 437 printable characters
.const charAtSign           = $40
.const charSpace            = $20

// Codepage 437 box drawings
.const boxDrawingsLightVertical             = $B3
.const boxDrawingsLightVerticalAndLeft      = $B4
.const boxDrawingsLightDownAndLeft          = $BF
.const boxDrawingsLightUpAndRight           = $C0
.const boxDrawingsLightUpAndHorizontal      = $C1
.const boxDrawingsLightDownAndHorizontal    = $C2
.const boxDrawingsLightVerticalAndRight     = $C3
.const boxDrawingsLightHorizontal           = $C4
.const boxDrawingsLightUpAndLeft            = $D9
.const boxDrawingsLightDownAndRight         = $DA

// ========================================

// ASCII control characters
.const ctrlEscape           = $1B
.const ctrlArrowLeft        = $11           // reassignment of device control 1
.const ctrlArrowRight       = $12           // reassignment of device control 2
.const ctrlArrowUp          = $13           // reassignment of device control 3
.const ctrlArrowDown        = $14           // reassignment of device control 4

// ========================================

// Game constants
.const dirRight             = $00
.const dirDown              = $40
.const dirLeft              = $80
.const dirUp                = $C0

.const tileEmpty            = $00

.const tileHeadRight        = $01
.const tileHeadDown         = $02
.const tileHeadLeft         = $03
.const tileHeadUp           = $04

.const tileRightLeft        = $05
.const tileDownUp           = $06

.const tileLeftUp           = $07
.const tileUpRight          = $08
.const tileRightDown        = $09
.const tileDownLeft         = $0A

.const tileTailRight        = $0B
.const tileTailDown         = $0C
.const tileTailLeft         = $0D
.const tileTailUp           = $0E

.const tileMouse            = $0F

// ========================================