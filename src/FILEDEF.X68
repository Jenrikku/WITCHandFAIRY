; ==============================================================================
; EXTERNAL FILE PATH DEFINITION
; ==============================================================================

; --- FILE PATHS ---------------------------------------------------------------

BTMPL1      DC.B    'BTM/PL1.BTM', 0
BTMPL2      DC.B    'BTM/PL2.BTM', 0

BTMLVL0     DC.B    'BTM/', 0               ; INTRO
BTMLVL1     DC.B    'BTM/LVL1MAP.BTM', 0    ; MEADOW
BTMLVL2     DC.B    'BTM/LVL2MAP.BTM', 0    ; LAKE
BTMLVL3     DC.B    'BTM/', 0               ; SNOWY FOREST
BTMLVL4     DC.B    'BTM/', 0               ; VOLCANO
BTMLVL5     DC.B    'BTM/', 0               ; DESERT
BTMLVL6     DC.B    'BTM/', 0               ; WIN

BTMLV1E1    DC.B    'BTM/BUTTERFLY.BTM',0
BTMLV1E2    DC.B    'BTM/RABBIT.BTM',0
BTMLV2E1    DC.B    'BTM/CROCODILE.BTM',0
BTMLV2E2    DC.B    'BTM/',0
BTMLV3E1    DC.B    'BTM/TRUNK.BTM',0
BTMLV3E2    DC.B    'BTM/',0
BTMLV4E1    DC.B    'BTM/DRAGON.BTM',0
BTMLV4E2    DC.B    'BTM/',0
BTMLV5E1    DC.B    'BTM/CACTUS.BTM',0
BTMLV5E2    DC.B    'BTM/',0

            DC.W    0

; --- LEVEL JUMP TABLE ---------------------------------------------------------

LVLLIST     DC.L    BTMLVL0
            DC.L    BTMLVL1
            DC.L    BTMLVL2
            DC.L    BTMLVL3
            DC.L    BTMLVL4
            DC.L    BTMLVL5
            DC.L    BTMLVL6

; --- ENEMY JUMP TABLE ---------------------------------------------------------

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
