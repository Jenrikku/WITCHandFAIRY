# Entity Information structure

Each entity information defines various parameters of a separated entity as well as point to where they exist in buffer space.  
Entity informations are generated when the BTM file is read and are stored in the special EI buffers.

| Offset | Size |     Description     |
|--------|------|---------------------|
| 0x00   | 1    | Frame count         |
| 0x01   | 1    | Width of tiles      |
| 0x02   | 1    | Height of tiles     |
| 0x04   | 2    | Pointer in buffer   |

The pointer is to the tiles buffer of the same buffer mode this entity info is in.