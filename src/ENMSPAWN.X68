; ==============================================================================
; ENEMY SPAWN LOCATIONS
; ==============================================================================
; EACH LEVEL HAS ITS OWN SPAWN LISTS WHERE LVLXSPWD IS THE DELAY IN SECONDS
; UNTIL THE ENEMY SPAWNS, LVLXSPWT IS THE ENEMY TYPE, LVLXSPWM IS THE MOVEMENT
; MODE EACH ENEMY USES AND LVLXSPWP IS THE POSITION X (HIGH B) AND Y (LOW B).
; ONLY THE FIRST 20 SECONDS ARE SPECIFIED AND ENEMIES ARE REPEATED FROM THERE.
; ------------------------------------------------------------------------------

LVL1SPWD    DC.B    1, 2, 2, 3, 4, 4, 5, 6, 7, 8, 8, 9, 9, 9, 10, 10

LVL1SPWT    DC.B    0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1

LVL1SPWM    DC.B    0   ; TO BE DEFINED
            DS.W    0

LVL1SPWP    DC.W    0   ; TO BE DEFINED
