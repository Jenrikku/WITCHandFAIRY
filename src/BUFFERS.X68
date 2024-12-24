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
STATSCNT    DC.W    0                       ; STATIC TILE SET BUFFER COUNTER
STAEICNT    DC.W    0                       ; STATIC ENTITY INFO BUFFER COUNTER

LVLCLCNT    DC.W    0                       ; LEVEL COLOR BUFFER COUNTER
LVLTSCNT    DC.W    0                       ; LELEL TILE SET BUFFER COUNTER
LVLMPCNT    DC.W    0                       ; LEVEL MAP BUFFER COUNTER
LVLEICNT    DC.W    0                       ; LEVEL ENTITY INFO BUFFER COUNTER

; --- POINTERS -----------------------------------------------------------------
; POINTERS ARE USED TO KNOW WHAT DATA IS WHERE IN THE BUFFERS.

PL1BFPTR      DS.W    1                     ; WITCH POINTER TO STATIC EI
PL2BFPTR      DS.W    1                     ; FAIRY POINTER TO STATIC EI
ENMBFPTR      DS.W    ENMMAXTP              ; ENEMIES POINTERS TO LEVEL EI

; --- BUFFERS ------------------------------------------------------------------

; STATIC BUFFERS (ONE-TIME READ)
STACLBUF    DS.L    16                      ; COLORS
STATSBUF    DS.B    256*6*2                 ; TILE SET (SPRITES)

            DS.W    0
STAEIBUF    DS.B    (4+6*2)*2               ; ENTITY INFO

; LEVEL BUFFERS (RESET EVERY NEW LEVEL)
LVLCLBUF    DS.L    255                     ; MAP AND ENEMIES COLORS
LVLTSBUF    DS.B    256*22+1024*2*ENMMAXTP  ; MAP AND ENEMIES TILES (SPRITES)
LVLMPBUF    DS.B    100                     ; MAP DATA

            DS.W    0
LVLEIBUF    DS.B    (4+33*2)+8*ENMMAXTP      ; MAP AND ENEMIES' ENTITY INFO

FILERBUF    DS.B    4                       ; FILE READ TEMPORARY BUFFER
