; ==============================================================================
; GAME VARIABLES
; ==============================================================================

; --- WITCH RELATED VARIABLES --------------------------------------------------

PL1EIPOS    DS.L    1                       ; WITCH ENTITY INFORMATION ADDRESS
PL1POSX     DC.W    30                      ; WITCH X COORDINATE
PL1POSY     DC.W    30                      ; WITCH Y COORDINATE
PL1VELXY    DS.W    1                       ; WITCH VELOCITY
PL1TILE     DC.B    3                       ; WITCH CURRENT TILE (SPRITE)
PL1HP       DS.B    1                       ; WITCH HEALTH POINTS

            DS.W    0

; --- FAIRY RELATED VARIABLES --------------------------------------------------

PL2EIPOS    DS.L    1                       ; FAIRY ENTITY INFORMATION ADDRESS
PL2POSX     DC.W    60                      ; FAIRY X COORDINATE
PL2POSY     DC.W    30                      ; FAIRY Y COORDINATE
PL2VELXY    DS.W    1                       ; FAIRY VELOCITY
PL2TILE     DC.B    3                       ; FAIRY CURRENT TILE (SPRITE)
PL2HP       DS.B    1                       ; FAIRY HEALTH POINTS

            DS.W    0

; --- ENEMY RELATED VARIABLES --------------------------------------------------

ENMPOSX     DS.W    ENMMAXNO                ; ENEMIES X COORDINATES
ENMPOSY     DS.W    ENMMAXNO                ; ENEMIES Y COORDINATES
ENMVELXY    DS.W    ENMMAXNO                ; ENEMIES VELOCITIES
ENMTILE     DS.B    ENMMAXNO                ; ENEMIES CURRENT TILES (SPRITES)
ENMHP       DS.B    ENMMAXNO                ; ENEMIES HEALTH POINTS

            DS.W    0

; --- LEVEL RELATED VARIABLES --------------------------------------------------

LVLEIPOS    DS.L    1                       ; MAP ENTITY INFORMATION ADDRESS
LVLINDEX    DC.B    0                       ; CURRENT LEVEL

; --- STORY PANEL RELATED VARIABLES --------------------------------------------

TXT1STRY    DC.B    'This is a temporary story for the witch.'
            DC.B    'This is a second paragraph.',0

TXT2STRY    DC.B    'This is a temporary story for the fairy.',0
            DC.B    'This is a second paragraph.',0

            DS.W    0
