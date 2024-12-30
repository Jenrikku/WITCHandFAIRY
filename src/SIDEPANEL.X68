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
; MODIFIES : D0-D4
; ------------------------------------------------------------------------------
            
        ; FILL PANEL AREA WITH BLACK
        
            CLR.L   D1
            
            MOVEQ   #80, D0                 ; PEN COLOR TO BLACK
            TRAP    #15

            MOVEQ   #81, D0                 ; FILL COLOR TO BLACK
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

        ; RESTORE PEN WIDTH

            MOVEQ   #93, D0
            MOVEQ   #1, D1
            TRAP    #15
            
            RTS
