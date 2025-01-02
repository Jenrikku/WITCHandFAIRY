; ==============================================================================
; EXTERNAL FILE PATH DEFINITION
; ==============================================================================

; --- FILE PATHS ---------------------------------------------------------------

BTMPL1      DC.B    'BTM/PL1.BTM', 0
BTMPL2      DC.B    'BTM/PL2.BTM', 0

BTMLVL1     DC.B    'BTM/LVL1MAP.BTM', 0    ; MEADOW
BTMLVL2     DC.B    'BTM/LVL2MAP.BTM', 0    ; LAKE
BTMLVL3     DC.B    'BTM/LVL3MAP.BTM', 0    ; SNOWY FOREST
BTMLVL4     DC.B    'BTM/LVL4MAP.BTM', 0    ; VOLCANO
BTMLVL5     DC.B    'BTM/LVL5MAP.BTM', 0    ; DESERT
BTMLVLS1    DC.B    'BTM/', 0               ; SPECIAL 1 : END
BTMLVLS2    DC.B    'BTM/LVLS2MAP.BTM', 0   ; SPECIAL 2 : TITLE
BTMLVLS3    DC.B    'BTM/', 0               ; SPECIAL 3 : GAME OVER

BTMLV1E1    DC.B    'BTM/BUTTERFLY.BTM', 0  ; LVL 1, ENEMY 1: BUTTERFLY
BTMLV1E2    DC.B    'BTM/RABBIT.BTM', 0     ; LVL 1, ENEMY 2: RABBIT
BTMLV2E1    DC.B    'BTM/CROCODILE.BTM', 0  ; LVL 2, ENEMY 1: CROCODILE
BTMLV2E2    DC.B    'BTM/SNAKE1.BTM', 0     ; LVL 2, ENEMY 2: WATER SNAKE
BTMLV3E1    DC.B    'BTM/TRUNK.BTM', 0      ; LVL 3, ENEMY 1: TRUNK
BTMLV3E2    DC.B    'BTM/FOX.BTM', 0        ; LVL 3, ENEMY 2: FOX
BTMLV4E1    DC.B    'BTM/DRAGON.BTM', 0     ; LVL 4, ENEMY 1: DRAGON
BTMLV4E2    DC.B    'BTM/SNAIL.BTM', 0      ; LVL 4, ENEMY 2: LAVA SNAIL
BTMLV5E1    DC.B    'BTM/CACTUS.BTM', 0     ; LVL 5, ENEMY 1: CACTUS
BTMLV5E2    DC.B    'BTM/SNAKE2.BTM', 0     ; LVL 5, ENEMY 2: SAND SNAKE

            DC.W    0

; --- LEVEL JUMP LIST ----------------------------------------------------------

LVLLIST     DC.L    BTMLVL1
            DC.L    BTMLVL2
            DC.L    BTMLVL3
            DC.L    BTMLVL4
            DC.L    BTMLVL5
            DC.L    BTMLVLS1
            DC.L    BTMLVLS2
            DC.L    BTMLVLS3

; --- ENEMY JUMP LIST ----------------------------------------------------------

ENMLIST     DC.L    BTMLV1E1
            DC.L    BTMLV1E2
            DC.L    BTMLV2E1
            DC.L    BTMLV2E2
            DC.L    BTMLV3E1
            DC.L    BTMLV3E2
            DC.L    BTMLV4E1
            DC.L    BTMLV4E2
            DC.L    BTMLV5E1
            DC.L    BTMLV5E2
