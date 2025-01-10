; ==============================================================================
; PLAYER MANAGEMENT - UNIFIES PL1 AND PL2 SUBROUTINES + EXTRA CHECKS
; ==============================================================================

; ------------------------------------------------------------------------------
PLYINIT
; INITIALIZES PLAYERS.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : A1, A3
; ------------------------------------------------------------------------------

            JSR     PL1INIT
            JSR     PL2INIT
            RTS

; ------------------------------------------------------------------------------
PLYRESET
; RESETS PLAYER VARIABLES.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0
; ------------------------------------------------------------------------------

            MOVE.B  LVLINDEX, D0            ; GET CURRENT LEVEL INDEX

            JSR     PL1RESET
            JSR     PL2RESET

            CMPI.W  #LVLLAST, D0
            SLE     PLYMOVE                 ; ONLY ALLOW MOVEMENT IN REGULAR LVL

            MOVE.B  #PLYINIHP, PLYHP        ; SET SHARED PLAYERS HP

            TST.B   MODEASY
            BEQ     .NOEASY                 ; CHECK IF EASY MODE IS ENABLED

            MOVE.B  #PLYESYHP, PLYHP        ; SET SHARED PLAYERS HP (EASY)

.NOEASY     RTS

; ------------------------------------------------------------------------------
PLYUPD
; UPDATES THE PLAYERS
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0, D1, D2, D3
; ------------------------------------------------------------------------------
            
            TST.B   PLYMOVE                 ; CHECK IF PLAYER CAN MOVE
            BEQ     .NOMOVE                 ; PREVENTS PLAYER MOVEMENT (NO UPD)

            JSR     PL1UPD
            JSR     PL2UPD
.NOMOVE     RTS

; ------------------------------------------------------------------------------
PLYPLOT
; PLOT PLAYERS.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D3, D6, D7, A3
; ------------------------------------------------------------------------------

            JSR     PL1PLOT
            JSR     PL2PLOT
            RTS
