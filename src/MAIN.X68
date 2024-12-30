; ==============================================================================
; TITLE       :
; DESCRIPTION :
; AUTHOR      :
; HISTORY     :
; ==============================================================================

            ORG     $1000
            
            INCLUDE "MACROS.X68"
            INCLUDE "CONST.X68"
            INCLUDE "SYSCONST.X68"
            INCLUDE "SYSTEM.X68"
            INCLUDE "PL1.X68"
            INCLUDE "PL2.X68"
            INCLUDE "SIDEPANEL.X68"
            INCLUDE "LEVEL.X68"
            INCLUDE "ENEMY.X68"
            INCLUDE "BTM.X68"
            INCLUDE "GFX.X68"
           
START

; --- INITIALIZATION -----------------------------------------------------------

            JSR     SYSINIT
            JSR     PL1INIT
            JSR     PL2INIT
            JSR     SPNINIT

            MOVE.B  #1, BUFFMODE            ; SET BUFFER MODE TO LEVEL

            MOVEQ   #0, D0                  ; SET LEVEL INDEX
            JSR     LVLSWTCH                ; SWITCH TO LEVEL IN D0

            JSR     PL1RESET
            JSR     PL2RESET

.LOOP

; --- UPDATE -------------------------------------------------------------------

; READ INPUT DEVICES

            TRAP    #1

; UPDATE GAME LOGIC

            JSR     PL1UPD
            JSR     PL2UPD            

; --- SYNC ---------------------------------------------------------------------

.SKIP       TST.W   FRMSKIP
            BEQ     .NOSKIP                 ; DO NOT SKIP NEXT FRAME

            SUBQ.W  #1, FRMSKIP             ; TELL THAT IT HAS BEEN SKIPPED
            BRA     .LOOP                   ; SKIP NEXT FRAME

.NOSKIP     BTST.B  #1, FRMSTATE
            BEQ     .SKIP                   ; WAIT FOR NEXT FRAME
            
            CLR.B   FRMSTATE                ; NEXT FRAME IS NOT READY

; --- PLOT ---------------------------------------------------------------------

            JSR     LVLPLOT                 ; DRAW MAP

            MOVE.B  #0, BUFFMODE            ; SET BUFFER MODE TO STATIC

; DRAW ENTITIES

            JSR     PL1PLOT
            JSR     PL2PLOT

            MOVE.B  #1, BUFFMODE            ; SET BUFFER MODE TO LEVEL
            
            JSR     SPNPLOT                 ; DRAW SIDE PANEL

            MOVEQ   #94, D0
            TRAP    #15                     ; REPAINT SCREEN (DOUBLE BUFFER)

            MOVE.B  #1, FRMSTATE            ; TELL THAT FRAME IS READY

            BRA     .LOOP

            SIMHALT

; --- VARIABLES ---------------------------------------------------------------
            
            INCLUDE "FILEDEF.X68"
            INCLUDE "VARS.X68"
            INCLUDE "SYSVARS.X68"
            INCLUDE "BUFFERS.X68"

            END     START
