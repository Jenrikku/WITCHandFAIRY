using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;
using static LibBTM.Utils.ValueParser;

namespace LibBTM;

/// <summary>
/// Class that represents a Binary Tile Map file.
/// </summary>
public sealed class BTM
{
    public bool IsBigEndian { get; set; } = true;

    public Rgb24[] Colors { get; private set; } = [];

    public Image<Rgba32>[] Tiles { get; private set; } = [];

    public byte[,] Map { get; private set; } = { };

    private BTM() { }

    public BTM(Image<Rgba32>[] tiles, byte[,] map)
    {
        Tiles = tiles;
        Map = map;

        HashSet<Rgb24> colors = new();

        foreach (Image<Rgba32> image in tiles)
        {
            for (int i = 0; i < image.Height; i++)
            {
                for (int j = 0; j < image.Width; j++)
                {
                    Rgba32 color = image[j, i];

                    if (color.A == 0)
                        continue;

                    // Only add if not contained:
                    colors.Add(new(color.R, color.G, color.B));
                }
            }
        }

        Colors = colors.ToArray();
    }

    /// <summary>
    /// Opens a binary tile map from a file in disk.
    /// </summary>
    /// <param name="path">The path to the btm file</param>
    /// <returns>A BTM with the read data</returns>
    public static unsafe BTM Read(string path)
    {
        byte[] contents = File.ReadAllBytes(path);
        fixed (byte* start = contents)
            return Read(start);
    }

    public static unsafe void Write(BTM btm, string path)
    {
        int size = 31;
        size += btm.Colors.Length * 3;
        size += btm.Tiles.Length * btm.Tiles[0].Height * btm.Tiles[0].Width;
        size += btm.Map.Length;

        byte[] buffer = new byte[size];
        fixed (byte* ptr = buffer)
            Write(btm, ptr);

        File.WriteAllBytes(path, buffer);
    }

    public static unsafe BTM Read(byte* ptr)
    {
        BTM btm = new();
        byte* start = ptr;
        bool reverse;

        uint magic = ReadValue<uint>(ref ptr, BitConverter.IsLittleEndian);
        switch (magic)
        {
            case 0x4A6B424D: // Same endianess.
                btm.IsBigEndian = !BitConverter.IsLittleEndian;
                reverse = false;
                break;

            case 0x4D426B4A: // Reversed endianess.
                btm.IsBigEndian = BitConverter.IsLittleEndian;
                reverse = true;
                break;

            default:
                return btm; // Not a valid BTM.
        }

        uint colOffset = ReadValue<uint>(ref ptr, reverse);
        uint imgOffset = ReadValue<uint>(ref ptr, reverse);
        uint mapOffset = ReadValue<uint>(ref ptr, reverse);

        ptr = start + colOffset;
        ReadCL(btm, ptr, reverse);

        ptr = start + imgOffset;
        ReadTS(btm, ptr, reverse);

        if (mapOffset != 0)
        {
            ptr = start + mapOffset;
            ReadMP(btm, ptr, reverse);
        }

        return btm;
    }

    public static unsafe void Write(BTM btm, byte* ptr)
    {
        byte* start = ptr;
        bool reverse = btm.IsBigEndian == BitConverter.IsLittleEndian;

        WriteValue<uint>(ref ptr, 0x4A6B424D, reverse);

        WriteValue<uint>(ref ptr, 16, reverse); // Write color palette offset
        ptr += 4 * 2; // Skip two offsets, to be calculated later

        // Color palette section:

        WriteValue<ushort>(ref ptr, 0x434C, reverse);
        *ptr++ = (byte)btm.Colors.Length;

        foreach (Rgb24 color in btm.Colors)
            WriteValue(ref ptr, color, reverse);

        // Tileset section:

        Align(ref ptr, start, 16); // WARNING: Not enough memory for alignment.
        uint tsOffset = (uint)(start - ptr);

        WriteValue<ushort>(ref ptr, 0x5453, reverse);
        *ptr++ = (byte)btm.Tiles.Length;
        *ptr++ = (byte)btm.Tiles[0].Width;
        *ptr++ = (byte)btm.Tiles[0].Height;

        foreach (Image<Rgba32> image in btm.Tiles) { }
    }

    private static unsafe void ReadCL(BTM btm, byte* ptr, bool reverse)
    {
        ushort magic = ReadValue<ushort>(ref ptr, reverse);

        if (magic != 0x434C)
            return;

        byte colorCount = *ptr++;
        btm.Colors = ReadValues<Rgb24>(ref ptr, reverse, colorCount);
    }

    private static unsafe void ReadTS(BTM btm, byte* ptr, bool reverse)
    {
        ushort magic = ReadValue<ushort>(ref ptr, reverse);

        if (magic != 0x5453)
            return;

        byte tileCount = *ptr++;
        byte tileWidth = *ptr++;
        byte tileHeight = *ptr++;

        Image<Rgba32>[] images = new Image<Rgba32>[tileCount];

        for (int i = 0; i < tileCount; i++)
        {
            Image<Rgba32> image = new(tileWidth, tileHeight);

            for (int j = 0; j < tileHeight; j++)
            {
                for (int k = 0; k < tileWidth; k++)
                {
                    byte colorIdx = *ptr++;

                    if (colorIdx == 0xFF)
                        continue;

                    Rgb24 color = btm.Colors[colorIdx];
                    Rgba32 rgbaColor = new();
                    color.ToRgba32(ref rgbaColor);

                    image[k, j] = rgbaColor;
                }
            }

            images[i] = image;
        }

        btm.Tiles = images;
    }

    private static unsafe void ReadMP(BTM btm, byte* ptr, bool reverse)
    {
        ushort magic = ReadValue<ushort>(ref ptr, reverse);

        if (magic != 0x4D50)
            return;

        byte mapWidth = *ptr++;
        byte mapHeight = *ptr++;

        byte[,] map = new byte[mapWidth, mapHeight];

        for (int i = 0; i < mapHeight; i++)
        {
            for (int j = 0; j < mapWidth; j++)
                map[j, i] = *ptr++;
        }

        btm.Map = map;
    }
}
