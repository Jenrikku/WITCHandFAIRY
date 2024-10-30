# Binary File Documentation

This file contains the documentation for all the propietary binary files used in this project.

## Binary Tile Map File documentation (.btm)

This file contains a binary tile map and has the .btm file extension.

| Offset | Size |     Description     |
|--------|------|---------------------|
| 0x00   | 4    | Magic (JkBM)        |
| 0x04   | 4    | MAP section offset  |
| 0x08   | 4    | COL section offset  |
| 0x0C   | 4    | IMG section offset  |

All offsets are relative to file's beginning (absolute)

### Map section documentation

This section contains the map data.

| Offset | Size |     Description     |
|--------|------|---------------------|
| 0x00   | 3    | Magic (MAP)         |
| 0x03   | 1    | Map Width           |
| 0x04   | 1    | Map height          |
| 0x05   | N    | Map data            |

With N = Map Width * Map Height

The map data is composed of 1 byte per tile that points to a tile within the IMG section.  
0xFF is reserved and means empty space.

### Image section documentation

This section contains the textures of the tileset.

| Offset | Size |     Description     |
|--------|------|---------------------|
| 0x00   | 3    | Magic (IMG)         |
| 0x03   | N    | Image pixel data    |

With N = 

## Binary Sprite Table documentation (.bst)

TODO: Explain files for standalone IMG sections. (Players and enemies)