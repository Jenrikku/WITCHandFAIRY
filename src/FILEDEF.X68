; ==============================================================================
; EXTERNAL FILE PATH DEFINITION
; ==============================================================================

; --- FILE PATHS ---------------------------------------------------------------

BTMPL1      DC.B    'BTM/PL1.BTM', 0
BTMPL2      DC.B    'BTM/PL2.BTM', 0

BTMLVL0     DC.B    'BTM/', 0               ; INTRO
BTMLVL1     DC.B    'BTM/LVL1MAP.BTM', 0    ; MEADOW
BTMLVL2     DC.B    'BTM/', 0               ; LAKE
BTMLVL3     DC.B    'BTM/', 0               ; SNOWY FOREST
BTMLVL4     DC.B    'BTM/', 0               ; VOLCANO
BTMLVL5     DC.B    'BTM/', 0               ; DESERT
BTMLVL6     DC.B    'BTM/', 0               ; WIN

            DC.W    0

; --- LEVEL JUMP TABLE ---------------------------------------------------------

LVLLIST     DC.L    BTMLVL0
            DC.L    BTMLVL1
            DC.L    BTMLVL2
            DC.L    BTMLVL3
            DC.L    BTMLVL4
            DC.L    BTMLVL5
            DC.L    BTMLVL6
