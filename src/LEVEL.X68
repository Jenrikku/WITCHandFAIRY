; ==============================================================================
; LEVEL MANAGEMENT
; ==============================================================================

; ------------------------------------------------------------------------------
LVLSWTCH
; SWITCHES TO ANOTHER LEVEL.
; INPUT    : D0 = LVLNO 
; OUTPUT   : NONE
; MODIFIES : D0, A1, A3
; ------------------------------------------------------------------------------

            MOVE.B  D0, LVLINDEX

        ; RESET COUNTERS:

            CLR.W   LVLCLCNT
            CLR.W   LVLTSCNT
            CLR.W   LVLMPCNT
            CLR.W   LVLEICNT

        ; READ BTM FILE:
        
            LSL.W   #2, D0                  ; MULTIPLY BY 4 (LONG TO BYTE)
            LEA     LVLLIST, A1
            ADDA.W  D0, A1
            MOVE.L  (A1), A1                ; READ ADDRESS FROM MEMORY

            JSR     BTMREAD

            MOVE.L  A3, LVLEIPOS
            
            RTS

; ------------------------------------------------------------------------------
LVLPLOT
; PLOTS THE CURRENT LEVEL MAP.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0, D1, D2, D3, D6, D7, A1, A3
; ------------------------------------------------------------------------------
            
            MOVEQ   #LVLWIDTH-1, D0
            MOVEQ   #LVLHEIGH-1, D1

            MOVE.L  LVLEIPOS, A3

            CLR.W   D2                      ; CURRENT TILE INDEX
            CLR.W   D6                      ; X
            CLR.W   D7                      ; Y

.LOOP
            BUFAT   MP, D2, A1
            MOVE.B  (A1), D3                ; GET TILENO FROM MEMORY

            JSR     GFXEIPLT

            ADDQ.W  #1, D2                  ; NEXT TILE
            ADD.W   #$10*3, D6              ; GO RIGHT (+X)
            DBRA    D0, .LOOP

            MOVEQ   #LVLWIDTH-1, D0         ; RESTORE WIDTH
            CLR.W   D6                      ; GO BACK TO START (X = 0)
            ADD.W   #$10*3, D7              ; GO DOWN (+Y)
            DBRA    D1, .LOOP
            
            RTS

