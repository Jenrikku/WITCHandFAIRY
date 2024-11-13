; ==============================================================================
; BINARY TILE MAP FILE MANAGEMENT
; ==============================================================================

; ------------------------------------------------------------------------------
BTMREAD
; READS A BINARY TILE MAP AND STORES IT TO MEMORY.
; INPUT    : A1 = FILEPATH
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
    
            MOVEM.L D0-D1, -(SP)

            MOVE.L  #51, D0                 ; OPEN FILE
            TRAP    #15

            CMPI    #0, D0                  ; CHECKS IF FILE OPENED CORRECTLY
            BNE     .END                    ; ABORT IF UNSUCCESSFUL

            

.END
            MOVEM.L (SP)+, D0-D1

            RTS