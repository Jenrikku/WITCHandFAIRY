; ==============================================================================
; ENEMY MANAGEMENT
; ==============================================================================
  
; ------------------------------------------------------------------------------
ENMRESET
; RESET ALL ENEMY VARIABLES.
; INPUT    : NONE
; OUTPUT   : NONE 
; MODIFIES : D0, A0
; ------------------------------------------------------------------------------

            CLRM.W  ENMPOSX, ENMMAXNO, A0, D0
            CLRM.W  ENMPOSY, ENMMAXNO, A0, D0
            CLRM.B  ENMTILE, ENMMAXNO, A0, D0
            CLRM.B  ENMTYPE, ENMMAXNO, A0, D0
            CLRM.B  ENMMODE, ENMMAXNO, A0, D0
            CLRM.B  ENMWIDTH, ENMMAXNO, A0, D0
            CLRM.B  ENMHEIGH, ENMMAXNO, A0, D0
            CLRM.B  ENMHP, ENMMAXNO, A0, D0

            RTS

; ------------------------------------------------------------------------------
ENMSPAWN
; SPAWNS ENEMIES INTO THE LEVEL USING THE VALUES IN ENMSPAWN.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0-D3, A0-A5
; ------------------------------------------------------------------------------

            TST.B   TIMEDGE
            BEQ     .END                    ; ONLY SPAWN ON TIMER EDGE

            CLR.W   D0
            CLR.W   D1

            MOVE.B  LVLINDEX, D0

            LEA     LVLSPWC, A0
            MOVE.B  (A0, D0), D1            ; GET CURRENT LEVEL ENEMY COUNT
            SUBQ.B  #1, D1                  ; FOR DBRA

            LSL.W   #2, D0                  ; MULTIPLY BY 4 (LONG TO BYTE)

            LEA     LVLSPWD, A0
            LEA     LVLSPWT, A1
            LEA     LVLSPWM, A2
            LEA     LVLSPWP, A3

            MOVE.L  (A0, D0), A0            ; SET A0 AS FIRST ENEMY DELAY
            MOVE.L  (A1, D0), A1            ; SET A1 AS FIRST ENEMY TYPE
            MOVE.L  (A2, D0), A2            ; SET A2 AS FIRST ENEMY MODE
            MOVE.L  (A3, D0), A3            ; SET A3 AS FIRST ENEMY POSITION

            MOVE.B  LVLSPWTM, D0            ; D0.B NOW IS LEVEL SPAWN TIMER

.ENMLOOP
            CMP.B   (A0)+, D0               ; COMPARE DELAY TO CURRENT TIME
            BNE     .NOSPAWN                ; ONLY SPAWN IF IT MATCHES

        ; SEARCH FOR A FREE ENTRY TO SPAWN THE ENEMY INTO

            MOVE.W  #ENMMAXNO-1, D2
            LEA     ENMHP, A4               ; TO SEARCH FOR FREE ENEMIES (HP=0)

.SCHLOOP    
            TST.B   (A4, D2)
            BNE     .SCHCONT                ; CONTINUE IF HP IS NOT 0

            BRA     .SCHDONE                ; FOUND FREE SPACE IN INDEX D2

.SCHCONT    DBRA    D2, .SCHLOOP

.SCHDONE    TST.B   D2
            BMI     .END                    ; ABORT IF ENEMIES CANNOT FIT
            
            LEA     ENMTYPE, A4
            CLR.W   D3
            MOVE.B  (A1), D3                ; COPY TYPE
            MOVE.B  D3, (A4, D2)

            LSL.W   #2, D3                  ; MULTIPLY BY 4 (LONG TO BYTE)

            LEA     ENMEIPOS, A4
            MOVEA.L (A4, D3), A4

            LEA     ENMWIDTH, A5
            MOVE.B  1(A4), D3               ; COPY WIDTH FROM EI
            MULU.W  #PXLX, D3               ; ADJUST TO DISPLAY RESOLUTION
            MOVE.B  D3, (A5, D2)

            LEA     ENMHEIGH, A5
            MOVE.B  2(A4), D3               ; COPY HEIGHT FROM EI
            MULU.W  #PXLY, D3               ; ADJUST TO DISPLAY RESOLUTION
            MOVE.B  D3, (A5, D2)

            LEA     ENMMODE, A4
            MOVE.B  (A2), (A4, D2)          ; COPY MODE
            LEA     ENMHP, A4
            MOVE.B  #1, (A4, D2)            ; MAKE ENEMY ALIVE (GIVE IT HP)

            LSL.W   #1, D2                  ; MULTIPLY BY 2 (WORD TO BYTE)

            LEA     ENMPOSX, A4
            MOVE.W  (A3), (A4, D2)          ; COPY POSITION X
            LEA     ENMPOSY, A4
            MOVE.W  2(A3), (A4, D2)         ; COPY POSITION Y

.NOSPAWN    ADDQ.L  #1, A1
            ADDQ.L  #1, A2
            ADDQ.L  #4, A3

            DBRA    D1, .ENMLOOP

.END        RTS


; ------------------------------------------------------------------------------
ENMUPD
; UPDATE ENEMY.
; INPUT    : D0 = ENEMYNO
; OUTPUT   : NONE
; MODIFIES : D1-D7, A0, A1
; ------------------------------------------------------------------------------

            MOVE.W  D0, -(SP)

            LEA     ENMHP, A0
            TST.B   (A0, D0)
            BEQ     .END                    ; DO NOT UPDATE IF ENEMY IS DEAD

        ; ANIMATE

            LEA     ENMTILE, A0
            MOVE.B  #1, (A0, D0)

            BTST.B  #3, FRMCNT
            BNE     .NOANIM

            CLR.B   (A0, D0)

        ; CHECK MOVEMENT MODE

.NOANIM     LEA     ENMMODE, A0
            MOVE.B  (A0, D0), D1

            LSL.W   #1, D0                  ; MULTIPLY BY 2 (WORD TO BYTE)
            LEA     ENMPOSX, A0
            LEA     ENMPOSY, A1

            CMPI.B  #0, D1
            BEQ     .MODE0
            CMPI.B  #1, D1
            BEQ     .MODE1
            CMPI.B  #2, D1
            BEQ     .MODE2
            CMPI.B  #3, D1
            BEQ     .MODE3

.MODE0      ADDQ.W  #ENMSPEED, (A0, D0)

            CMPI.W  #SPNSTART+32*PXLX, (A0, D0)
            BGT     .KILL                   ; ENEMY OUT OF BOUNDS

            BRA     .MOVDONE

.MODE1      SUBQ.W  #ENMSPEED, (A0, D0)

            CMPI.W  #-32*PXLX, (A0, D0)
            BLT     .KILL                   ; ENEMY OUT OF BOUNDS

            BRA     .MOVDONE

.MODE2      ADDQ.W  #ENMSPEED, (A1, D0)

            CMPI.W  #SCRHEIGH+32*PXLX, (A1, D0)
            BGT     .KILL                   ; ENEMY OUT OF BOUNDS

            BRA     .MOVDONE

.MODE3      SUBQ.W  #ENMSPEED, (A1, D0)

            CMPI.W  #-32*PXLX, (A1, D0)
            BLT     .KILL                   ; ENEMY OUT OF BOUNDS

            BRA     .MOVDONE

        ; CHECK COLLISION OF ENEMY AND WITCH

.MOVDONE    LEA     ENMPOSX, A0
            MOVE.W  (A0, D0), D4
            LEA     ENMPOSY, A0
            MOVE.W  (A0, D0), D5

            LSR.W   #1, D0                  ; DIVIDE BY 2 (BACK TO BYTE)

            CLR.W   D6
            LEA     ENMWIDTH, A0
            MOVE.B  (A0, D0), D6
            ADD.W   D4, D6

            CLR.W   D7
            LEA     ENMHEIGH, A0
            MOVE.B  (A0, D0), D7
            ADD.W   D5, D7

            MOVE.W  PL1POSX, D0
            MOVE.W  PL1POSY, D1
            MOVE.W  D0, D2
            ADD.W   #16*PXLX, D2
            MOVE.W  D1, D3
            ADD.W   #16*PXLX, D3

            JSR     ENMCOL

            TST.B   D0
            BEQ     .COLSKIP                ; NO COLLISION WITH WITCH

            TST.B   PLYMODE                 ; CHECK PLAYER MODE (DODGE/ATTACK)
            BNE     .ATTACK

            TST.B   PL1DMGCD                ; CANNOT DAMAGE DURING COOLDOWN
            BNE     .COLSKIP

            SUBQ.B  #1, PLYHP
            MOVE.B  #PLYDMGCD, PL1DMGCD

            MOVEQ   #72, D0
            MOVE.B  #1, D1                  ; PLAY HURT SOUND
            TRAP    #15

        ; CHECK COLLISION OF ENEMY AND FAIRY

.COLSKIP    MOVE.W  PL2POSX, D0
            MOVE.W  PL2POSY, D1
            MOVE.W  D0, D2
            ADD.W   #16*PXLX, D2
            MOVE.W  D1, D3
            ADD.W   #16*PXLX, D3

            JSR     ENMCOL
            
            TST.B   D0
            BEQ     .END                    ; NO COLLISION WITH WITCH

            TST.B   PLYMODE                 ; CHECK PLAYER MODE (DODGE/ATTACK)
            BNE     .ATTACK

            TST.B   PL2DMGCD                ; CANNOT DAMAGE DURING COOLDOWN
            BNE     .END

            SUBQ.B  #1, PLYHP
            MOVE.B  #PLYDMGCD, PL2DMGCD

            MOVEQ   #72, D0
            MOVE.B  #1, D1                  ; PLAY HURT SOUND
            TRAP    #15

.END        MOVE.W  (SP)+, D0               ; RESTORE VALUE IN D0
            RTS

.KILL   ; KILL ENEMY AND FINISH

            MOVE.W  (SP)+, D0
            LEA     ENMHP, A0
            CLR.B   (A0, D0)
            RTS

.ATTACK ; ENEMY KILLED WHEN PLAYER TOUCHES IT

            SUBQ.B  #1, PLYPNT              ; DECREMENT POINTS NEEDED TO WIN
            BRA     .KILL

; ------------------------------------------------------------------------------
ENMCOL
; CHECK ENEMY COLLISION WITH A PLAYER.
; INPUT    : D0.W-D3.W: PLAYER RECTANGLE, D4.W-D7.W: ENEMY RECTANGLE
;            RECTANGLES ARE DEFINED BY X0, Y0, X1, Y1.
;            X0 AND Y0 ARE THE UPPER LEFT CORNER
;            WHILE X1 AND Y1 ARE THE LOWER RIGHT CORNER.
; OUTPUT   : D0.B SET IF COLLISION, 0 OTHERWISE.
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
; MODIFIES : D3, D6, D7, A3
; ------------------------------------------------------------------------------

            LEA     ENMHP, A3
            TST.B   (A3, D0)
            BEQ     .END                    ; DO NOT DRAW IF DEAD

            MOVE.W  D0, -(SP)

            CLR.W   D3

            LEA     ENMTILE, A3
            MOVE.B  (A3, D0), D3            ; ENEMY TILE

            LSL.W   #1, D0                  ; MULTIPLY BY 2 (WORD TO BYTE)

            LEA     ENMPOSX, A3
            MOVE.W  (A3, D0), D6            ; ENEMY POS X

            LEA     ENMPOSY, A3
            MOVE.W  (A3, D0), D7            ; ENEMY POS Y

            LSR.W   #1, D0                  ; DIVIDE BY 2 (BACK TO BYTE)

            LEA     ENMTYPE, A3
            MOVE.B  (A3, D0), D0            ; ENEMY TYPE

            LSL.W   #2, D0                  ; MULTIPLY BY 4 (LONG TO BYTE)

            LEA     ENMEIPOS, A3
            MOVEA.L (A3, D0), A3

            JSR     GFXEIPLT

            MOVE.W  (SP)+, D0               ; RESTORE VALUE IN D0
.END        RTS
