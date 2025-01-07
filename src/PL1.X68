; ==============================================================================
; PLAYER 1 (WITCH) MANAGEMENT
; ==============================================================================

            OPT     MEX

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
            MOVE.B  #3, PL1TILE             ; RESET SPRITE NUMBER (UP STOPPED)
            MOVE.B  #1, PL1DIR              ; RESET LOOKING AT DIRECTION (UP)
            BRA     .COMMON

.TITLE      ; TITLE SCREEN

            MOVE.W  #PL1TITX, PL1POSX       ; RESET COORDINATE X
            MOVE.W  #PLYTITY, PL1POSY       ; RESET COORDINATE Y
            CLR.B   PL1TILE                 ; RESET SPRITE NUMBER (DOWN STOPPED)
            CLR.B   PL1DIR                  ; RESET LOOKING AT DIRECTION (DOWN)
            BRA     .COMMON

.TUT        ; TUTORIAL

            MOVE.W  #PLYTUTX, PL1POSX       ; RESET COORDINATE X
            MOVE.W  #PL1TUTY, PL1POSY       ; RESET COORDINATE Y
            CLR.B   PL1TILE                 ; RESET SPRITE NUMBER (DOWN STOPPED)
            CLR.B   PL1DIR                  ; RESET LOOKING AT DIRECTION (DOWN)
            BRA     .COMMON

.COMMON     CLR.W   PL1VELXY                ; RESET SPEED

            RTS
            
; ------------------------------------------------------------------------------
PL1UPD
; UPDATE WITCH.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : D0, D1, D2, D3
; ------------------------------------------------------------------------------

            MOVE.W  PL1POSX, D0             ; GET VALUE OF CURRENT X POS
            MOVE.W  PL1POSY, D1             ; GET VALUE OF CURRENT Y POS
            MOVE.B  PL1DIR, D2              ; GET DIRECTION LOOKING AT
            CLR.B   D3                      ; USED TO TELL IF PLAYER IS MOVING

            BTST.B  #KBTPL1UP, KBDVAL+1     ; CHECK UP
            BEQ     .NOUP

            SUB.W   #PL1SPEED, D1
            MOVE.B  #1, D2                  ; SET D2 = LOOKING UP
            MOVE.B  #1, D3                  ; SET D3 = MOVING

.NOUP       BTST.B  #KBTPL1DW, KBDVAL+1     ; CHECK DOWN
            BEQ     .NODOWN
            
            ADD.W   #PL1SPEED, D1
            CLR.B   D2                      ; CLEAR D2 = LOOKING DOWN
            MOVE.B  #1, D3                  ; SET D3 = MOVING

.NODOWN     BTST.B  #KBTPL1LF, KBDVAL+1     ; CHECK LEFT
            BEQ     .NOLEFT
            
            SUB.W   #PL1SPEED, D0
            MOVE.B  #1, D3                  ; SET D3 = MOVING

.NOLEFT     BTST.B  #KBTPL1RG, KBDVAL+1     ; CHECK RIGHT
            BEQ     .NORIGHT
            
            ADD.W   #PL1SPEED, D0
            MOVE.B  #1, D3                  ; SET D3 = MOVING

.NORIGHT

            TST.B   D3
            BEQ     .NOMOVE                 ; NO MOVEMENT IF D3 IS CLEARED

        ; CHECK IF OUT OF BOUNDS AND CORRECT POSITION

            RANG.W  D0, #0, #SPNSTART, #16*PXLX
            RANG.W  D1, #0, #SCRHEIGH, #16*PXLY

            MOVE.W  D0, PL1POSX             ; SET VALUE OF X POS
            MOVE.W  D1, PL1POSY             ; SET VALUE OF Y POS

        ; ANIMATE

            TST.B   D2
            BEQ    .ANIMDW

            MOVE.B  #4, D3                  ; TILE = 4: ANIMATED UP FIRST
            BRA     .ANIMTIM

.ANIMDW     MOVE.B  #1, D3                  ; TILE = 1: ANIMATED DOWN FIRST

.ANIMTIM    BTST.B  #2, FRMCNT
            BEQ     .ANIMEND

            ADDQ.B  #1, D3                  ; SECOND FRAME

.ANIMEND    MOVE.B  D3, PL1TILE             ; SET TILE
            MOVE.B  D2, PL1DIR              ; SAVE DIRECTION
            RTS

.NOMOVE     TST.B   D2
            BEQ     .STATDW

            MOVE.B  #3, PL1TILE             ; TILE = 3: LOOK UP NO MOVEMENT
            RTS

.STATDW     CLR.B   PL1TILE                 ; TILE = 0: LOOK DOWN NO MOVEMENT
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
