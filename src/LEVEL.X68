; ==============================================================================
; LEVEL MANAGEMENT
; ==============================================================================

; ------------------------------------------------------------------------------
LVLSWTCH
; SWITCHES TO ANOTHER LEVEL.
; INPUT    : D0 = LVLNO 
; OUTPUT   : NONE
; MODIFIES : D0, A1, A2, A3
; ------------------------------------------------------------------------------

            MOVE.B  D0, LVLINDEX

        ; RESET COUNTERS:

            CLR.W   LVLCLCNT
            CLR.W   LVLTSCNT
            CLR.W   LVLMPCNT
            CLR.W   LVLEICNT

        ; READ MAP BTM FILE:
        
            LSL.W   #2, D0                  ; MULTIPLY BY 4 (LONG TO BYTE)
            LEA     LVLLIST, A1
            MOVE.L  (A1, D0), A1            ; GET STRING ADDRESS FROM MEMORY

            JSR     BTMREAD
            MOVE.L  A3, LVLEIPOS

            TST.W   D0
            BNE     .ENEMIES

            RTS

        ; READ ENEMY BTM FILES:
            
.ENEMIES    SUBQ    #4, D0                  ; ENEMY TABLE STARTS WITH LVL #1
            LSL.W   #1, D0                  ; EVERY LEVEL HAS 2 ENEMIES: 2 LONGS
            LEA     ENMLIST, A2
            MOVE.L  (A2, D0), A1            ; GET ENEMY 1 ADDRESS FROM MEMORY

            JSR     BTMREAD
            MOVE.L  A3, ENMEIPOS

            MOVE.L  4(A2, D0), A1           ; GET ENEMY 2 ADDRESS FROM MEMORY

            JSR     BTMREAD
            MOVE.L  A3, ENMEIPOS+2
                        
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

