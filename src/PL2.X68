; ==============================================================================
; PLAYER 2 (FAIRY) MANAGEMENT
; ==============================================================================
            
; ------------------------------------------------------------------------------
PL2INIT
; INITIALIZE FAIRY.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : A1, A3
; ------------------------------------------------------------------------------
            
        ; READ BTM FILE:

            LEA     BTMPL2, A1
            JSR     BTMREAD

            MOVE.L  A3, PL2EIPOS
            
            RTS
            
; ------------------------------------------------------------------------------
PL2UPD
; UPDATES FAIRY.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.W D0/D1, -(SP)

            ; UPDATE COORDINATE
            MOVE.W  PL2POSX, D0
            MOVE.W  PL2POSY, D1

            BTST.B  #KBTPL2UP, KBDVAL       ; CHECK UP
            BNE     .NOUP

            ADD.W   #PL2SPEED, D1

.NOUP       BTST.B  #KBTPL2DW, KBDVAL       ; CHECK DOWN
            BNE     .NODOWN
            
            SUB.W   #PL2SPEED, D1

.NODOWN     BTST.B  #KBTPL2LF, KBDVAL       ; CHECK LEFT
            BNE     .NOLEFT
            
            ADD.W   #PL2SPEED, D0

.NOLEFT     BTST.B  #KBTPL2RG, KBDVAL       ; CHECK RIGHT
            BNE     .NORIGHT
            
            SUB.W   #PL2SPEED, D0

.NORIGHT    MOVE.W  D0, PL2POSX             ; UPDATE VARIABLE X
            MOVE.W  D1, PL2POSY             ; UPDATE VARIABLE Y

            MOVEM.W (SP)+, D0/D1

            RTS
            
; ------------------------------------------------------------------------------
PL2PLOT
; PLOT FAIRY.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : D3, D6, D7, A3
; ------------------------------------------------------------------------------

            CLR.W   D3
            MOVE.B  PL2TILE, D3
            MOVE.W  PL2POSX, D6
            MOVE.W  PL2POSY, D7
            MOVEA.L PL2EIPOS, A3

            JSR     GFXEIPLT

            RTS
