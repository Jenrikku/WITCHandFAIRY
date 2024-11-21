; ==============================================================================
; BUFFERS FOR FILE READING
; ==============================================================================

; DEFINES THE CURRENT BUFFER MODE
; 0 = STATIC, 1 = LEVEL
BUFFMODE    DC.B    0
            DS.W    0

; --- COUNTERS -----------------------------------------------------------------
; COUNTERS POINT TO THE LAST FREE INDEX OF THE RELATED BUFFER.

STACLCNT    DC.W    0                       ; STATIC COLOR BUFFER COUNTER
STATLCNT    DC.W    0                       ; STATIC TILE BUFFER COUNTER

LVLCLCNT    DC.W    0                       ; LEVEL COLOR BUFFER COUNTER
LVLTLCNT    DC.W    0                       ; LELEL TILE BUFFER COUNTER
LVLMPCNT    DC.W    0                       ; LEVEL MAP BUFFER COUNTER

; --- POINTERS -----------------------------------------------------------------
; POINTERS ARE USED TO KNOW WHAT DATA IS WHERE IN THE BUFFERS.

PL1BFPTR      DS.W    1                     ; WITCH POINTER TO STATIC EI
PL2BFPTR      DS.W    1                     ; FAIRY POINTER TO STATIC EI
ENMBFPTR      DS.W    ENMMAXTP              ; ENEMIES POINTERS TO LEVEL EI

; --- BUFFERS ------------------------------------------------------------------

; STATIC BUFFERS (ONE-TIME READ)
STACLBUF    DS.L    16                      ; COLORS
STATLBUF    DS.B    256                     ; TILES (SPRITES)

            DS.W    0
STAEIBUF    DS.B    6*2                     ; ENTITY INFO

; LEVEL BUFFERS (RESET EVERY NEW LEVEL)
LVLCLBUF    DS.L    255                     ; MAP AND ENEMIES COLORS
LVLTLBUF    DS.B    16384                   ; MAP AND ENEMIES TILES (SPRITES)
LVLMPBUF    DS.B    100                     ; MAP DATA

            DS.W    0
LVLEIBUF    DS.B    6*ENMMAXTP              ; ENEMIES' ENTITY INFO

FILERBUF    DS.B    4                       ; FILE READ TEMPORARY BUFFER
