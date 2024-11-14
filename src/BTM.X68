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
    
            MOVEM.L D0-D4/A1, -(SP)

            CLR.L   D0
            CLR.L   D1
            CLR.L   D2
            CLR.L   D3
            CLR.L   D4

            MOVE.B  #51, D0                 ; OPEN FILE (WITH A1=FILEPATH)
            TRAP    #15

            CMPI    #0, D0                  ; CHECKS IF FILE OPENED CORRECTLY
            BNE     .END                    ; ABORT IF UNSUCCESSFUL
          
            LEA     FILERBUF, A1            ; GET ADDRESS OF FILE BUFFER

            RDMGC.L JkBM, .END              ; READ HEADER MAGIC

            ; CL SECTION:

            RDJMP.L .END                    ; GO TO CL SECTION, END IF OFFSET=0

            RDMGC.W CL, .END                ; READ CL SECTION MAGIC

            MOVE.B  3(A1), D3               ; AMOUNT OF COLORS
            SUBQ.B  #1, D3                  ; ADJUST TO DBRA

.CLLOOP


            DBRA    D3, .CLLOOP
.END
            MOVEM.L (SP)+, D0-D4/A1

            RTS