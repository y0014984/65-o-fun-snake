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

// Codepage 437 box drawings
.const boxDrawingsLightVertical     = $B3
.const boxDrawingsLightDownAndLeft  = $BF
.const boxDrawingsLightUpAndRight   = $C0
.const boxDrawingsLightHorizontal   = $C4
.const boxDrawingsLightUpAndLeft    = $D9
.const boxDrawingsLightDownAndRight = $DA

// ========================================

// ASCII control characters
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

.const tileHeadRight        = $E0
.const tileHeadDown         = $E1
.const tileHeadLeft         = $E2
.const tileHeadUp           = $E3

.const tileRightLeft        = $E4
.const tileDownUp           = $E5

.const tileLeftUp           = $E6
.const tileUpRight          = $E7
.const tileRightDown        = $E8
.const tileDownLeft         = $E9

.const tileTailRight        = $EA
.const tileTailDown         = $EB
.const tileTailLeft         = $EC
.const tileTailUp           = $ED

// ========================================