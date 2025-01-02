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
PL2RESET
; RESETS FAIRY VARIABLES.
; INPUT    : D0.B = LVLINDEX 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            CMPI.B  #6, D0
            BEQ     .TITLE
            
            MOVE.W  #PL2REGX, PL2POSX       ; RESET COORDINATE X (REGULAR)
            MOVE.W  #PLYREGY, PL2POSY       ; RESET COORDINATE Y (REGULAR)
            MOVE.B  #3, PL2TILE             ; RESET SPRITE NUMBER
            BRA     .COMMON

.TITLE      MOVE.W  #PL2TITX, PL2POSX       ; RESET COORDINATE X (TITLE)
            MOVE.W  #PLYTITY, PL2POSY       ; RESET COORDINATE Y (TITLE)
            CLR.B   PL2TILE                 ; RESET SPRITE NUMBER
            BRA     .COMMON

.COMMON     CLR.W   PL2VELXY                ; RESET SPEED

            RTS

; ------------------------------------------------------------------------------
PL2UPD
; UPDATES FAIRY.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : D0, D1
; ------------------------------------------------------------------------------

            MOVE.W  PL2POSX, D0             ; GET VALUE OF CURRENT X POS
            MOVE.W  PL2POSY, D1             ; GET VALUE OF CURRENT Y POS

            BTST.B  #KBTPL2UP, KBDVAL+1     ; CHECK UP
            BNE     .NOUP

            ADD.W   #PL2SPEED, D1

.NOUP       BTST.B  #KBTPL2DW, KBDVAL+1     ; CHECK DOWN
            BNE     .NODOWN
            
            SUB.W   #PL2SPEED, D1

.NODOWN     BTST.B  #KBTPL2LF, KBDVAL+1     ; CHECK LEFT
            BNE     .NOLEFT
            
            ADD.W   #PL2SPEED, D0

.NOLEFT     BTST.B  #KBTPL2RG, KBDVAL+1     ; CHECK RIGHT
            BNE     .NORIGHT
            
            SUB.W   #PL2SPEED, D0

.NORIGHT    MOVE.W  D0, PL2POSX             ; SET VALUE OF X POS
            MOVE.W  D1, PL2POSY             ; SET VALUE OF Y POS

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
