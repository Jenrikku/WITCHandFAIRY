; ==============================================================================
; SYSTEM
; ==============================================================================
            
; ------------------------------------------------------------------------------
SYSINIT
; INITIALIZE SYSTEM.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0, D1
; ------------------------------------------------------------------------------
           
        ; SET OUTPUT WINDOW:

            MOVEQ   #33, D0
            MOVE.L  #SCRWIDTH*$10000+SCRHEIGH, D1   ; SET RESOLUTION
            TRAP    #15

            MOVEQ   #33, D0
            MOVE.L  #SCRMODE, D1                    ; SET WINDOW MODE
            TRAP    #15

            RTS
