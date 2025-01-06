; ==============================================================================
; SIDE PANEL MANAGEMENT
; ==============================================================================
            
; ------------------------------------------------------------------------------
SPNINIT
; INITIALIZE SCOREBOARD
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            RTS
            
; ------------------------------------------------------------------------------
SPNPLOT
; PLOT THE SCOREBOARD
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : D0-D4, A0-A2
; ------------------------------------------------------------------------------
            
        ; FILL PANEL AREA WITH CLEAR COLOR
        ; THIS IS DONE TO PREVENT ENEMIES FROM SHOWING BEHIND
        
            MOVE.L  #SCRBACK, D1
            
            MOVEQ   #80, D0                 ; PEN COLOR TO CLEAR COLOR
            TRAP    #15

            MOVEQ   #81, D0                 ; FILL COLOR TO CLEAR COLOR
            TRAP    #15

            MOVEQ   #87, D0
            MOVE.W  #SPNSTART, D1           ; X0
            CLR.W   D2                      ; Y0
            MOVE.W  #SCRWIDTH, D3           ; X1
            MOVE.W  #SCRHEIGH, D4           ; Y1
            TRAP    #15

        ; DECORATIVE BORDER

            MOVEQ   #80, D0
            MOVE.L  #$00FFFFFF, D1          ; PEN COLOR TO WHITE
            TRAP    #15

            MOVEQ   #93, D0
            MOVEQ   #3, D1                  ; SET PEN WIDTH TO 3
            TRAP    #15
            
            MOVEQ   #87, D0
            MOVE.W  #SPNSTART+SPNMARGN, D1  ; X0
            ADD.W   #SPNMARGN, D2           ; Y0
            SUB.W   #SPNMARGN, D3           ; X1
            SUB.W   #SPNMARGN, D4           ; Y1
            TRAP #15

        ; DISPLAY TEXTS

            MOVE.W  #2, D2
            LEA     TXTLVLP, A0             ; GET ADDRESS OF FIRST TEXT
            LEA     TXTLIST+28, A2          ; GET TEXT LIST ADDRESS

.LOOP       MOVEQ   #11, D0
            MOVE.W  (A0)+, D1               ; SET TEXT POSITION
            TRAP    #15

            CLR.L   D1                      ; THE NUMBER MUST BE SET TO D1.L

            CMPI.W  #2, D2
            BEQ     .LEVEL
            CMPI.W  #1, D2
            BEQ     .TIMER
            CMPI.W  #0, D2
            BEQ     .HP

.LEVEL      MOVE.B  LVLINDEX, D1
            ADDQ.W  #1, D1                  ; LEVEL INDEXES START AT 0
            BRA     .CONT
            
.TIMER      MOVE.B  LVLTIMER, D1
            BRA     .CONT

.HP         MOVE.B  PLYHP, D1
            BRA     .CONT
            
.CONT       MOVEQ   #17, D0
            MOVEA.L (A2)+, A1             
            TRAP    #15                     ; DRAW LEVEL STRING + LVL INDEX

            DBRA    D2, .LOOP

        ; RESTORE PEN WIDTH

            MOVEQ   #93, D0
            MOVEQ   #1, D1
            TRAP    #15
            
            RTS
