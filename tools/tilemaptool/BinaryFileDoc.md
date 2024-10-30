# Binary Tile Map file documentation (.btm)

This file contains a binary tile map with an embedded tile set.  
It can be assumed that all values are unsigned.

| Offset | Size |     Description     |
|--------|------|---------------------|
| 0x00   | 4    | Magic ('JkBM')      |
| 0x08   | 4    | COL section offset  |
| 0x0C   | 4    | IMG section offset  |
| 0x04   | 4    | MAP section offset  |

All offsets are relative to file's beginning (absolute)

## Color palette section

This section contains the colors of the textures.  
The colors are in the BGR format.

| Offset | Size |     Description     |
|--------|------|---------------------|
| 0x00   | 3    | Magic ('COL')       |
| 0x03   | 1    | Amount of colors    |
| 0x04   | N    | Colors in BGR       |

With N = Amount of colors * 3

Every color is composed of 3 bytes that contain the blue, green and red values in this order.

## Image section

This section contains the textures of the tileset.  
Colors for the texture are indexed and refer to the COL section.

| Offset | Size |     Description     |
|--------|------|---------------------|
| 0x00   | 3    | Magic ('IMG')       |
| 0x03   | 1    | Amount of tiles     |
| 0x04   | 1    | Tile width          |
| 0x05   | 1    | Tile height         |
| 0x06   | N    | Image pixel data    |

With N = Amount of tiles * Tile width * Tile height

The image pixel data is composed of 1 byte per pixel that acts as an index to one of the colors in the COL section. They start at 0 and 0xFF is reserved and means transparent pixel.

## Map section

This section contains the map data.

| Offset | Size |     Description     |
|--------|------|---------------------|
| 0x00   | 3    | Magic ('MAP')       |
| 0x03   | 1    | Map width           |
| 0x04   | 1    | Map height          |
| 0x05   | N    | Map data            |

With N = Map width * Map height

The map data is composed of 1 byte per tile that points to a tile within the IMG section.  
0xFF is reserved and means empty space.