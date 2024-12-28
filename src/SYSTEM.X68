; ==============================================================================
; SYSTEM
; ==============================================================================
            
; ------------------------------------------------------------------------------
SYSINIT
; INITIALIZE SYSTEM.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0-D3
; ------------------------------------------------------------------------------
            
            ORI.W   #$0700, SR          ; DISABLE INTERRUPTIONS

            JSR     SCRINIT
            JSR     KBDINIT
            JSR     TIMINIT

            MOVE.L  #KBDUPD, $84        ; INSTALL TO TRAP 1
            MOVE.L  #TIMIRQ, $64        ; INSTALL TO IRQ 1

            MOVE.W  SR, -(SP)            
            ANDI.W  #$D8FF, (SP)        ; SET USER MODE, ENABLE INTERRUPTIONS
            RTE
  

; ------------------------------------------------------------------------------
SCRINIT
; INITIALIZE SCREEN.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0, D1
; ------------------------------------------------------------------------------

        ; SET OUTPUT WINDOW:

            MOVEQ   #33, D0
            MOVE.L  #SCRWIDTH*$10000+SCRHEIGH, D1   ; SET RESOLUTION
            TRAP    #15

            MOVEQ   #33, D0
            MOVE.L  #SCRMODE, D1                    ; SET WINDOW MODE
            TRAP    #15

        ; SET DOUBLE BUFFERING:

            MOVEQ   #92, D0
            MOVEQ   #17, D1
            TRAP    #15

            RTS

; ------------------------------------------------------------------------------
KBDINIT 
; INITIALIZE KEYBOARD.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            CLR.B   KBDVAL
            CLR.B   KBDEDGE
            RTS

; ------------------------------------------------------------------------------
KBDUPD 
; UPDATE KEYBOARD INFORMATION.
; 7 -> PL1 UP
; 6 -> PL1 DOWN
; 5 -> PL1 LEFT
; 4 -> PL1 RIGHT
; 3 -> PL2 UP
; 2 -> PL2 DOWN
; 1 -> PL2 LEFT
; 0 -> PL2 RIGHT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            MOVEM.L D0-D3, -(SP)
            
            ; READ FIRST PART (PL1 MOVEMENT)
            MOVEQ   #19, D0
            MOVE.L  #KBDPL1UP<<24|KBDPL1DW<<16|KBDPL1LF<<8|KBDPL1RG, D1
            TRAP    #15

            ; CONVERT TO DESIRED FORMAT
            JSR     .PACK

            ; READ SECOND PART (PL2 MOVEMENT)
            MOVEQ   #19, D0
            MOVE.L  #KBDPL2UP<<24|KBDPL2DW<<16|KBDPL2LF<<8|KBDPL2RG, D1
            TRAP    #15
 
            ; CONVERT TO DESIRED FORMAT
            JSR     .PACK

            ; COMPUTER KBDEDGE
            MOVE.B  KBDVAL, D0
            NOT.B   D0
            AND.B   D2, D0
            MOVE.B  D0, KBDEDGE

            ; STORE KBDVAL
            MOVE.B  D2, KBDVAL

            MOVEM.L (SP)+, D0-D3

            RTE

.PACK       ; SUBROUTINE CONVERT TO DESIRED FORMAT
            
            MOVE.W  #3, D3

.LOOP       LSL.L   #8, D1
            ROXL.B  #1, D2
            DBRA    D3, .LOOP

            RTS

; ------------------------------------------------------------------------------
TIMINIT
; INITIALIZES THE TIMED INTERRUPTION.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0-D3
; ------------------------------------------------------------------------------

            CLR.B   FRMSKIP
            MOVE.B  #3, FRMSTATE            ; SET BITS 0 AND 1

            MOVEQ   #32, D0
            MOVEQ   #6, D1
            MOVEQ   #$81, D2                ; ENABLE IRQ 1
            MOVEQ   #SCRDELTA, D3
            TRAP    #15

            RTS

; ------------------------------------------------------------------------------
TIMIRQ
; TIMED IRQ THAT IS TRIGGERED BY THE SIMULATED CLOCK.
; USED TO CONTROL FRAME SYNCRONIZATION AS WELL AS FRAME SKIPPING. 
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            ADDQ.B  #1, FRMCNT

            BTST.B  #0, FRMSTATE            ; CHECK IF FRAME IS READY
            BNE     .READY
    
            ADDQ.W  #1, FRMSKIP             ; SKIP NEXT FRAME
            RTE

.READY      BSET.B  #1, FRMSTATE            ; ALLOW NEXT FRAME TO BE DRAWN
            RTE
