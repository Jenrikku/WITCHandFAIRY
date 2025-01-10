; ==============================================================================
; TITLE       :
; DESCRIPTION :
; AUTHOR      :
; HISTORY     :
; ==============================================================================

            ORG     $1000
            
            INCLUDE "MACROS.X68"
            INCLUDE "SYSCONST.X68"
            INCLUDE "CONST.X68"
            INCLUDE "SYSTEM.X68"
            INCLUDE "PL1.X68"
            INCLUDE "PL2.X68"
            INCLUDE "PLAYER.X68"
            INCLUDE "SIDEPANEL.X68"
            INCLUDE "LEVEL.X68"
            INCLUDE "ENEMY.X68"
            INCLUDE "BTM.X68"
            INCLUDE "GFX.X68"
           
START

; --- INITIALIZATION -----------------------------------------------------------

            JSR     SYSINIT                 ; SYSTEM INIT
            JSR     PLYINIT                 ; PLAYER INIT

            MOVE.B  #1, BUFFMODE            ; SET BUFFER MODE TO LEVEL

            MOVEQ   #6, D0                  ; SET LEVEL INDEX TO TITLE SCREEN
            JSR     LVLSWTCH                ; SWITCH TO LEVEL IN D0

.LOOP

; --- UPDATE -------------------------------------------------------------------

; READ INPUT DEVICES

            TRAP    #1                      ; KEYBOARD

; UPDATE GAME LOGIC

            JSR     PLYUPD                  ; PLAYER UPDATE
            JSR     SPNUPD                  ; SIDE PANEL UPDATE

            CMPI.B  #LVLLAST, LVLINDEX
            BGT     .NOENM                  ; NO ENEMIES ON SPECIAL LEVELS

            JSR     ENMSPAWN                ; SPAWN LEVEL ENEMIES WHEN NEEDED

            MOVE.W  #ENMMAXNO-1, D0

.ENMUPDL    JSR     ENMUPD                  ; UPDATE ENEMY IN INDEX D0
            DBRA    D0, .ENMUPDL

.NOENM      JSR     LVLUPD                  ; WAIT FOR INPUT OR LEVEL WON

            CLR.B   TIMEDGE                 ; CLEAR SECONDS TIMER EDGE

; --- SYNC & FRAME SKIP --------------------------------------------------------

.SKIP       TST.W   FRMSKIP
            BEQ     .NOSKIP                 ; DO NOT SKIP NEXT FRAME

            SUBQ.W  #1, FRMSKIP             ; TELL THAT IT HAS BEEN SKIPPED
            BRA     .LOOP                   ; SKIP NEXT FRAME

.NOSKIP     BTST.B  #1, FRMSTATE
            BEQ     .SKIP                   ; WAIT FOR NEXT FRAME
            
            CLR.B   FRMSTATE                ; NEXT FRAME IS NOT READY

; --- PLOT ---------------------------------------------------------------------

            JSR     SCRCLEAR                ; CLEAR THE SCREEN WITH COLOR

            TST.B   LVLCHANG                ; CHECK IF LEVEL IS CHANGING
            BEQ     .NOTRANS

            JSR     LVLTRANS                ; SHOW TRANSITION ANIMATION

.NOTRANS    JSR     LVLTEXT                 ; DRAW TEXT DEPENDING ON THE LEVEL

            MOVEQ   #1, D4                  ; ENABLE OPTIMIZED GFX
            MOVE.W  #SPNWIDTH/2, D6         ; MAP X DISPLACEMENT

            CMPI.B  #LVLLAST, LVLINDEX
            BHI     .SPECIAL                ; CHECK IF LEVEL IS SPECIAL

            CLR.W   D4                      ; DISABLE OPTIMIZED GFX
            CLR.W   D6                      ; SET MAP X DISPLACEMENT TO 0

.SPECIAL    CLR.W   D7                      ; SET MAP Y DISPLACEMENT TO 0

            MOVE.B  #1, BUFFMODE            ; SET BUFFER MODE TO LEVEL
            JSR     LVLPLOT                 ; DRAW MAP

            CLR.B   BUFFMODE                ; SET BUFFER MODE TO STATIC

; DRAW ENTITIES

            JSR     PLYPLOT                 ; DRAW PLAYERS

            MOVE.B  #1, BUFFMODE            ; SET BUFFER MODE TO LEVEL

            CMPI.B  #LVLLAST, LVLINDEX      ; CHECK AGAIN IF LEVEL IS SPECIAL
            BHI     .SKIPENM                ; AND SKIP ENEMIES AND SIDE PANEL

            MOVE.W  #ENMMAXNO-1, D0

.ENMPLTL    JSR     ENMPLOT                 ; PLOT ENEMY IN INDEX D0
            DBRA    D0, .ENMPLTL

            JSR     SPNPLOT                 ; DRAW SIDE PANEL
            
.SKIPENM    MOVEQ   #94, D0
            TRAP    #15                     ; REPAINT SCREEN (DOUBLE BUFFER)

            MOVE.B  #1, FRMSTATE            ; TELL THAT FRAME IS READY

            BRA     .LOOP

            SIMHALT

; --- VARIABLES ---------------------------------------------------------------
            
            INCLUDE "FILEDEF.X68"
            INCLUDE "ENMSPAWN.X68"
            INCLUDE "VARS.X68"
            INCLUDE "SYSVARS.X68"
            INCLUDE "BUFFERS.X68"

            END     START
