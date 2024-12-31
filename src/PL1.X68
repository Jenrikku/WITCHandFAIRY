; ==============================================================================
; PLAYER 1 (WITCH) MANAGEMENT
; ==============================================================================
            
; ------------------------------------------------------------------------------
PL1INIT
; INITIALIZE WITCH.
; INPUT    : NONE 
; OUTPUT   : NONE 
; MODIFIES : A1, A3
; ------------------------------------------------------------------------------

        ; READ BTM FILE:

            LEA     BTMPL1, A1
            JSR     BTMREAD

            MOVE.L  A3, PL1EIPOS
            
            RTS

; ------------------------------------------------------------------------------
PL1RESET
; RESETS WITCH VARIABLES.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            CMPI.B  #6, LVLINDEX
            BEQ     .TITLE
            
            MOVE.W  #PL1REGX, PL1POSX       ; RESET COORDINATE X (REGULAR)
            MOVE.W  #PLYREGY, PL1POSY       ; RESET COORDINATE Y (REGULAR)
            MOVE.B  #3, PL1TILE             ; RESET SPRITE NUMBER
            BRA     .COMMON

.TITLE      MOVE.W  #PL1TITX, PL1POSX       ; RESET COORDINATE X (TITLE)
            MOVE.W  #PLYTITY, PL1POSY       ; RESET COORDINATE Y (TITLE)
            CLR.B   PL1TILE                 ; RESET SPRITE NUMBER
            BRA     .COMMON

.COMMON     CLR.W   PL1VELXY                ; RESET SPEED

            RTS
            
; ------------------------------------------------------------------------------
PL1UPD
; UPDATE WITCH.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            TST.B   PLYMOVE                 ; CHECK IF PLAYER CAN MOVE
            BEQ     .NOMOVE                 ; PREVENTS PLAYER MOVEMENT

            MOVEM.W D0/D1, -(SP)

            ; UPDATE COORDINATE
            MOVE.W  PL1POSX, D0
            MOVE.W  PL1POSY, D1

            BTST.B  #KBTPL1UP, KBDVAL       ; CHECK UP
            BNE     .NOUP

            ADD.W   #PL1SPEED, D1

.NOUP       BTST.B  #KBTPL1DW, KBDVAL       ; CHECK DOWN
            BNE     .NODOWN
            
            SUB.W   #PL1SPEED, D1

.NODOWN     BTST.B  #KBTPL1LF, KBDVAL       ; CHECK LEFT
            BNE     .NOLEFT
            
            ADD.W   #PL1SPEED, D0

.NOLEFT     BTST.B  #KBTPL1RG, KBDVAL       ; CHECK RIGHT
            BNE     .NORIGHT
            
            SUB.W   #PL1SPEED, D0

.NORIGHT    MOVE.W  D0, PL1POSX             ; UPDATE VARIABLE X
            MOVE.W  D1, PL1POSY             ; UPDATE VARIABLE Y

            MOVEM.W (SP)+, D0/D1

.NOMOVE     RTS

; ------------------------------------------------------------------------------
PL1PLOT
; PLOT WITCH.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : D3, D6, D7, A3
; ------------------------------------------------------------------------------
            
            CLR.W   D3
            MOVE.B  PL1TILE, D3
            MOVE.W  PL1POSX, D6
            MOVE.W  PL1POSY, D7
            MOVEA.L PL1EIPOS, A3

            JSR     GFXEIPLT

            RTS
