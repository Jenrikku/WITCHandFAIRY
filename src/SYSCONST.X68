; ==============================================================================
; SYSTEM CONSTANTS
; ==============================================================================

; --- SCREEN RELATED CONSTANTS -------------------------------------------------

SCRWIDTH    EQU     640                     ; SCREEN WIDTH
SCRHEIGH    EQU     480                     ; SCREEN HEIGHT
SCRMODE     EQU     1                       ; 1 = WINDOWED, 2 = FULLSCREEN
SCRDELTA    EQU     40                      ; MAX MILISECONDS BETWEEN FRAMES
SCRBACK     EQU     $002A2A2A               ; CLEAR COLOR

; --- GRAPHICS RELATED CONSTANS ------------------------------------------------

PXLX        EQU     3                       ; AMOUNT OF DRAWS PER PIXEL IN X
PXLY        EQU     3                       ; AMOUNT OF DRAWS PER PIXEL IN Y

; --- TEXT RELATED CONSTANTS ---------------------------------------------------

TXTCOLOR    EQU     $00FFFFFF               ; WHITE FONT COLOR
TXTFONT     EQU     $03120001               ; COURIER NEW, 12 POINTS, BOLD
TXTFONTB    EQU     $03180001               ; COURIER NEW, 18 POINTS, BOLD (BIG)

; --- KEYCODES -----------------------------------------------------------------

KBDCONT     EQU     $0D                     ; KEY ENTER
KBDOPTYE    EQU     'Y'                     ; KEY Y
KBDOPTNO    EQU     'N'                     ; KEY N
KBDPL1UP    EQU     'W'                     ; KEY W
KBDPL1DW    EQU     'S'                     ; KEY S
KBDPL1LF    EQU     'A'                     ; KEY A
KBDPL1RG    EQU     'D'                     ; KEY D
KBDPL2UP    EQU     $26                     ; KEY UP
KBDPL2DW    EQU     $28                     ; KEY DOWN
KBDPL2LF    EQU     $25                     ; KEY LEFT
KBDPL2RG    EQU     $27                     ; KEY RIGHT

; --- KEY CHECK BITS -----------------------------------------------------------

; HIGHER BYTE

KBTCONT     EQU     2                       ; CONTINUE
KBTOPTYE    EQU     1                       ; OPTION YES
KBTOPTNO    EQU     0                       ; OPTION NO

; LOWER BYTE

KBTPL1UP    EQU     7                       ; PL1 GO UP
KBTPL1DW    EQU     6                       ; PL1 GO DOWN
KBTPL1LF    EQU     5                       ; PL1 GO LEFT
KBTPL1RG    EQU     4                       ; PL1 GO RIGHT
KBTPL2UP    EQU     3                       ; PL2 GO UP
KBTPL2DW    EQU     2                       ; PL2 GO DOWN
KBTPL2LF    EQU     1                       ; PL2 GO LEFT
KBTPL2RG    EQU     0                       ; PL2 GO RIGHT
