; ==============================================================================
; BUFFERS FOR FILE READING
; ==============================================================================

BUFFMODE    DC.B    0                       ; DEFINES THE CURRENT BUFFER MODE
            DS.W    0                       ; 0 = STATIC, 1 = LEVEL

; --- COUNTERS -----------------------------------------------------------------
; COUNTERS POINT TO THE LAST FREE INDEX OF THE RELATED BUFFER.

STACLCNT    DC.W    0                       ; STATIC COLOR BUFFER COUNTER
STATSCNT    DC.W    0                       ; STATIC TILE SET BUFFER COUNTER
STAEICNT    DC.W    0                       ; STATIC ENTITY INFO BUFFER COUNTER

LVLCLCNT    DC.W    0                       ; LEVEL COLOR BUFFER COUNTER
LVLTSCNT    DC.W    0                       ; LELEL TILE SET BUFFER COUNTER
LVLMPCNT    DC.W    0                       ; LEVEL MAP BUFFER COUNTER
LVLEICNT    DC.W    0                       ; LEVEL ENTITY INFO BUFFER COUNTER

; --- BUFFERS ------------------------------------------------------------------

; STATIC BUFFERS (ONE-TIME READ)

STACLBUF    DS.L    10                      ; COLORS
STATSBUF    DS.B    256*6*2                 ; TILE SET (SPRITES)
STAEIBUF    DS.B    (4+6*2)*2               ; ENTITY INFO
            DS.W    0

; LEVEL BUFFERS (RESET EVERY NEW LEVEL)

LVLCLBUF    DS.L    32                      ; MAP AND ENEMIES COLORS
LVLTSBUF    DS.B    256*22+1024*2*ENMMAXTP  ; MAP AND ENEMIES TILES (SPRITES)
LVLMPBUF    DS.B    100                     ; MAP DATA
LVLEIBUF    DS.B    (4+33*2)+8*ENMMAXTP     ; MAP AND ENEMIES' ENTITY INFO

FILERBUF    DS.B    4                       ; FILE READ TEMPORARY BUFFER
            DS.W    0
