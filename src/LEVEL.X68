; ==============================================================================
; LEVEL MANAGEMENT
; ==============================================================================

; ------------------------------------------------------------------------------
LVLSWTCH
; SWITCHES TO ANOTHER LEVEL.
; INPUT    : D0.W = LVLNO
; OUTPUT   : NONE
; MODIFIES : D0, A1, A2, A3
; ------------------------------------------------------------------------------

            MOVE.B  D0, LVLINDEX

        ; RESET COUNTERS:

            CLR.W   LVLCLCNT
            CLR.W   LVLTSCNT
            CLR.W   LVLMPCNT
            CLR.W   LVLEICNT

            CMPI.B  #7, D0                  ; IF THE INDEX OVERFLOWS
            BHI     .END                    ; NO LEVEL IS READ

        ; READ MAP BTM FILE:
        
            LSL.W   #2, D0                  ; MULTIPLY BY 4 (LONG TO BYTE)
            LEA     LVLLIST, A1
            MOVE.L  (A1, D0), A1            ; GET STRING ADDRESS FROM MEMORY

            JSR     BTMREAD
            MOVE.L  A3, LVLEIPOS

            CMPI.W  #4*4, D0
            BHI     .END                    ; CHECK IF IT'S A SPECIAL LEVEL

        ; READ ENEMY BTM FILES:
            
            LSL.W   #1, D0                  ; EVERY LEVEL HAS 2 ENEMIES: 2 LONGS
            LEA     ENMLIST, A2
            MOVE.L  (A2, D0), A1            ; GET ENEMY 1 ADDRESS FROM MEMORY

            JSR     BTMREAD
            MOVE.L  A3, ENMEIPOS

            MOVE.L  4(A2, D0), A1           ; GET ENEMY 2 ADDRESS FROM MEMORY

            JSR     BTMREAD
            MOVE.L  A3, ENMEIPOS+4
                        
.END        RTS

; ------------------------------------------------------------------------------
LVLPLOT
; PLOTS THE CURRENT LEVEL MAP.
; INPUT    : D6 = X DISPLACEMENT, D7 = Y DISPLACEMENT
; OUTPUT   : NONE
; MODIFIES : D0, D1, D2, D3, D6, D7, A1, A3
; ------------------------------------------------------------------------------
            
            MOVEQ   #LVLWIDTH-1, D0
            MOVEQ   #LVLHEIGH-1, D1

            MOVE.L  LVLEIPOS, A3

            CLR.W   D2                      ; CURRENT TILE INDEX
            CLR.W   D3                      ; TILENO

.LOOP
            BUFAT   MP, D2, A1
            MOVE.B  (A1), D3                ; GET TILENO FROM MEMORY

            JSR     GFXEIPLT

            ADDQ.W  #1, D2                  ; NEXT TILE
            ADD.W   #$10*3, D6              ; GO RIGHT (+X)
            DBRA    D0, .LOOP

            MOVEQ   #LVLWIDTH-1, D0         ; RESTORE WIDTH
            SUB.W   #$10*10*3, D6           ; GO BACK TO START (X = 0)
            ADD.W   #$10*3, D7              ; GO DOWN (+Y)
            DBRA    D1, .LOOP
            
            RTS

; ------------------------------------------------------------------------------
LVLTEXT
; DISPLAYS SOME TEXT BASED ON THE LEVEL. (SPECIAL LEVELS ONLY)
; 5 -> END
; 6 -> TITLE
; 7 -> GAME OVER
; 8 -> TUTORIAL
; INPUT    : D0.B = LVLINDEX
; OUTPUT   : NONE
; MODIFIES : D0, D1, A1
; ------------------------------------------------------------------------------

            CMPI.B  #5, D0
            BEQ     .END
            CMPI.B  #6, D0
            BEQ     .TITLE
            CMPI.B  #7, D0
            BEQ     .GAMOVER
            CMPI.B  #8, D0
            BEQ     .TUT

            RTS

.END        ; FINAL SCREEN (GAME CLEARED)
            RTS

.TITLE      ; TITLE SCREEN

            MOVEQ   #11, D0
            MOVE.W  #TXTANYKP, D1
            TRAP    #15

            MOVEQ   #14, D0
            LEA     TXTANYK, A1
            TRAP    #15

            RTS

.GAMOVER    ; GAME OVER (HP DEPLEATED)
            RTS

.TUT        ; TUTORIAL
            BRA     .TITLE                  ; THEY BOTH SHARE 'PRESS ANY KEY'