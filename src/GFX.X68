; ==============================================================================
; GRAPHICS SUBROUTINES
; ==============================================================================

            OPT     MEX

; ------------------------------------------------------------------------------
GFXEIPLT
; PLOTS AN ENTITY BASED ON ITS ENTITY INFO.
; INPUT    : D3.W = TILENO, D6.W = X, D7.W = Y, A3 = &EI
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-A1/A3, -(SP)

            CLR.W   D0
            CLR.W   D4
            CLR.W   D5

            MOVE.B  1(A3), D4           ; TILE WIDTH - 1 (DBRA)
            SUBQ.B  #1, D4
            MOVE.B  2(A3), D5           ; TILE HEIGHT - 1 (DBRA)
            SUBQ.B  #1, D5

            LSL.W   #1, D3              ; MULTIPLY BY 2 (WORD TO BYTE)

            MOVEA.W 4(A3, D3), A1       ; RELATIVE POSITION OF TILE TO BUFFER

            BUFAT   TS, A1, A3          ; GET ADDRESS OF TILE

            MOVE.W  D6, D3              ; STORE X FOR SAFEKEEPING
            SWAP    D3
            MOVE.W  D4, D3              ; STORE WIDTH FOR SAFEKEEPING

.LOOP
            MOVE.B  (A3)+, D0           ; D0 NOW IS COLOR INDEX

            CMPI.B  #$FF, D0
            BEQ     .ENDX               ; SKIP COLOR IF TRANSPARENT

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

            MOVEM.L (SP)+, D0-A1/A3            
            RTS
