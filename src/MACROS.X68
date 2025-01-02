; ==============================================================================
; MACROS
; ==============================================================================

; ------------------------------------------------------------------------------
SIZE        MACRO
; SETS \1 TO THE SIZE OF \0.
; ------------------------------------------------------------------------------

            IFC     \0, B
                MOVEQ   #1, \1
            ENDC
            IFC     \0, W
                MOVEQ   #2, \1
            ENDC
            IFC     \0, L
                MOVEQ   #4, \1
            ENDC

            ENDM

; ------------------------------------------------------------------------------
RDMGC       MACRO
; READS A MAGIC NUMBER FROM THE OPENED FILE AND COMPARES IT TO \1.
; JUMPS TO \2 TAG IF THEY ARE NOT EQUAL.
; MAKE SURE THAT D0 AND D2 ARE PROPERLY CLEARED.
; ------------------------------------------------------------------------------

            MOVEQ   #53, D0
            SIZE.\0 D2
            TRAP    #15

            CMPI.\0 #\1, (A1)               ; CHECK IF MAGIC IS \1
            BNE     \2                      ; JUMP TO \2 IF INCORRECT

            ENDM

; ------------------------------------------------------------------------------
RDJMP       MACRO
; READS AN ABSOLUTE OFFSET FROM THE OPENED FILE AND JUMPS TO IT IN THE FILE.
; OPTIONALLY, JUMP TO \1 IF PRESENT WHEN THE OFFSET IS 0.
; MAKE SURE THAT D0 AND D2 ARE PROPERLY CLEARED.
; ------------------------------------------------------------------------------

            MOVEQ   #53, D0
            SIZE.\0 D2
            TRAP    #15

            MOVEQ   #55, D0
            MOVE.\0 (A1), D2

            IFARG   1
                BEQ     \1                  ; JUMP TO \1 IF OFFSET IS 0
            ENDC

            TRAP    #15                     ; MOVE TO OFFSET

            ENDM

; ------------------------------------------------------------------------------
BUFCP       MACRO
; COPIES THE CONTENTS OF \1.\0 TO A BUFFER IN \2.
; SETS THE ADDRESS REGISTER SPECIFIED IN \3 TO WHERE THE DATA WAS WRITTEN.
; AN ADDITIONAL AUXILIARY DATA REGISTER IS REQUIRED IN \4.
; THE BUFFER TO WRITE THE DATA TO WILL DEPEND ON THE BUFFER MODE.
; AVAILABLE BUFFERS: CL, TS, MP, EI.
; MP IS ONLY AVAILABLE IN LEVEL MODE.
; ------------------------------------------------------------------------------

            SIZE.\0 \4

            TST.B   BUFFMODE                ; CHECK BUFFER MODE
            BEQ     .STATIC\@

            IFC     \2, CL
                LEA     LVLCLBUF, \3
                ADDA    LVLCLCNT, \3
                ADD.W   \4, LVLCLCNT
            ENDC
            IFC     \2, TS
                LEA     LVLTSBUF, \3
                ADDA    LVLTSCNT, \3
                ADD.W   \4, LVLTSCNT
            ENDC
            IFC     \2, MP
                LEA     LVLMPBUF, \3
                ADDA    LVLMPCNT, \3
                ADD.W   \4, LVLMPCNT
            ENDC
            IFC     \2, EI
                LEA     LVLEIBUF, \3
                ADDA    LVLEICNT, \3
                ADD.W   \4, LVLEICNT
            ENDC

            BRA     .END\@

.STATIC\@

            IFC     \2, CL
                LEA     STACLBUF, \3
                ADDA    STACLCNT, \3
                ADD.W   \4, STACLCNT
            ENDC
            IFC     \2, TS
                LEA     STATSBUF, \3
                ADDA    STATSCNT, \3
                ADD.W   \4, STATSCNT
            ENDC
            IFC     \2, EI
                LEA     STAEIBUF, \3
                ADDA    STAEICNT, \3
                ADD.W   \4, STAEICNT
            ENDC

.END\@       
            MOVE.\0 \1, (\3)                ; COPIES THE CONTENTS TO THE BUFFER

            ENDM

; ------------------------------------------------------------------------------
BUFCNT      MACRO
; GETS THE COUNTER OF THE BUFFER SPECIFIED IN \1 AND PUTS THEM INTO \2.W
; THE RESULTING VALUE WILL DEPEND ON THE BUFFER MODE.
; AVAILABLE BUFFERS: CL, TS, MP, EI.
; MP IS ONLY AVAILABLE IN LEVEL MODE.
; ------------------------------------------------------------------------------

            TST.B   BUFFMODE                ; CHECK BUFFER MODE
            BEQ     .STATIC\@

            IFC     \1, CL
                MOVE.W  LVLCLCNT, \2
            ENDC
            IFC     \1, TS
                MOVE.W  LVLTSCNT, \2
            ENDC
            IFC     \1, MP
                MOVE.W  LVLMPCNT, \2
            ENDC
            IFC     \1, EI
                MOVE.W  LVLEICNT, \2
            ENDC

            BRA     .END\@

.STATIC\@

            IFC     \1, CL
                MOVE.W  STACLCNT, \2
            ENDC
            IFC     \1, TS
                MOVE.W  STATSCNT, \2
            ENDC
            IFC     \1, EI
                MOVE.W  STAEICNT, \2
            ENDC

.END\@       
            ENDM

; ------------------------------------------------------------------------------
BUFAT       MACRO
; GETS THE ADDRESS OF A POSITION WITHIN THE BUFFER WHERE THE BUFFER IS \1 AND
; THE POSITION IS \2. THE RESULT IS WRITTEN INTO \3, WHICH MUST BE An.
; AVAILABLE BUFFERS: CL, TS, MP, EI.
; MP IS ONLY AVAILABLE IN LEVEL MODE.
; ------------------------------------------------------------------------------
            
            TST.B   BUFFMODE                ; CHECK BUFFER MODE
            BEQ     .STATIC\@

            IFC     \1, CL
                LEA     LVLCLBUF, \3
                ADDA    \2, \3
            ENDC
            IFC     \1, TS
                LEA     LVLTSBUF, \3
                ADDA    \2, \3
            ENDC
            IFC     \1, MP
                LEA     LVLMPBUF, \3
                ADDA    \2, \3
            ENDC
            IFC     \1, EI
                LEA     LVLEIBUF, \3
                ADDA    \2, \3
            ENDC

            BRA     .END\@

.STATIC\@

            IFC     \1, CL
                LEA     STACLBUF, \3
                ADDA    \2, \3
            ENDC
            IFC     \1, TS
                LEA     STATSBUF, \3
                ADDA    \2, \3
            ENDC
            IFC     \1, EI
                LEA     STAEIBUF, \3
                ADDA    \2, \3
            ENDC

.END\@       
            ENDM

; ------------------------------------------------------------------------------
RANG        MACRO
; CHECKS FOR THE VALUE OF \1 TO BE INSIDE THE RANGE OF \2 AND \3.
; \4 SPECIFIES THE WIDTH OF THE VALUE TO CHECK.
; SETS THE VALUE TO EITHER OF THEM IF OUT OF BOUNDS.
; MAKE SURE THAT \1 IS A DATA REGISTER.
; ------------------------------------------------------------------------------

            CMP.\0  \2, \1                  ; CHECK LOWER BOUND
            BGT     .CHCK1\@

            MOVE.\0 \2, \1                  ; SET TO LOWER BOUND

.CHCK1\@    ADD.\0  \4, \1                  ; ADD WIDTH

            CMP.\0  \3, \1                  ; CHECK UPPER BOUND
            BLT     .CHCK2\@

            MOVE.W  \3, \1                  ; SET TO UPPER BOUND

.CHCK2\@    SUB.\0  \4, \1                  ; REMOVE WIDTH

            ENDM
