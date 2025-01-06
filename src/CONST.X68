; ==============================================================================
; GAME CONSTANTS
; ==============================================================================

; --- ENEMY RELATED CONSTANTS --------------------------------------------------

ENMMAXNO    EQU     13                      ; IN-SCREEN ENEMY MAX COUNT
ENMMAXTP    EQU     2                       ; MAXIMUM ENEMY TYPES IN A LEVEL

; --- LEVEL RELATED CONSTANS ---------------------------------------------------

LVLWIDTH    EQU     10                      ; WIDTH IN TILES OF THE LEVEL
LVLHEIGH    EQU     10                      ; HEIGHT IN TILES OF THE LEVEL
LVLMAX      EQU     7                       ; INDEX OF THE LAST MAP
LVLLAST     EQU     4                       ; INDEX OF THE LAST REGULAR LEVEL
LVLTIME     EQU     60                      ; TIMER STARTS AT THIS TIME (SECS)

; --- SIDE PANEL RELATED CONSTANTS ---------------------------------------------

SPNSTART    EQU     LVLWIDTH*16*PXLX        ; SIDE PANEL START X POSITION
SPNWIDTH    EQU     SCRWIDTH-SPNSTART       ; SIDE PANEL WIDTH
SPNMARGN    EQU     4*PXLX                  ; SIDE PANEL OUTER MARGIN

; --- WITCH RELATED CONSTANTS --------------------------------------------------

PL1SPEED    EQU     7                       ; WITCH SPEED WHEN MOVING
PL1REGX     EQU     (LVLWIDTH*16*PXLX)/2-68 ; WITCH STARTING X (REGULAR)
PL1TITX     EQU     SPNWIDTH/2+6*16*PXLX    ; WITCH STARTING X (TITLE)
PL1TUTY     EQU     70                      ; WITCH STARTING Y (TUTORIAL)

; --- FAIRY RELATED CONSTANTS --------------------------------------------------

PL2SPEED    EQU     7                       ; FAIRY SPEED WHEN MOVING
PL2REGX     EQU     (LVLWIDTH*16*PXLX)/2+20 ; FAIRY STARTING X (REGULAR)
PL2TITX     EQU     SPNWIDTH/2+7*16*PXLX    ; FAIRY STARTING X (TITLE)
PL2TUTY     EQU     125                     ; FAIRY STARTING Y (TUTORIAL)

; --- BOTH PLAYERS RELATED CONSTANTS -------------------------------------------

PLYREGY     EQU     LVLHEIGH*16*PXLY-100    ; BOTH PLAYERS STARTING Y (REGULAR)
PLYTITY     EQU     4*16*PXLY               ; BOTH PLAYERS STARTING Y (TITLE)
PLYTUTX     EQU     50                      ; BOTH PLAYERS STARTING X (TUTORIAL)
PLYINIHP    EQU     7                       ; INITIAL PLAYERS HP
PLYESYHP    EQU     255                     ; INITIAL PLAYERS HP (EASY MODE)
