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

            JSR     SCRINIT             ; SCREEN INITIALIZATION
            JSR     KBDINIT             ; KEYBOARD INITIALIZATION
            JSR     TIMINIT             ; TIMER INITIALIZATION

            JSR     TXTRESET            ; SET DEFAULT FONT

            MOVE.L  #KBDUPD, $84        ; INSTALL TO TRAP 1
            MOVE.L  #TIMISR1, $64       ; INSTALL TO IRQ 1
            MOVE.L  #TIMISR2, $68       ; INSTALL TO IRQ 2

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
SCRCLEAR
; CLEARS THE SCREEN WITH THE COLOR DEFINED IN SCRBACK CONSTANT.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0-D4
; ------------------------------------------------------------------------------
            
            MOVEQ   #11, D0
            MOVE.W  #$FF00, D1              ; CLEAR THE SCREEN
            TRAP    #15

            MOVEQ   #81, D0
            MOVE.L  #SCRBACK, D1
            TRAP    #15                     ; SET FILL COLOR

            MOVEQ   #89, D0
            CLR.W   D1
            CLR.W   D2
            TRAP    #15                     ; FILL SCREEN WITH COLOR
            
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
; 10 -> CONTINUE
; 9  -> OPTION YES
; 8  -> OPTION NO
; 7  -> PL1 UP
; 6  -> PL1 DOWN
; 5  -> PL1 LEFT
; 4  -> PL1 RIGHT
; 3  -> PL2 UP
; 2  -> PL2 DOWN
; 1  -> PL2 LEFT
; 0  -> PL2 RIGHT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D3, -(SP)

            CLR.W   D2

        ; READ FIRST PART (CONTINUE + YES / NO OPTION)

            MOVEQ   #19, D0
            MOVE.L  #KBDCONT<<16|KBDOPTYE<<8|KBDOPTNO, D1
            TRAP    #15

            JSR     .PACK                   ; CONVERT TO DESIRED FORMAT

        ; READ SECOND PART (PL1 MOVEMENT)

            MOVEQ   #19, D0
            MOVE.L  #KBDPL1UP<<24|KBDPL1DW<<16|KBDPL1LF<<8|KBDPL1RG, D1
            TRAP    #15

            JSR     .PACK                   ; CONVERT TO DESIRED FORMAT

        ; READ THIRD PART (PL2 MOVEMENT)

            MOVEQ   #19, D0
            MOVE.L  #KBDPL2UP<<24|KBDPL2DW<<16|KBDPL2LF<<8|KBDPL2RG, D1
            TRAP    #15
 
            JSR     .PACK                   ; CONVERT TO DESIRED FORMAT

        ; COMPUTE KBDEDGE

.NOKEY      MOVE.W  KBDVAL, D0
            NOT.W   D0
            AND.W   D2, D0
            MOVE.W  D0, KBDEDGE

            MOVE.W  D2, KBDVAL              ; STORE KBDVAL

            MOVEM.L (SP)+, D0-D3

            RTE

.PACK       ; SUBROUTINE CONVERT TO DESIRED FORMAT
            
            MOVEQ   #3, D3

.LOOP       LSL.L   #8, D1
            ROXL.W  #1, D2
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
            MOVEQ   #$81, D2                ; ENABLE AUTO IRQ 1
            MOVEQ   #SCRDELTA, D3
            TRAP    #15

            MOVEQ   #$82, D2                ; ENABLE AUTO IRQ 2
            MOVE.W  #1000, D3               ; 1000 MS = 1 SECOND
            TRAP    #15

            RTS

; ------------------------------------------------------------------------------
TIMSTOP
; STOPS THE TIMED INTERRUPTION.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0-D2
; ------------------------------------------------------------------------------

            MOVEQ   #32, D0
            MOVEQ   #6, D1
            MOVEQ   #$01, D2                ; DISABLE AUTO IRQ 1
            TRAP    #15

            MOVEQ   #$02, D2                ; DISABLE AUTO IRQ 2
            TRAP    #15

            RTS

; ------------------------------------------------------------------------------
TIMISR1
; TIMED IRQ THAT IS TRIGGERED BY A SIMULATED CLOCK.
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

; ------------------------------------------------------------------------------
TIMISR2
; TIMED IRQ THAT IS TRIGGERED BY A SIMULATED CLOCK.
; USED TO COUNT SECONDS.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            SUBQ.B  #1, LVLTIMER

        ; DAMAGE COOLDOWNS (TIME BEFORE MORE DAMAGE IS TAKEN)

            TST.B   PL1DMGCD
            BEQ     .NOPL1CD                ; CANNOT GO DOWN AFTER 0

            SUBQ.B  #1, PL1DMGCD

.NOPL1CD    TST.B   PL2DMGCD
            BEQ     .NOPL2CD                ; CANNOT GO DOWN AFTER 0

            SUBQ.B  #1, PL2DMGCD

.NOPL2CD    RTE

; ------------------------------------------------------------------------------
TXTRESET
; RESETS DISPLAY TEXT FONT TO DEFAULTS. 
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0-D2
; ------------------------------------------------------------------------------

            MOVEQ   #21, D0
            MOVE.L  #TXTCOLOR, D1
            MOVE.L  #TXTFONT, D2
            TRAP    #15

            RTS
