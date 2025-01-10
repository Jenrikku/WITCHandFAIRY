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

LVL1SPWP    DC.W    -16, 400+16*PXLX
            DC.W    -16, 300
            DC.W    480, 200-16*PXLX
            DC.W    480, 400
            DC.W    -16, 0
            DC.W    -16, 300-16*PXLY
            DC.W    480, 100
            DC.W    -16, 200
            DC.W    480, 16*PXLY
            DC.W    480, 300
            DC.W    480, 100
            DC.W    -16, 100+16*PXLY
            DC.W    -16, 300+16*PXLY
            DC.W    -16, 200-16*PXLY
            DC.W    480, 100-16*PXLY
            DC.W    480, 0

LVL2SPWD    DC.B    1, 2, 2, 3, 4, 4, 5, 6, 7, 8, 8, 8, 9, 9, 10, 10

LVL2SPWT    DC.B    0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1

LVL2SPWM    DC.B    0, 0, 4, 4, 0, 0, 4, 0, 4, 4, 4, 0, 0, 0, 4, 4
            DS.W    0

LVL2SPWP    DC.W    480, 400
            DC.W    480, 300
            DC.W    100, 480
            DC.W    300, 480
            DC.W    480, 0
            DC.W    480, 300-16*PXLY
            DC.W    100+16*PXLX, 480
            DC.W    480, 200
            DC.W    300-16*PXLX, 480
            DC.W    200, 480
            DC.W    200+16*PXLX, 480
            DC.W    480, 100+16*PXLY
            DC.W    480, 300+16*PXLY
            DC.W    480, 400-16*PXLY
            DC.W    0, 480
            DC.W    480-16*PXLX*2, 480

LVL3SPWD    DC.B    1, 2, 2, 3, 4, 4, 5, 6, 7, 8, 8, 8, 9, 9, 10, 10

LVL3SPWT    DC.B    1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0

LVL3SPWM    DC.B    1, 1, 3, 3, 1, 1, 3, 1, 3, 3, 3, 1, 1, 1, 3, 3
            DS.W    0

LVL3SPWP    DC.W    480, 400+16*PXLX
            DC.W    480, 300
            DC.W    300+16*PXLX, -32
            DC.W    200, -32
            DC.W    480, 0
            DC.W    480, 300-16*PXLY
            DC.W    100, -32
            DC.W    480, 200
            DC.W    480, 400+16*PXLY
            DC.W    480, 300
            DC.W    0, -32
            DC.W    480, 100+16*PXLY
            DC.W    480, 300+16*PXLY
            DC.W    480, 200-16*PXLY
            DC.W    0, -32
            DC.W    480-16*PXLX, -32

LVL4SPWD    DC.B    1, 2, 2, 3, 4, 4, 5, 6, 7, 8, 8, 8, 9, 9, 10, 10

LVL4SPWT    DC.B    0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1

LVL4SPWM    DC.B    0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1
            DS.W    0

LVL4SPWP    DC.W    -32, 400+16*PXLX
            DC.W    -32, 300
            DC.W    480, 200-16*PXLX
            DC.W    480, 400
            DC.W    -32, 0
            DC.W    -32, 300-16*PXLY
            DC.W    480, 100
            DC.W    -32, 200
            DC.W    480, 16*PXLY
            DC.W    480, 300
            DC.W    480, 100
            DC.W    -32, 100+16*PXLY
            DC.W    -32, 300+16*PXLY
            DC.W    -32, 200-16*PXLY
            DC.W    480, 100-16*PXLY
            DC.W    480, 0

LVL5SPWD    DC.B    1, 2, 2, 3, 4, 4, 5, 6, 7, 8, 8, 8, 9, 9, 10, 10

LVL5SPWT    DC.B    1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0

LVL5SPWM    DC.B    1, 1, 3, 3, 1, 1, 3, 1, 3, 3, 3, 1, 1, 1, 3, 3
            DS.W    0

LVL5SPWP    DC.W    480, 400+16*PXLX
            DC.W    480, 300
            DC.W    300+16*PXLX, -32
            DC.W    200, -32
            DC.W    480, 0
            DC.W    480, 300-16*PXLY
            DC.W    100, -32
            DC.W    480, 200
            DC.W    480, 400+16*PXLY
            DC.W    480, 300
            DC.W    0, -32
            DC.W    480, 100+16*PXLY
            DC.W    480, 300+16*PXLY
            DC.W    480, 200-16*PXLY
            DC.W    0, -32
            DC.W    480-16*PXLX, -32

; --- LEVEL SPAWN JUMP LISTS ---------------------------------------------------

LVLSPWD     DC.L    LVL1SPWD
            DC.L    LVL2SPWD
            DC.L    LVL3SPWD
            DC.L    LVL4SPWD
            DC.L    LVL5SPWD

LVLSPWT     DC.L    LVL1SPWT
            DC.L    LVL2SPWT
            DC.L    LVL3SPWT
            DC.L    LVL4SPWT
            DC.L    LVL5SPWT

LVLSPWM     DC.L    LVL1SPWM
            DC.L    LVL2SPWM
            DC.L    LVL3SPWM
            DC.L    LVL4SPWM
            DC.L    LVL5SPWM

LVLSPWP     DC.L    LVL1SPWP
            DC.L    LVL2SPWP
            DC.L    LVL3SPWP
            DC.L    LVL4SPWP
            DC.L    LVL5SPWP

; --- LEVEL SPAWN COUNT (AMOUNT) -----------------------------------------------

LVLSPWC     DC.B    16, 16, 16, 16, 16
            DS.W    0
