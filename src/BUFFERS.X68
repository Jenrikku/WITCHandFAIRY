; ==============================================================================
; BUFFERS FOR FILE READING
; ==============================================================================

; --- COUNTERS -----------------------------------------------------------------

STATCCNT    DC.W    0                       ; STATIC BUFFER COUNTER
LVLCLCNT    DC.W    0                       ; LEVEL COLOR COUNTER
LVLTLCNT    DC.W    0                       ; LELEL TILE COUNTER
LVLMPCNT    DC.W    0                       ; LEVEL MAP COUNTER

; --- BUFFERS ------------------------------------------------------------------

STATCBUF    DS.B    256                     ; ONE-TIME-READ BUFFER (STATIC)
LVLCLBUF    DS.B    3*32                    ; LEVEL COLOR BUFFER (ALSO ENEMIES)
LVLTLBUF    DS.B    16384                   ; LEVEL TILE BUFFER (ALSO ENEMIES)
LVLMPBUF    DS.B    100                     ; LEVEL MAP BUFFER
FILERBUF    DS.B    16                      ; FILE READ TEMPORARY BUFFER

            DS.W    0
