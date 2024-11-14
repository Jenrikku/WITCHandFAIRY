# Binary Tile Map file documentation (.btm)

This file contains a binary tile map with an embedded tile set.  
It can be assumed that all values are unsigned and row-major.

| Offset | Size |     Description     |
|--------|------|---------------------|
| 0x00   | 4    | Magic ('JkBM')      |
| 0x04   | 4    | CL section offset   |
| 0x08   | 4    | TS section offset   |
| 0x0C   | 4    | MP section offset   |

All offsets are relative to file's beginning (absolute)  
The map section may not exist if the file is meant to only contain sprites. In this case, its offset will be set to 0.

## Color palette section

This section contains the colors of the textures.  
The colors are in the BGR format.

| Offset | Size |     Description     |
|--------|------|---------------------|
| 0x00   | 2    | Magic ('CL')        |
| 0x02   | 1    | Amount of colors    |
| 0x03   | N    | Colors in BGR / RGB |

With N = Amount of colors * 4

Every color is composed of 3 bytes that contain the blue, green and red values.  
The order depends on the endianess: BGR for Big Endian and RGB for Little Endian.  
An extra byte is added so that the color may be read as a 32-bit integer.

## Tileset section

This section contains the textures of the tileset.  
Colors for the texture are indexed and refer to the CL section.

| Offset | Size |     Description     |
|--------|------|---------------------|
| 0x00   | 2    | Magic ('TS')        |
| 0x02   | 1    | Amount of tiles     |
| 0x03   | 1    | Tile width          |
| 0x04   | 1    | Tile height         |
| 0x05   | N    | Image pixel data    |

With N = Amount of tiles * Tile width * Tile height

The image pixel data is composed of 1 byte per pixel that acts as an index to one of the colors in the CL section. They start at 0 and 0xFF is reserved and means transparent pixel.

## Map section

This section contains the map data.

| Offset | Size |     Description     |
|--------|------|---------------------|
| 0x00   | 2    | Magic ('MP')        |
| 0x02   | 1    | Map width           |
| 0x03   | 1    | Map height          |
| 0x04   | N    | Map data            |

With N = Map width * Map height

The map data is composed of 1 byte per tile that points to a tile within the TS section.  
0xFF is reserved and means empty space.