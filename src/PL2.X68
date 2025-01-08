; ==============================================================================
; PLAYER 2 (FAIRY) MANAGEMENT
; ==============================================================================

            OPT     MEX

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
            CMPI.B  #8, D0
            BEQ     .TUT
            
            ; REGULAR LEVEL

            MOVE.W  #PL2REGX, PL2POSX       ; RESET COORDINATE X
            MOVE.W  #PLYREGY, PL2POSY       ; RESET COORDINATE Y
            MOVE.B  #3, PL2TILE             ; RESET SPRITE NUMBER (UP STOPPED)
            MOVE.B  #1, PL2DIR              ; RESET LOOKING AT DIRECTION (UP)
            BRA     .COMMON

.TITLE      ; TITLE SCREEN

            MOVE.W  #PL2TITX, PL2POSX       ; RESET COORDINATE X
            MOVE.W  #PLYTITY, PL2POSY       ; RESET COORDINATE Y
            CLR.B   PL2TILE                 ; RESET SPRITE NUMBER (DOWN STOPPED)
            CLR.B   PL2DIR                  ; RESET LOOKING AT DIRECTION (DOWN)
            BRA     .COMMON

.TUT        ; TUTORIAL

            MOVE.W  #PLYTUTX, PL2POSX       ; RESET COORDINATE X
            MOVE.W  #PL2TUTY, PL2POSY       ; RESET COORDINATE Y
            CLR.B   PL2TILE                 ; RESET SPRITE NUMBER (DOWN STOPPED)
            CLR.B   PL2DIR                  ; RESET LOOKING AT DIRECTION (DOWN)
            BRA     .COMMON

.COMMON     CLR.W   PL2VELXY                ; RESET SPEED
            MOVE.W  #PLYDMGCD, PL2DMGCD     ; DAMAGE COOLDOWN

            RTS

; ------------------------------------------------------------------------------
PL2UPD
; UPDATES FAIRY.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : D0, D1, D2, D3
; ------------------------------------------------------------------------------

            MOVE.W  PL2POSX, D0             ; GET VALUE OF CURRENT X POS
            MOVE.W  PL2POSY, D1             ; GET VALUE OF CURRENT Y POS
            MOVE.B  PL2DIR, D2              ; GET DIRECTION LOOKING AT
            CLR.B   D3                      ; USED TO TELL IF PLAYER IS MOVING

            BTST.B  #KBTPL2UP, KBDVAL+1     ; CHECK UP
            BEQ     .NOUP

            SUB.W   #PL2SPEED, D1
            MOVE.B  #1, D2                  ; SET D2 = LOOKING UP
            MOVE.B  #1, D3                  ; SET D3 = MOVING

.NOUP       BTST.B  #KBTPL2DW, KBDVAL+1     ; CHECK DOWN
            BEQ     .NODOWN
            
            ADD.W   #PL2SPEED, D1
            CLR.B   D2                      ; CLEAR D2 = LOOKING DOWN
            MOVE.B  #1, D3                  ; SET D3 = MOVING

.NODOWN     BTST.B  #KBTPL2LF, KBDVAL+1     ; CHECK LEFT
            BEQ     .NOLEFT
            
            SUB.W   #PL2SPEED, D0
            MOVE.B  #1, D3                  ; SET D3 = MOVING

.NOLEFT     BTST.B  #KBTPL2RG, KBDVAL+1     ; CHECK RIGHT
            BEQ     .NORIGHT
            
            ADD.W   #PL2SPEED, D0
            MOVE.B  #1, D3                  ; SET D3 = MOVING

.NORIGHT

            TST.B   D3
            BEQ     .NOMOVE                 ; NO MOVEMENT IF D3 IS CLEARED

        ; CHECK IF OUT OF BOUNDS AND CORRECT POSITION

            RANG.W  D0, #0, #SPNSTART, #16*PXLX
            RANG.W  D1, #0, #SCRHEIGH, #16*PXLY

            MOVE.W  D0, PL2POSX             ; SET VALUE OF X POS
            MOVE.W  D1, PL2POSY             ; SET VALUE OF Y POS

        ; ANIMATE

            TST.B   D2
            BEQ    .ANIMDW

            MOVE.B  #4, D3                  ; TILE = 4: ANIMATED UP FIRST
            BRA     .ANIMTIM

.ANIMDW     MOVE.B  #1, D3                  ; TILE = 1: ANIMATED DOWN FIRST

.ANIMTIM    BTST.B  #2, FRMCNT
            BEQ     .ANIMEND

            ADDQ.B  #1, D3                  ; SECOND FRAME

.ANIMEND    MOVE.B  D3, PL2TILE             ; SET TILE
            MOVE.B  D2, PL2DIR              ; SAVE DIRECTION
            RTS

.NOMOVE     TST.B   D2
            BEQ     .STATDW

            MOVE.B  #3, PL2TILE             ; TILE = 3: LOOK UP NO MOVEMENT
            RTS

.STATDW     CLR.B   PL2TILE                 ; TILE = 0: LOOK DOWN NO MOVEMENT
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
