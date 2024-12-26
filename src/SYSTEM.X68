; ==============================================================================
; SYSTEM
; ==============================================================================
            
; ------------------------------------------------------------------------------
SYSINIT
; INITIALIZE SYSTEM.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : D0, D1
; ------------------------------------------------------------------------------
           
        ; SET OUTPUT WINDOW:
            JSR     KBDINIT

            MOVE.L  #KBDUPD,($84)

            MOVEQ   #33, D0
            MOVE.L  #SCRWIDTH*$10000+SCRHEIGH, D1   ; SET RESOLUTION
            TRAP    #15

            MOVEQ   #33, D0
            MOVE.L  #SCRMODE, D1                    ; SET WINDOW MODE
            TRAP    #15

            ANDI.W  #$D8FF, SR          ; SET USER MODE, ENABLE INTERRUPTIONS
            RTS

; ------------------------------------------------------------------------------
KBDINIT 
; INITIALIZE KEYBOARD.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            CLR.B   (KBDVAL)
            CLR.B   (KBDEDGE)
            RTS
; ------------------------------------------------------------------------------
KBDUPD 
; UPDATE KEYBOARD INFORMATION.
; 7 -> FIRE 4 (S)
; 6 -> FIRE 3 (A)
; 5 -> FIRE 2 (W)
; 4 -> FIRE 1 (D)
; 3 -> DOWN
; 2 -> RIGHT
; 1 -> UP
; 0 -> LEFT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            MOVEM.L D0-D3,-(A7)
            
            ; READ FIRST PART
            MOVE.B  #19,D0
            MOVE.L  #KBDFIRE4<<24|KBDFIRE3<<16|KBDFIRE2<<8|KBDFIRE1,D1
            TRAP    #15

            ; CONVERT TO DESIRED FORMAT
            JSR .PACK

             ; READ SECOND PART
            MOVE.L  #KBDDOWN<<24|KBDRIGHT<<16|KBDUP<<8|KBDLEFT,D1
            TRAP    #15
 
            ; CONVERT TO DESIRED FORMAT
            JSR .PACK

            ;COMPUTER KBDEDGE
            MOVE.B  (KBDVAL),D0
            NOT.B   D0
            AND.B   D2,D0
            MOVE.B  D0,(KBDEDGE)

            ;STORE KBDVAL
            MOVE.B  D2,(KBDVAL)

            MOVEM.L (A7)+,D0-D3

            RTE

.PACK       
            ; SUBRUTINA CONVERT TO DESIRED FORMAT
            MOVE.W  #3,D3
.LOOP       LSL.L   #8,D1
            ROXL.B  #1,D2
            DBRA.W  D3,.LOOP
            RTS 