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
    
            MOVEM.L D0-D5/A2, -(SP)

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
            MOVEQ   #1, D2                  ; READ AMOUNT OF COLORS
            TRAP    #15

            MOVE.B  (A1), D3                ; PUT AMOUNT OF COLORS IN D3
            SUBQ.B  #1, D3                  ; ADJUST FOR DBRA

            BUFCNT  CL, D4                  ; GET COLOR COUNTER (USED ON TL)

            MOVEQ   #4, D2                  ; EACH COLOR IS 4 BYTES LONG

.CLLOOP
            TRAP    #15                     ; READ COLOR
            BUFCP.L (A1), CL, A2, D5        ; WRITE COLOR TO BUFFER

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

            CLR.B   3(A1)

            BUFCP.L (A1), EI, A2, D5        ; COPY DATA TO ENTITY INFO

            BUFCNT  TL, D3
            BUFCP.W D3, EI, A2, D5          ; WRITE POINTER TO TILE BUFFER

            MOVE.B  (A1), D3
            MOVE.B  1(A1), D0

            MULU    D0, D3

            MOVE.B 2(A1), D0

            MULU    D0, D3                  ; D3 NOW IS TOTAL BYTES TO READ

            MOVEQ   #1, D2                  ; EACH PIXEL IS 1 BYTE LONG

.TLLOOP
            TRAP    #15
            CLR.W   D5
            ; TO-DO: SUM D4 WITH PIXEL AND THAT'S THE RESULTING COLOR

.END
            MOVEM.L (SP)+, D0-D5/A2

            RTS