; ==============================================================================
; GAME VARIABLES
; ==============================================================================

MODEASY     DC.B    0                       ; SET TO ENABLE EASY MODE
            DS.W    0

; --- WITCH RELATED VARIABLES --------------------------------------------------

PL1EIPOS    DS.L    1                       ; WITCH ENTITY INFORMATION ADDRESS
PL1POSX     DS.W    1                       ; WITCH X COORDINATE
PL1POSY     DS.W    1                       ; WITCH Y COORDINATE
PL1VELXY    DS.W    1                       ; WITCH VELOCITY
PL1TILE     DS.B    1                       ; WITCH CURRENT TILE (SPRITE)

            DS.W    0

; --- FAIRY RELATED VARIABLES --------------------------------------------------

PL2EIPOS    DS.L    1                       ; FAIRY ENTITY INFORMATION ADDRESS
PL2POSX     DS.W    1                       ; FAIRY X COORDINATE
PL2POSY     DS.W    1                       ; FAIRY Y COORDINATE
PL2VELXY    DS.W    1                       ; FAIRY VELOCITY
PL2TILE     DS.B    1                       ; FAIRY CURRENT TILE (SPRITE)

; --- SHARED PLAYER VARIABLES --------------------------------------------------

PLYHP       DS.B    1                       ; WITCH AND FAIRY SHARED HEALTH
PLYMOVE     DS.B    1                       ; WHETHER THE PLAYER CAN MOVE

            DS.W    0

; --- ENEMY RELATED VARIABLES --------------------------------------------------

ENMEIPOS    DS.L    ENMMAXTP                ; ENEMIES ENTITY INFORMATION ADDRESS
ENMPOSX     DS.W    ENMMAXNO                ; ENEMIES X COORDINATES
ENMPOSY     DS.W    ENMMAXNO                ; ENEMIES Y COORDINATES
ENMVELXY    DS.W    ENMMAXNO                ; ENEMIES VELOCITIES
ENMTILE     DS.B    ENMMAXNO                ; ENEMIES CURRENT TILES (SPRITES)
ENMTYPE     DS.B    ENMMAXNO                ; ENEMIES TYPES (WHAT EI TO USE)
ENMHP       DS.B    ENMMAXNO                ; ENEMIES HEALTH POINTS

            DS.W    0

; --- LEVEL RELATED VARIABLES --------------------------------------------------

LVLEIPOS    DS.L    1                       ; MAP ENTITY INFORMATION ADDRESS
LVLINDEX    DS.B    1                       ; CURRENT LEVEL
LVLCHANG    DS.B    1                       ; SET WHEN THE LEVEL IS CHANGING

; --- TEXT VARIABLES -----------------------------------------------------------

TXTCONT     DC.B    'PRESS ENTER TO CONTINUE', 0
TXTTUT1     DC.B    'MOVE THE WITCH USING WASD', 0
TXTTUT2     DC.B    'MOVE THE FAIRY USING THE ARROW KEYS', 0
TXTTUT3     DC.B    'DODGE ENEMIES FOR SOME TIME', 0
TXTTUT4     DC.B    'AND YOU WILL BECOME INVINCIBLE', 0
TXTTUT5     DC.B    'CHASE THE ENEMIES ONCE THAT HAPPENS', 0
TXTTUT6     DC.B    'TO CLEAR THE LEVEL', 0
TXTNLVL     DC.B    'LEVEL ', 0

            DS.W    0

; --- TEXT POSITIONS -----------------------------------------------------------

TXTCONTP    DC.W    11*$100+15              ; PRESS ENTER TEXT POSITION
TXTTUT1P    DC.W    8*$100+3                ; TUTORIAL LINE 1 POSITION
TXTTUT2P    DC.W    8*$100+5                ; TUTORIAL LINE 2 POSITION
TXTTUT3P    DC.W    3*$100+8                ; TUTORIAL LINE 3 POSITION
TXTTUT4P    DC.W    3*$100+9                ; TUTORIAL LINE 4 POSITION
TXTTUT5P    DC.W    3*$100+11               ; TUTORIAL LINE 5 POSITION
TXTTUT6P    DC.W    3*$100+12               ; TUTORIAL LINE 6 POSITION
TXTNLVLP    DC.W    13*$100+6               ; NEXT LEVEL TEXT POSITION

; --- TEXT JUMP LIST -----------------------------------------------------------

TXTLIST     DC.L    TXTCONT
            DC.L    TXTTUT1
            DC.L    TXTTUT2
            DC.L    TXTTUT3
            DC.L    TXTTUT4
            DC.L    TXTTUT5
            DC.L    TXTTUT6
            DC.L    TXTNLVL
