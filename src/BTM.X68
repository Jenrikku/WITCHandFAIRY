; ==============================================================================
; BINARY TILE MAP FILE MANAGEMENT
; ==============================================================================

; ------------------------------------------------------------------------------
BTMREAD
; READS A BINARY TILE MAP AND STORES IT TO MEMORY.
; INPUT    : A1 = FILEPATH
; OUTPUT   : A1 = POINTER TO BUFFER
; MODIFIES : NONE
; ------------------------------------------------------------------------------
    
            MOVEM.L D0-D4/A2, -(SP)

            CLR.L   D0
            CLR.L   D1
            CLR.L   D2
            CLR.L   D3
            CLR.L   D4

            MOVEQ   #51, D0                 ; OPEN FILE (WITH A1=FILEPATH)
            TRAP    #15

            CMPI    #0, D0                  ; CHECKS IF FILE OPENED CORRECTLY
            BNE     .END                    ; ABORT IF UNSUCCESSFUL
          
            LEA     FILERBUF, A1            ; GET ADDRESS OF FILE BUFFER

            RDMGC.L JkBM, .END              ; READ HEADER MAGIC

            ; CL SECTION:

            RDJMP.L .END                    ; GO TO CL SECTION, END IF OFFSET=0

            RDMGC.W CL, .END                ; READ CL SECTION MAGIC

            MOVE.W  CL

            MOVEQ   #53, D0
            MOVEQ   #1, D2
            TRAP    #15

            MOVE.B  (A1), D3                ; AMOUNT OF COLORS
            SUBQ.B  #1, D3                  ; ADJUST TO DBRA

            CMPI.B  #0, BUFFMODE
            BEQ     .STATIC
            MOVE.W  LVLCLCNT, D4            ; GET LEVEL COLOR COUNTER
            BRA     .CLLOOP

.STATIC     MOVE.W  STACLCNT, D4            ; GET STATIC COLOR COUNTER

.CLLOOP
            MOVEQ   #4, D2                  ; READ COLOR
            TRAP    #15

            BUFCP.L (A1), CL, A2, D2        ; WRITE COLOR TO BUFFER

            DBRA    D3, .CLLOOP

            ; TL SECTION:

            MOVEQ   #55, D0
            MOVEQ   #8, D2                  ; GO TO TL SECTION OFFSET
            TRAP    #15

            RDJMP.L .END                    ; GO TO TL SECTION, END IF OFFSET=0

            RDMGC.W TL, .END                ; READ TL SECTION MAGIC

            MOVEQ   #53, D0
            MOVEQ   #3, D2                  ; READ AMOUNT, WIDTH AND HEIGHT
            TRAP    #15

            MOVE.B  (A1), D3
            MOVE.B  1(A1), D0

            MULU    D0, D3

.END
            MOVEM.L (SP)+, D0-D4/A2

            RTS