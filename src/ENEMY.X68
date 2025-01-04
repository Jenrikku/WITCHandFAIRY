; ==============================================================================
; ENEMY MANAGEMENT
; ==============================================================================
  
; ------------------------------------------------------------------------------
ENMRESET
; RESET ENEMIES VARIABLES.
; INPUT    : D0 = ENEMYNO, D1 = ENEMY TYPE
; OUTPUT   : NONE 
; MODIFIES : A0
; ------------------------------------------------------------------------------

            LSL.W   #1, D0                  ; MULTIPLY BY 2 (WORD TO BYTE)

            LEA     ENMPOSX, A0
            CLR.W   (A0, D0.W)

            LEA     ENMPOSY, A0
            CLR.W   (A0, D0.W)

            LEA     ENMVELXY, A0
            CLR.W   (A0, D0.W)

            LSR.W   #1, D0                  ; DIVIDE BY 2 (BACK TO BYTE)

            LEA     ENMTILE, A0
            CLR.B   (A0, D0.W)

            LEA     ENMTYPE, A            
            MOVE.B  D1, (A0, D0.W)

            LEA     ENMHP, A0               ; ENEMY HP IS INITIALLY 1.
            MOVE.B  #1, (A0, D0.W)          ; ONCE YOU TOUCH THEM, YOU KILL THEM

            RTS

; ------------------------------------------------------------------------------
ENMUPD
; UPDATE ENEMY.
; INPUT    : D0 = ENEMYNO
; OUTPUT   : NONE
; MODIFIES : D0-D7, A0
; ------------------------------------------------------------------------------

            LSL.W   #1, D0                  ; MULTIPLY BY 2 (WORD TO BYTE)

        ; CHECK COLLISION OF ENEMY WITH WITCH

            MOVE.W  ENMPOSX, A0
            MOVE.W  (A0, D0), D4
            MOVE.W  ENMPOSY, A0
            MOVE.W  (A0, D0), D5

            LSR.W   #1, D0                  ; DIVIDE BY 2 (BACK TO BYTE)

            MOVE.W  D4, D6
            MOVE.W  ENMWIDTH, A0
            ADD.W   (A0, D0), D6
            MOVE.W  D5, D7
            MOVE.W  ENMHEIGH, A0
            ADD.W   (A0, D0), D7

            MOVE.W  PL1POSX, D0
            MOVE.W  PL1POSY, D1
            MOVE.W  D0, D2
            ADD.W   #16*PXLX, D2
            MOVE.W  D1, D3
            ADD.W   #16*PXLX, D3

            JSR     ENMCOL

        ; CHECK COLLISION OF ENEMY AND FAIRY

            MOVE.W  PL2POSX, D0
            MOVE.W  PL2POSY, D1
            MOVE.W  D0, D2
            ADD.W   #16*PXLX, D2
            MOVE.W  D1, D3
            ADD.W   #16*PXLX, D3

            JSR     ENMCOL

            RTS

; ------------------------------------------------------------------------------
ENMCOL
; CHECK ENEMY COLLISION WITH A PLAYER.
; INPUT    : D0.W-D3.W: PLAYER RECTANGLE, D4.W-D7.W: ENEMY RECTANGLE
;            RECTANGLES ARE DEFINED BY X0, Y0, X1, Y1.
;            X0 AND Y0 ARE THE UPPER LEFT CORNER
;            WHILE X1 AND Y1 ARE THE LOWER RIGHT CORNER.
; OUTPUT   : D0 SET IF COLLISION, 0 OTHERWISE.
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            CMP.W   D4, D2                  ; COMPARE X0 ENEMY AND X1 PLAYER
            BLE     .NOCOL                  ; NO COLLISION IF X1 PLY < X0 ENM

            CMP.W   D0, D6                  ; COMPARE X0 PLAYER AND X1 ENEMY
            BLE     .NOCOL                  ; NO COLLISION IF X1 ENM < X0 PLY

            CMP.W   D5, D3                  ; COMPARE Y0 ENEMY AND Y1 PLAYER
            BLE     .NOCOL                  ; NO COLLISION IF Y1 PLY < Y0 ENM

            CMP.W   D1,D7                   ; COMPARE Y0 PLAYER AND Y1 ENEMY
            BLE     .NOCOL                  ; NO COLLISION IF Y1 ENM < Y0 PLY

            MOVE.B  #$FF, D0
            RTS

.NOCOL      CLR.B   D0
            RTS

; ------------------------------------------------------------------------------
ENMPLOT
; PLOT ENEMY.
; INPUT    : D0 = ENEMYNO
; OUTPUT   : NONE
; MODIFIES : D0, D3, D6, D7, A3
; ------------------------------------------------------------------------------

            CLR.W   D3

            LEA     ENMTILE, A3
            MOVE.B  (A3, D0.W), D3          ; ENEMY TILE

            LSL.W   #1, D0                  ; MULTIPLY BY 2 (WORD TO BYTE)

            LEA     ENMPOSX, A3
            MOVE.W  (A3, D0.W), D6          ; ENEMY POS X

            LEA     ENMPOSY, A3
            MOVE.W  (A3, D0.W), D7          ; ENEMY POS Y

            LSR.W   #1, D0                  ; DIVIDE BY 2 (BACK TO BYTE)

            LEA     ENMTYPE, A3
            MOVE.B  (A3, D0.W), D0          ; ENEMY TYPE

            LSL.W   #2, D0                  ; MULTIPLY BY 4 (LONG TO BYTE)

            LEA     ENMEIPOS, A3
            MOVEA.L (A3, D0.W), A3

            JSR     GFXEIPLT

            RTS
