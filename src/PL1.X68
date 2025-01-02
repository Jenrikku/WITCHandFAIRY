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
; INPUT    : D0.B = LVLINDEX 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            CMPI.B  #6, D0
            BEQ     .TITLE
            CMPI.B  #8, D0
            BEQ     .TUT
            
            ; REGULAR LEVEL

            MOVE.W  #PL1REGX, PL1POSX       ; RESET COORDINATE X
            MOVE.W  #PLYREGY, PL1POSY       ; RESET COORDINATE Y
            MOVE.B  #3, PL1TILE             ; RESET SPRITE NUMBER
            BRA     .COMMON

.TITLE      ; TITLE SCREEN

            MOVE.W  #PL1TITX, PL1POSX       ; RESET COORDINATE X
            MOVE.W  #PLYTITY, PL1POSY       ; RESET COORDINATE Y
            CLR.B   PL1TILE                 ; RESET SPRITE NUMBER
            BRA     .COMMON

.TUT        ; TUTORIAL

            MOVE.W  #PLYTUTX, PL1POSX       ; RESET COORDINATE X
            MOVE.W  #PL1TUTY, PL1POSY       ; RESET COORDINATE Y
            CLR.B   PL1TILE                 ; RESET SPRITE NUMBER
            BRA     .COMMON

.COMMON     CLR.W   PL1VELXY                ; RESET SPEED

            RTS
            
; ------------------------------------------------------------------------------
PL1UPD
; UPDATE WITCH.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : D0, D1
; ------------------------------------------------------------------------------

            MOVE.W  PL1POSX, D0             ; GET VALUE OF CURRENT X POS
            MOVE.W  PL1POSY, D1             ; GET VALUE OF CURRENT Y POS

            BTST.B  #KBTPL1UP, KBDVAL+1     ; CHECK UP
            BNE     .NOUP

            ADD.W   #PL1SPEED, D1

.NOUP       BTST.B  #KBTPL1DW, KBDVAL+1     ; CHECK DOWN
            BNE     .NODOWN
            
            SUB.W   #PL1SPEED, D1

.NODOWN     BTST.B  #KBTPL1LF, KBDVAL+1     ; CHECK LEFT
            BNE     .NOLEFT
            
            ADD.W   #PL1SPEED, D0

.NOLEFT     BTST.B  #KBTPL1RG, KBDVAL+1     ; CHECK RIGHT
            BNE     .NORIGHT
            
            SUB.W   #PL1SPEED, D0

.NORIGHT    MOVE.W  D0, PL1POSX             ; SET VALUE OF X POS
            MOVE.W  D1, PL1POSY             ; SET VALUE OF Y POS

            RTS

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
