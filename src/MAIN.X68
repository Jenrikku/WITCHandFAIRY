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
           
START

; --- INITIALIZATION -----------------------------------------------------------

            JSR     SYSINIT
            JSR     PL1INIT
            JSR     PL2INIT
            JSR     SCOINIT

.LOOP

; --- UPDATE -------------------------------------------------------------------

; READ INPUT DEVICES

; UPDATE GAME LOGIC

            JSR     PL1UPD
            JSR     PL2UPD            

; --- SYNC ---------------------------------------------------------------------

; --- PLOT ---------------------------------------------------------------------

            JSR     SCOPLOT
            JSR     PL1PLOT
            JSR     PL2PLOT

            BRA     .LOOP

            SIMHALT

; --- VARIABLES ---------------------------------------------------------------
            
            INCLUDE "VARS.X68"
            INCLUDE "SYSVARS.X68"
            INCLUDE "BUFFERS.X68"

            END     START
