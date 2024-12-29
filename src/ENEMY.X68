; ==============================================================================
; ENEMY MANAGEMENT
; ==============================================================================
  
; ------------------------------------------------------------------------------
ENMRESET
; RESET ENEMIES VARIABLES.
; INPUT    : D0 = ENEMYNO
; OUTPUT   : NONE 
; MODIFIES : A1
; ------------------------------------------------------------------------------
            
            LSL.W   #1, D0                  ; MULTIPLY BY 2 (WORD TO BYTE)

            LEA     ENMPOSX, A1
            CLR.W   (A1, D0.W)
            
            LEA     ENMPOSY, A1
            CLR.W   (A1, D0.W)
            
            LEA     ENMVELXY, A1
            CLR.W   (A1, D0.W)

            LSR.W   #1, D0                  ; DIVIDE BY 2 (BACK TO BYTE)
            
            LEA     ENMTILE, A1
            CLR.B   (A1, D0.W)

            LEA     ENMTYPE, A1
            CLR.B   (A1, D0.W)

            LEA     ENMHP, A1
            CLR.B   (A1, D0.W)
            
            RTS

; ------------------------------------------------------------------------------
ENMUPD
; UPDATE ENEMY.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            RTS

; ------------------------------------------------------------------------------
ENMPLOT
; PLOT ENEMY.
; INPUT    : D0 = ENEMYNO
; OUTPUT   : NONE
; MODIFIES : D0, D3, D6, D7, A3
; ------------------------------------------------------------------------------
            
            CLR.W   D3

            LEA     ENMTILE, A3
            MOVE.B  (A3, D0.W), D3          ; ENEMY TILE

            LSL.W   #1, D0                  ; MULTIPLY BY 2 (WORD TO BYTE)

            LEA     ENMPOSX, A3
            MOVE.W  (A3, D0.W), D6          ; ENEMY POS X
            
            LEA     ENMPOSY, A3
            MOVE.W  (A3, D0.W), D7          ; ENEMY POS Y

            LSR.W   #1, D0                  ; DIVIDE BY 2 (BACK TO BYTE)

            LEA     ENMTYPE, A3
            MOVE.B  (A3, D0.W), D0          ; ENEMY TYPE

            LSL.W   #2, D0                  ; MULTIPLY BY 4 (LONG TO BYTE)

            LEA     ENMEIPOS, A3
            MOVEA.L (A3, D0.W), A3

            JSR     GFXEIPLT

            RTS
