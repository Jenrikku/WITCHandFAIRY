; ==============================================================================
; BINARY TILE MAP FILE MANAGEMENT
; ==============================================================================

            OPT     MEX

; ------------------------------------------------------------------------------
BTMREAD
; READS A BINARY TILE MAP AND STORES IT TO MEMORY.
; INPUT    : A1 = FILEPATH
; OUTPUT   : A3 = POINTER TO EI
; MODIFIES : A1
; ------------------------------------------------------------------------------

            MOVEM.L D0-D6/A2, -(SP)

            CLR.L   D1
            CLR.L   D2
            CLR.L   D3                      ; USED FOR DBRA
            CLR.L   D4                      ; USED TO KEEP TRACK OF CLCNT
            CLR.L   D5                      ; MISC 1 
            CLR.L   D6                      ; MISC 2

            MOVEQ   #51, D0                 ; OPEN FILE (WITH A1=FILEPATH)
            TRAP    #15

            CMPI    #0, D0                  ; CHECKS IF FILE OPENED CORRECTLY
            BNE     .END                    ; ABORT IF UNSUCCESSFUL
          
            LEA     FILERBUF, A1            ; GET ADDRESS OF FILE BUFFER

            RDMGC.L $4A6B424D, .END          ; READ HEADER MAGIC

            ; CL SECTION:

            RDJMP.L .END                    ; GO TO CL SECTION, END IF OFFSET=0

            RDMGC.W 'CL', .END              ; READ CL SECTION MAGIC

            MOVEQ   #53, D0
            MOVEQ   #1, D2                  ; READ AMOUNT OF COLORS
            TRAP    #15

            MOVE.B  (A1), D3                ; PUT AMOUNT OF COLORS IN D3
            SUBQ.B  #1, D3                  ; ADJUST FOR DBRA

            BUFCNT  CL, D4                  ; GET COLOR COUNTER (USED ON TS)

            MOVEQ   #4, D2                  ; EACH COLOR IS 4 BYTES LONG

.CLLOOP
            MOVEQ   #53, D0
            TRAP    #15                     ; READ COLOR

            BUFCP.L (A1), CL, A2, D6        ; WRITE COLOR TO BUFFER

            DBRA    D3, .CLLOOP

            ; TS SECTION:

            MOVEQ   #55, D0
            MOVEQ   #8, D2                  ; GO TO TS SECTION OFFSET
            TRAP    #15

            RDJMP.L .END                    ; GO TO TS SECTION, END IF OFFSET=0

            RDMGC.W 'TS', .END              ; READ TS SECTION MAGIC

            MOVEQ   #53, D0
            MOVEQ   #3, D2                  ; READ AMOUNT, WIDTH AND HEIGHT
            TRAP    #15

            CLR.B   3(A1)

            BUFCP.L (A1), EI, A3, D6        ; COPY DATA TO ENTITY INFO

            BUFCNT  TS, D3
            BUFCP.W D3, EI, A2, D6          ; WRITE POINTER TO TILE BUFFER

            MOVE.B  (A1), D3
            MOVE.B  1(A1), D0

            MULU    D0, D3

            MOVE.B 2(A1), D0

            MULU    D0, D3                  ; D3 NOW IS TOTAL BYTES TO READ
            SUBQ.W  #1, D3                  ; ADJUST FOR DBRA

            MOVEQ   #1, D2                  ; EACH PIXEL IS 1 BYTE LONG

.TSLOOP
            MOVEQ   #53, D0
            TRAP    #15

            MOVE.B  (A1), D5
            ADD.B   D4, D5                  ; CALCULATE ABSOLUTE COLOR INDEX

            BUFCP.B D5, TS, A2, D6

            DBRA    D3, .TSLOOP

            ; MP SECTION:

            MOVEQ   #55, D0
            MOVEQ   #12, D2                 ; GO TO MP SECTION OFFSET
            TRAP    #15

            RDJMP.L .END                    ; GO TO MP SECTION, END IF OFFSET=0

            RDMGC.W 'MP', .END              ; READ MP SECTION MAGIC

            MOVEQ   #53, D0
            MOVEQ   #2, D2                  ; READ WIDTH AND HEIGHT
            TRAP    #15

            CLR.L   D3
            CLR.L   D5

            MOVE.B  (A1), D3
            MOVE.B  1(A1), D5

            MULU    D5, D3                  ; D3 NOW IS TOTAL BYTES TO READ
            SUBQ.W  #1, D3                  ; ADJUST FOR DBRA

            MOVEQ   #1, D2
            
.MPLOOP
            MOVEQ   #53, D0
            TRAP    #15

            BUFCP.B (A1), MP, A2, D6        ; WRITE TO MP BUFFER

            DBRA    D3, .MPLOOP

.END
            MOVEQ   #56, D0
            TRAP    #15                     ; CLOSE FILE

            MOVEM.L (SP)+, D0-D6/A2

            RTS