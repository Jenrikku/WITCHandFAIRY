; ==============================================================================
; BINARY TILE MAP FILE MANAGEMENT
; ==============================================================================

; ------------------------------------------------------------------------------
BTMREAD
; READS A BINARY TILE MAP AND STORES IT TO MEMORY.
; INPUT    : A1 = FILEPATH
; OUTPUT   : NONE
; MODIFIES : A1 = 0
; ------------------------------------------------------------------------------
    
            MOVEM.L D0-D3, -(SP)

            CLR.L   D0
            CLR.L   D1
            CLR.L   D2
            CLR.L   D3

            MOVE.B  #51, D0                 ; OPEN FILE
            TRAP    #15

            CMPI    #0, D0                  ; CHECKS IF FILE OPENED CORRECTLY
            BNE     .END                    ; ABORT IF UNSUCCESSFUL
          
            LEA     FILERBUF, A1            ; GET ADDRESS OF FILE BUFFER

            MOVE.B  #53, D0
            MOVE.B  #16, D2                 ; READ HEADER
            TRAP    #15

            CMPI.L  #'JkBM', (A1)           ; CHECK MAGIC (JkBM)
            BNE     .END                    ; END IF INCORRECT

            MOVE.B  #55, D0
            MOVE.L  4(A1), D2               ; JUMP TO CL SECTION
            BEQ     .END                    ; END IF NO CL SECTION (OFFSET = 0)
            TRAP    #15

            MOVE.B  #53, D0
            MOVE.L  #3, D2                  ; READ MAGIC (TS)
            TRAP    #15

            CMPI.W  #'CL', (A1)             ; CHECK MAGIC (JkBM)
            BNE     .END                    ; END IF INCORRECT

            MOVE.B  3(A1), D3               ; AMOUNT OF COLORS

.END
            MOVEM.L (SP)+, D0-D3

            RTS