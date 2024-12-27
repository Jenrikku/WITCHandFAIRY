; ==============================================================================
; LEVEL MANAGEMENT
; ==============================================================================

; ------------------------------------------------------------------------------
LVLSWTCH
; SWITCHES TO ANOTHER LEVEL.
; INPUT    : D0 = LVLNO 
; OUTPUT   : NONE
; MODIFIES : D0
; ------------------------------------------------------------------------------

            MOVE.B  D0, LVLINDEX

        ; RESET COUNTERS:

            CLR.W   LVLCLCNT
            CLR.W   LVLTSCNT
            CLR.W   LVLMPCNT
            CLR.W   LVLEICNT

        ; READ BTM FILE:
        
            LSL.W   #2, D0                  ; MULTIPLY BY 4 (LONG TO BYTE)
            LEA     LVLLIST, A1
            ADDA.W  D0, A1

            MOVE.L  A3, LVLEIPOS
            
            RTS

; ------------------------------------------------------------------------------
LVLPLOT
; PLOTS THE CURRENT LEVEL MAP.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            

            
            RTS

