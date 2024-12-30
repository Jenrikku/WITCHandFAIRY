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

; --- WITCH RELATED CONSTANTS --------------------------------------------------

PL1SPEED    EQU     7                       ; WITCH SPEED WHEN MOVING
PL1CONSX    EQU     (LVLWIDTH*16*3)/2-68


; --- FAIRY RELATED CONSTANTS --------------------------------------------------

PL2SPEED    EQU     7                       ; FAIRY SPEED WHEN MOVING
PL2CONSX    EQU     (LVLWIDTH*16*3)/2+20     

; --- PLAYERS RELATED CONSTANTS ------------------------------------------------

PLYCONSY     EQU    LVLHEIGH*16*3-100       ; Y POSITION OF THE PLAYER 

; --- SIDE PANEL RELATED CONSTANTS ---------------------------------------------

SPNSTART    EQU     480                     ; START X POSITION OF SIDE PANEL
SPNMARGN    EQU     6*3                     ; SIDE PANEL OUTER MARGIN
