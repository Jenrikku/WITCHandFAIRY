; ==============================================================================
; ENEMY SPAWN LOCATIONS
; ==============================================================================
; EACH LEVEL HAS ITS OWN SPAWN LISTS WHERE LVLXSPWD IS THE DELAY IN SECONDS
; UNTIL THE ENEMY SPAWNS, LVLXSPWT IS THE ENEMY TYPE, LVLXSPWM IS THE MOVEMENT
; MODE EACH ENEMY USES AND LVLXSPWP IS THE POSITION X (HIGH W) AND Y (LOW W).
; ONLY THE FIRST 10 SECONDS ARE SPECIFIED AND ENEMIES ARE REPEATED FROM THERE.
; ------------------------------------------------------------------------------

LVL1SPWD    DC.B    1, 2, 2, 3, 4, 4, 5, 6, 7, 8, 8, 8, 9, 9, 10, 10

LVL1SPWT    DC.B    0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1

LVL1SPWM    DC.B    0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1
            DS.W    0

LVL1SPWP    DC.W    -16, 500
            DC.W    -16, 300
            DC.W    480, 600
            DC.W    480, 400
            DC.W    -16, 500
            DC.W    -16, 300
            DC.W    480, 100
            DC.W    -16, 200
            DC.W    480, 600
            DC.W    480, 300
            DC.W    480, 100
            DC.W    -16, 100
            DC.W    -16, 300
            DC.W    -16, 600
            DC.W    480, 100
            DC.W    480, 600

; --- LEVEL SPAWN JUMP LISTS ---------------------------------------------------

LVLSPWD     DC.L    LVL1SPWD

LVLSPWT     DC.L    LVL1SPWT

LVLSPWM     DC.L    LVL1SPWM

LVLSPWP     DC.L    LVL1SPWP

; --- LEVEL SPAWN COUNT (AMOUNT) -----------------------------------------------

LVLSPWC     DC.B    16, 0, 0, 0, 0
            DS.W    0
