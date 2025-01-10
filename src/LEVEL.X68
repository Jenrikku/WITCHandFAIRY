; ==============================================================================
; LEVEL MANAGEMENT
; ==============================================================================

; ------------------------------------------------------------------------------
LVLSWTCH
; SWITCHES TO ANOTHER LEVEL. PLAYS AN ANIMATION FOR REGULAR LEVELS.
; INPUT    : D0.W = LVLNO
; OUTPUT   : NONE
; MODIFIES : D0, A1, A2, A3
; ------------------------------------------------------------------------------

            MOVE.B  #LVLTIME, LVLTIMER      ; RESET TIMER COUNTDOWN
            MOVE.B  D0, LVLINDEX

            CMPI.B  #LVLLAST, D0            ; IF LEVEL IS SPECIAL
            SLE     LVLCHANG                ; TELL THAT LEVEL IS CHANGING

            CMPI.B  #LVLMAX, D0             ; IF THE INDEX OVERFLOWS
            BHI     .NOREAD                 ; NO LEVEL IS READ

            JSR     LVLREAD                 ; READ MAP AND ENEMIES
.NOREAD     JSR     PLYRESET                ; PLAYER RESET (LEVEL-DEPENDENT)
            JSR     ENMRESET                ; ENEMY RESET (LEVEL-INDEPENDENT)
            JSR     SPNRESET                ; SIDE PANEL RESET

            RTS


; ------------------------------------------------------------------------------
LVLREAD
; READS THE LEVEL FROM THE BTM FILES. MEANT TO BE CALLED BY ANOTHER SUBROUTINE.
; INPUT    : D0.W = LVLNO
; OUTPUT   : NONE
; MODIFIES : D0, A1, A2, A3
; ------------------------------------------------------------------------------

        ; RESET COUNTERS:

            CLR.W   LVLCLCNT
            CLR.W   LVLTSCNT
            CLR.W   LVLMPCNT
            CLR.W   LVLEICNT

        ; READ MAP BTM FILE:
        
            LSL.W   #2, D0                  ; MULTIPLY BY 4 (LONG TO BYTE)
            LEA     LVLLIST, A1
            MOVE.L  (A1, D0), A1            ; GET STRING ADDRESS FROM MEMORY

            JSR     BTMREAD                 ; READ MAP
            MOVE.L  A3, LVLEIPOS

            CMPI.W  #LVLLAST*4, D0          ; IF LEVEL IS SPECIAL
            BHI     .END                    ; DO NOT READ ENEMIES

        ; READ ENEMY BTM FILES:
            
            LSL.W   #1, D0                  ; EVERY LEVEL HAS 2 ENEMIES: D0 * 2
            LEA     ENMLIST, A2
            MOVE.L  (A2, D0), A1            ; GET ENEMY 1 ADDRESS FROM MEMORY

            JSR     BTMREAD                 ; READ ENEMY 1
            MOVE.L  A3, ENMEIPOS

            MOVE.L  4(A2, D0), A1           ; GET ENEMY 2 ADDRESS FROM MEMORY

            JSR     BTMREAD                 ; READ ENEMY 2
            MOVE.L  A3, ENMEIPOS+4          ; PUT EI INTO 2ND ITEM IN ARRAY
                        
.END        RTS

; ------------------------------------------------------------------------------
LVLUPD
; DEPENDING ON THE LEVEL, WAITS FOR INPUT AND CHANGES THE LEVEL.
; 6 -> TITLE
; 7 -> GAME OVER
; 8 -> TUTORIAL
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0, A1-A3
; ------------------------------------------------------------------------------

            CLR.W   D0
            MOVE.B  LVLINDEX, D0

            CMPI.B  #5, D0
            BEQ     .WIN
            CMPI.B  #6, D0
            BEQ     .TITLE
            CMPI.B  #7, D0
            BEQ     .GAMOVER
            CMPI.B  #8, D0
            BEQ     .TUT

            CMPI.B  #LVLMAX, D0
            BLO     .REGULAR

.END        RTS

.REGULAR    ; REGULAR LEVELS

            TST.B   PLYHP
            BNE     .HEALTHY

            MOVE.B  #7, D0
            JSR     LVLSWTCH                ; GO TO GAME OVER

.HEALTHY    TST.B   PLYPNT                  ; CHECK IF THERE ARE POINTS REMAING
            BNE     .END                    ; LEVEL NOT CLEARED YET

            ADDQ.B  #1, D0
            JSR     LVLSWTCH                ; GO TO NEXT LEVEL

            RTS
            
.WIN        ; WIN MAP (YOU WIN)

            MOVEQ   #72, D0
            MOVE.B  #3, D1                  ; PLAY WIN SOUND
            TRAP    #15

            RTS

.TITLE      ; TITLE SCREEN

            BTST.B   #KBTCONT, KBDEDGE
            BEQ     .END

            MOVEQ   #72, D0
            MOVE.B  #0, D1                  ; PLAY ENTER SOUND
            TRAP    #15

            MOVEQ   #8, D0                  ; GO TO TUTORIAL SCREEN
            JSR     LVLSWTCH

            RTS

.GAMOVER    ; GAME OVER (HP DEPLEATED)

            MOVEQ   #72, D0
            MOVE.B  #2, D1                  ; PLAY LOSE SOUND
            TRAP    #15

            BTST.B   #KBTCONT, KBDEDGE
            BEQ     .END

            MOVEQ   #72, D0
            MOVE.B  #0, D1                  ; PLAY ENTER SOUND
            TRAP    #15

            MOVEQ   #6, D0                  ; GO TO TITLE SCREEN
            JSR     LVLSWTCH

            RTS

.TUT        ; TUTORIAL

            BTST.B   #KBTCONT, KBDEDGE
            BEQ     .END

            MOVEQ   #72, D0
            MOVE.B  #0, D1                  ; PLAY ENTER SOUND
            TRAP    #15

            CLR.W   D0                      ; GO TO FIRST LEVEL
            JSR     LVLSWTCH
            
            RTS

; ------------------------------------------------------------------------------
LVLPLOT
; PLOTS THE CURRENT LEVEL MAP.
; INPUT    : D6 = X DISPLACEMENT, D7 = Y DISPLACEMENT
; OUTPUT   : NONE
; MODIFIES : D0, D1, D2, D3, D6, D7, A1, A3
; ------------------------------------------------------------------------------
            
            CMPI.B  #LVLMAX, LVLINDEX       ; IF THE INDEX OVERFLOWS
            BHI     .END                    ; NO LEVEL IS DRAWN

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
            ADD.W   #$10*PXLX, D6           ; GO RIGHT (+X)
            DBRA    D0, .LOOP

            MOVEQ   #LVLWIDTH-1, D0         ; RESTORE WIDTH
            SUB.W   #$10*10*PXLX, D6        ; GO BACK TO START (X = 0)
            ADD.W   #$10*PXLY, D7           ; GO DOWN (+Y)
            DBRA    D1, .LOOP
            
.END        RTS

; ------------------------------------------------------------------------------
LVLTEXT
; DISPLAYS SOME TEXT BASED ON THE LEVEL. (SPECIAL LEVELS ONLY)
; 5 -> END
; 6 -> TITLE
; 7 -> GAME OVER
; 8 -> TUTORIAL
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0, D1, D2, A0, A1, A2
; ------------------------------------------------------------------------------

            MOVE.B  LVLINDEX, D0

            CMPI.B  #6, D0
            BEQ     .TITLE
            CMPI.B  #7, D0
            BEQ     .TITLE
            CMPI.B  #8, D0
            BEQ     .TUT

            RTS

.TITLE      ; TITLE SCREEN

            MOVEQ   #11, D0
            MOVE.W  TXTCONTP, D1            ; SET TEXT POSITION
            TRAP    #15

            MOVEQ   #14, D0
            LEA     TXTCONT, A1             ; DISPLAY 'PRESS ENTER'
            TRAP    #15

            RTS

.TUT        ; TUTORIAL

            MOVEQ   #5, D2                  ; USED FOR DBRA

            LEA     TXTTUT1P, A0            ; GET FIRST TEXT POS ADDRESS
            LEA     TXTLIST+4, A2           ; GET TEXT LIST (FIRST INDEX)

.TUTLOOP    MOVEQ   #11, D0
            MOVE.W  (A0)+, D1
            TRAP    #15                     ; SET TEXT POSITION

            MOVEQ   #14, D0
            MOVEA.L (A2)+, A1
            TRAP    #15                     ; DISPLAY TEXT

            DBRA    D2, .TUTLOOP

            BRA     .TITLE                  ; THEY BOTH SHARE 'PRESS ENTER'

; ------------------------------------------------------------------------------
LVLTRANS
; SETS UP AND PLAYS A TRANSITION ANIMATION FOR LEVEL SWITCHING.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0-D2, A1
; ------------------------------------------------------------------------------
            
            JSR     TIMSTOP                 ; STOP CURRENT TIMERS

            MOVEQ   #21, D0
            MOVE.L  #TXTCOLOR, D1
            MOVE.L  #TXTFONTB, D2           ; SET FONT TO BIG
            TRAP    #15

            MOVEQ   #11, D0
            MOVE.W  TXTNLVLP, D1            ; SET TEXT POSITION
            TRAP    #15

            MOVEQ   #17, D0
            CLR.L   D1
            MOVE.B  LVLINDEX, D1
            ADDQ.W  #1, D1                  ; LEVEL INDEXES START AT 0
            LEA     TXTLVL, A1             
            TRAP    #15                     ; DRAW NEW LEVEL STRING + LVL INDEX

            MOVEQ   #94, D0
            TRAP    #15                     ; REPAINT SCREEN (DOUBLE BUFFER)

            MOVEQ   #23, D0
            MOVE.L  #150, D1
            TRAP    #15                     ; SLEEP FOR 1.5 SECONDS

            CLR.B   LVLCHANG                ; LEVEL IS NO LONGER CHANGING

            JSR     TXTRESET                ; RESET TO DEFAULT FONT
            JSR     TIMINIT                 ; RE-ENABLE TIMERS
            
            RTS
