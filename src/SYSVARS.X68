; ==============================================================================
; SYSTEM VARIABLES
; ==============================================================================

; --- KEYBOARD RELATED VARIABLES -----------------------------------------------

KBDVAL      DS.B    1                       ; KEY STATE
KBDEDGE     DS.B    1                       ; KEY EDGE

; --- FRAME RELATED VARIABLES --------------------------------------------------

; FRAME STATE
; BIT 0 -> FRAME READY, BIT 1 -> DRAW NEXT
FRMSTATE    DS.B    1

FRMCNT      DS.B    1                       ; INCREMENTED EVERY TIMED IRQ
FRMSKIP     DS.W    1                       ; AMOUNT OF FRAMES TO SKIP
