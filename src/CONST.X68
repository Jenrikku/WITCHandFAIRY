; ==============================================================================
; GAME CONSTANTS
; ==============================================================================

; --- ENEMY RELATED CONSTANTS --------------------------------------------------

ENMMAXNO    EQU     13                      ; IN-SCREEN ENEMY MAX COUNT
ENMMAXTP    EQU     2                       ; MAXIMUM ENEMY TYPES IN A LEVEL

; --- GRAPHICS RELATED CONSTANS ------------------------------------------------

PXLX        EQU     3                       ; AMOUNT OF DRAWS PER PIXEL IN X
PXLY        EQU     3                       ; AMOUNT OF DRAWS PER PIXEL IN Y
LVLWIDTH    EQU     10                      ; WIDTH IN TILES OF THE LEVEL
LVLHEIGH    EQU     10                      ; HEIGHT IN TILES OF THE LEVEL

; --- TEXT RELATED CONSTANTS ---------------------------------------------------

TXTANYKP    EQU     10*$100+15              ; PRESS ANY KEY TEXT POSITION

; --- SIDE PANEL RELATED CONSTANTS ---------------------------------------------

SPNSTART    EQU     LVLWIDTH*16*3           ; SIDE PANEL START X POSITION
SPNWIDTH    EQU     SCRWIDTH-SPNSTART       ; SIDE PANEL WIDTH
SPNMARGN    EQU     6*3                     ; SIDE PANEL OUTER MARGIN

; --- WITCH RELATED CONSTANTS --------------------------------------------------

PL1SPEED    EQU     7                       ; WITCH SPEED WHEN MOVING
PL1REGX     EQU     (LVLWIDTH*16*3)/2-68    ; WITCH STARTING X (REGULAR)
PL1TITX     EQU     SPNWIDTH/2+6*16*3       ; WITCH STARTING X (TITLE)
PL1TUTX     EQU     0                       ; WITCH STARTING X (TUTORIAL)
PL1TUTY     EQU     0                       ; WITCH STARTING Y (TUTORIAL)


; --- FAIRY RELATED CONSTANTS --------------------------------------------------

PL2SPEED    EQU     7                       ; FAIRY SPEED WHEN MOVING
PL2REGX     EQU     (LVLWIDTH*16*3)/2+20    ; FAIRY STARTING X (REGULAR)
PL2TITX     EQU     SPNWIDTH/2+7*16*3       ; FAIRY STARTING X (TITLE)
PL2TUTX     EQU     0                       ; FAIRY STARTING X (TUTORIAL)
PL1TUTY     EQU     0                       ; FAIRY STARTING Y (TUTORIAL)

; --- BOTH PLAYERS RELATED CONSTANTS -------------------------------------------

PLYREGY     EQU     LVLHEIGH*16*3-100       ; BOTH PLAYERS STARTING Y (REGULAR)
PLYTITY     EQU     4*16*3                  ; BOTH PLAYERS STARTING Y (TITLE)
PLYINIHP    EQU     7                       ; INITIAL PLAYERS HP
PLYESYHP    EQU     255                     ; INITIAL PLAYERS HP (EASY MODE)
