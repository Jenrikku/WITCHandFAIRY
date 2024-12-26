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
            INCLUDE "SCORE.X68"
            INCLUDE "BTM.X68"
            INCLUDE "GFX.X68"
           
START

; --- INITIALIZATION -----------------------------------------------------------

            ORI.W   #$0700, SR              ; DISABLE INTERRUPTIONS

            JSR     SYSINIT
            JSR     PL1INIT
            JSR     PL2INIT
            JSR     SCOINIT

            MOVE.B  #1, BUFFMODE            ; SET BUFFER MODE TO LEVEL

            ; LVL STUFF INIT

.LOOP

; --- UPDATE -------------------------------------------------------------------

; READ INPUT DEVICES

        TRAP    #1

; UPDATE GAME LOGIC

            JSR     PL1UPDY
            JSR     PL1UPDX
            JSR     PL2UPD            

; --- SYNC ---------------------------------------------------------------------

; --- PLOT ---------------------------------------------------------------------

            JSR     SCOPLOT

            ; LVL STUFF PLOT

            MOVE.B  #0, BUFFMODE            ; SET BUFFER MODE TO STATIC

            JSR     PL1PLOT
            JSR     PL2PLOT

            MOVE.B  #1, BUFFMODE            ; SET BUFFER MODE TO LEVEL

            BRA     .LOOP

            SIMHALT

; --- VARIABLES ---------------------------------------------------------------
            
            INCLUDE "FILEDEF.X68"
            INCLUDE "VARS.X68"
            INCLUDE "SYSVARS.X68"
            INCLUDE "BUFFERS.X68"

            END     START
