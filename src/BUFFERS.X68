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

PL1PTR      DS.W    1                       ; WITCH POINTER TO STATIC BUFFER
PL2PTR      DS.W    1                       ; FAIRY POINTER TO STATIC BUFFER
ENMPTR      DS.W    ENMMAXNO                ; ENEMIES POINTERS TO LEVEL BUFFER

; --- BUFFERS ------------------------------------------------------------------

STACLBUF    DS.L    16                      ; ONE-TIME-READ BUFFER FOR COLORS
STATLBUF    DS.B    256                     ; ONE-TIME-READ BUFFER FOR TILES
            DS.W    0

LVLCLBUF    DS.L    255                     ; LEVEL COLOR BUFFER (ALSO ENEMIES)
LVLTLBUF    DS.B    16384                   ; LEVEL TILE BUFFER (ALSO ENEMIES)
LVLMPBUF    DS.B    100                     ; LEVEL MAP BUFFER
            DS.W    0

FILERBUF    DS.B    16                      ; FILE READ TEMPORARY BUFFER
            DS.W    0
