; ==============================================================================
; MACROS
; ==============================================================================

; ------------------------------------------------------------------------------
RDMGC       MACRO
; READS A MAGIC NUMBER FROM THE OPENED FILE AND COMPARES IT TO \1.
; JUMPS TO \2 TAG IF THEY ARE NOT EQUAL.
; MAKE SURE THAT D0 AND D2 ARE PROPERLY CLEARED.
; ------------------------------------------------------------------------------

            IFC     \0, ''
                FAIL ERROR: RDMGC needs .B, .W or .L
                MEXIT
            ENDC

            MOVE.B  #53, D0

            IFC     \0, B
                MOVE.B  #1, D2              ; SET HEADER SIZE TO .B
            ENDC
            IFC     \0, W
                MOVE.B  #2, D2              ; SET HEADER SIZE TO .W
            ENDC
            IFC     \0, L
                MOVE.B  #4, D2              ; SET HEADER SIZE TO .L
            ENDC

            TRAP    #15

            CMPI.\0 #'\1', (A1)             ; CHECK MAGIC IN \1
            BNE     \2                      ; JUMP TO \2 IF INCORRECT

            ENDM

; ------------------------------------------------------------------------------
RDJMP       MACRO
; READS AN ABSOLUTE OFFSET FROM THE OPENED FILE AND JUMPS TO IT IN THE FILE.
; OPTIONALLY, JUMP TO TAG IN \1 IF PRESENT WHEN THE OFFSET IS 0.
; ------------------------------------------------------------------------------

            IFC     \0, ''
                FAIL ERROR: RDJMP needs .B, .W or .L
                MEXIT
            ENDC

            MOVE.B  #53, D0

            IFC     \0, B
                MOVE.B  #1, D2              ; SET OFFSET SIZE TO .B
            ENDC
            IFC     \0, W
                MOVE.B  #2, D2              ; SET OFFSET SIZE TO .W
            ENDC
            IFC     \0, L
                MOVE.B  #4, D2              ; SET OFFSET SIZE TO .L
            ENDC

            TRAP    #15

            MOVE.B  #55, D0
            MOVE.\1 (A1), D2

            IFNC    \1, ''
                BEQ     \1                  ; JUMP TO \1 IF OFFSET IS 0
            ENDC

            TRAP    #15                     ; MOVE TO OFFSET

            ENDM

; ------------------------------------------------------------------------------
BUFCP       MACRO
; COPIES THE CONTENTS OF \1.\0 TO A BUFFER IN \2 WITH AN OFFSET IN \3.
; THE BUFFER TO WRITE THE DATA TO WILL DEPEND ON THE BUFFER MODE.
; AVAILABLE BUFFERS: CL, TL, MP.
; MP IS ONLY AVAILABLE IN LEVEL MODE.
; ------------------------------------------------------------------------------

            CMPI.B  #0, BUFFMODE
            BEQ     STATIC\@

            IFC     \2, CL
                MOVE.\0 \1, \3(LVLCLBUF)
            ENDC
            IFC     \2, TL
                MOVE.\0 \1, \3(LVLTLBUF)
            ENDC
            IFC     \2, MP
                MOVE.\0 \1, \3(LVLMPBUF)
            ENDC

            BRA     END\@

STATIC\@

            IFC     \2, CL
                MOVE.\0 \1, \3(STACLBUF)
            ENDC
            IFC     \2, TL
                MOVE.\0 \1, \3(STATLBUF)
            ENDC

END\@

            ENDM
