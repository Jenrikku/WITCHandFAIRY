; ==============================================================================
; SYSTEM VARIABLES
; ==============================================================================

; --- KEYBOARD RELATED VARIABLES -----------------------------------------------

KBDVAL      DS.W    1                       ; KEY STATE (KEYS DOWN)
KBDEDGE     DS.W    1                       ; KEY EDGE  (KEYS PRESSED)

; --- FRAME RELATED VARIABLES --------------------------------------------------

; FRAME STATE
; BIT 0 -> FRAME READY, BIT 1 -> DRAW NEXT
FRMSTATE    DS.B    1

FRMCNT      DS.B    1                       ; INCREMENTED EVERY TIMED IRQ
FRMSKIP     DS.W    1                       ; AMOUNT OF FRAMES TO SKIP

; --- TIMER RELATED VARIABLE (SECONDS COUNT) -----------------------------------

TIMEDGE     DS.B    1                       ; TIMER EDGE (FIRST FRAME IT TICKS)
            DS.W    0
