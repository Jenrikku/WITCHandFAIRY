; ==============================================================================
; GRAPHICS SUBROUTINES
; ==============================================================================

            OPT     MEX

; ------------------------------------------------------------------------------
GFXEIPLT
; PLOTS AN ENTITY BASED ON ITS ENTITY INFO.
; INPUT    : D3.W = TILENO, D4.B = NOBACK, D6.W = X, D7.W = Y, A3 = &EI
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-A3, -(SP)

            CLR.W   D0
            MOVEA.W #$FF, A2            ; DEFAULT: NO BACK COLOR

            MOVE.L  A3, A0              ; SAVE ADDRESS OF EI FOR LATER

            LSL.W   #1, D3              ; MULTIPLY BY 2 (WORD TO BYTE)

            MOVEA.W 4(A3, D3), A1       ; RELATIVE POSITION OF TILE TO BUFFER

            BUFAT   TS, A1, A3          ; A3 NOW IS ADDRESS TO FIRST COLOR INDEX

            TST.B   D4
            BNE     .NOBACK             ; IF D4 IS SET, THEN FORCE NO BACK

            MOVE.B  (A3), D0            ; D0 NOW IS BACKGROUND COLOR INDEX
            MOVEA.W  D0, A2             ; STORE BACK COLOR IN A2 FOR LATER
            
            CMPI.B  #$FF, D0
            BEQ     .NOBACK             ; SKIP DRAWING BACKGROUND IF TRANSPARENT

            LSL.W   #2, D0              ; MULTIPLY BY 4 (LONG TO BYTE)
            BUFAT   CL, D0, A1
            MOVE.L  (A1), D1            ; D1 NOW IS BACKGROUND COLOR

            MOVEQ   #80, D0
            TRAP    #15                 ; SET PEN COLOR

            MOVEQ   #81, D0
            TRAP    #15                 ; SET FILL COLOR

            MOVE.W  D6, D1              ; X0 = D6
            MOVE.W  D7, D2              ; Y0 = D7
            CLR.W   D3
            MOVE.B  1(A0), D3
            MULU.W  #3, D3              ; X1 = D6 + TILE WIDTH * 3
            ADD.W   D6, D3
            CLR.W   D4
            MOVE.B  2(A0), D4
            MULU.W  #3, D4
            ADD.W   D7, D4              ; Y1 = D7 + TILE HEIGHT * 3

            MOVEQ   #87, D0
            TRAP    #15                 ; DRAW BACKGROUND COLOR RECTANGLE

.NOBACK     CLR.W   D4
            CLR.W   D5

            MOVE.B  1(A0), D4           ; TILE WIDTH - 1 (DBRA)
            SUBQ.B  #1, D4
            MOVE.B  2(A0), D5           ; TILE HEIGHT - 1 (DBRA)
            SUBQ.B  #1, D5

            MOVE.W  D6, D3              ; STORE X FOR SAFEKEEPING
            SWAP    D3
            MOVE.W  D4, D3              ; STORE WIDTH FOR SAFEKEEPING

.LOOP
            CLR.W   D0
            MOVE.B  (A3)+, D0           ; D0 NOW IS COLOR INDEX

            CMPI.B  #$FF, D0
            BEQ     .ENDX               ; SKIP COLOR IF TRANSPARENT

            CMPA.W  D0, A2              ; COMPARE BACK COLOR TO CURRENT
            BEQ     .ENDX               ; SKIP IF SAME

            LSL.W   #2, D0              ; MULTIPLY BY 4 (LONG TO BYTE)

            BUFAT   CL, D0, A1
            MOVE.L  (A1), D1            ; D1 NOW IS PIXEL COLOR

            MOVEQ   #80, D0
            TRAP    #15                 ; SET PEN COLOR

            CLR.L   D1

            MOVE.W  D6, D1              ; X
            MOVE.W  D7, D2              ; Y

            SWAP    D4
            SWAP    D5

            MOVE.W #PXLX-1, D4          ; AMOUNT OF DRAWS X PER PIXEL - 1 (DBRA)
            MOVE.W #PXLY-1, D5          ; AMOUNT OF DRAWS Y PER PIXEL - 1 (DBRA)

.LOOPIN
            MOVEQ   #82, D0
            TRAP    #15                 ; DRAW PIXEL

            ADDQ.W  #1, D1              ; X += 1
            DBRA    D4, .LOOPIN

            ADDQ.W  #PXLX, D4           ; RESTORE DBRA INDEX
            ADDQ.W  #1, D2              ; Y += 1
            SUBQ.W  #PXLX, D1           ; MAKE X GO BACK TO START
            DBRA    D5, .LOOPIN

            SWAP    D4
            SWAP    D5

.ENDX       
            ADDQ.W  #PXLX, D6           ; MOVE TO THE RIGHT
            DBRA    D4, .LOOP

            ADDQ.W  #PXLY, D7           ; MOVE DOWNWARDS
            MOVE.W  D3, D4              ; RESTORE WIDTH
            SWAP    D3

            MOVE.W  D3, D6              ; MOVE BACK TO START
            SWAP    D3

            DBRA    D5, .LOOP

            MOVEM.L (SP)+, D0-A3            
            RTS
