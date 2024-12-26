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
PL1UPDY
; UPDATE WITCH.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVE.W  D0,-(A7)

            ; UPDATE COORDINATE
            MOVE.W  (PL1POSY),D0
            BTST.B  #1,(KBDVAL)
            BEQ     .CHKDWN
            SUB.W   #PL1SPEED, D0

.CHKDWN     
            BTST.B  #3,(KBDVAL)     
            ADD.W   #PL1SPEED,D0

            ; UPDATE VARIABLE 
.DONE       MOVE.W  D0,(PL1POSY)

            MOVE.W  (A7)+,D0

            RTS 

; ------------------------------------------------------------------------------
PL1UPDX
; UPDATE WITCH.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVE.W  D1,-(A7)

            ; UPDATE COORDINATE
            MOVE.W  (PL1POSX),D1
            BTST.B  #1,(KBDVAL)
            BEQ     .CHKRGH
            SUB.W   #PL1SPEED, D1

.CHKRGH     
            BTST.B  #2,(KBDVAL)     
            ADD.W   #PL1SPEED,D1

            ; UPDATE VARIABLE 
.DONE       MOVE.W  D1,(PL1POSX)

            MOVE.W  (A7)+,D1

            RTS 

; ------------------------------------------------------------------------------
PL1PLOT
; PLOT WITCH.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            CLR.W   D3
            MOVE.B  PL1TILE, D3
            MOVE.W  PL1POSX, D6
            MOVE.W  PL1POSY, D7
            MOVEA.L PL1EIPOS, A3

            JSR     GFXEIPLT

            RTS
