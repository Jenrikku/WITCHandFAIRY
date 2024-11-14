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

    public Rgba32[] Colors { get; private set; } = [];

    public Image<Rgba32>[] Tiles { get; private set; } = [];

    public byte[,] Map { get; private set; } = { };

    public byte MapWidth { get; private set; }
    public byte MapHeight { get; private set; }

    private BTM() { }

    public BTM(Image<Rgba32>[] tiles, byte[,] map)
    {
        Tiles = tiles;
        Map = map;

        HashSet<Rgba32> colors = new();

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
                    colors.Add(color);
                }
            }
        }

        Colors = colors.ToArray();
    }

    /// <summary>
    /// Checks if the file is a BTM by looking at the magic value.
    /// </summary>
    /// <param name="path">The path to the BTM file</param>
    /// <returns>Whether the file has the proper BTM magic</returns>
    public static unsafe bool Identify(string path)
    {
        if (!File.Exists(path))
            return false;

        using FileStream stream = File.OpenRead(path);

        Span<byte> magic = stackalloc byte[4];
        stream.ReadExactly(magic);

        fixed (byte* ptr = magic)
            return Identify(ptr);
    }

    public static unsafe bool Identify(byte* ptr)
    {
        uint magic = ReadValue<uint>(ref ptr, false);

        return magic == 0x4A6B424D || magic == 0x4D426B4A;
    }

    /// <summary>
    /// Opens a binary tile map from a file in disk.
    /// </summary>
    /// <param name="path">The path to the BTM file</param>
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
        size += btm.Colors.Length * 4;
        size += 16 - (size % 16 == 0 ? 16 : size % 16);
        size += btm.Tiles.Length * btm.Tiles[0].Height * btm.Tiles[0].Width;
        size += 16 - (size % 16 == 0 ? 16 : size % 16);
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

        foreach (Rgba32 color in btm.Colors)
            WriteValue(ref ptr, color with { A = 0 }, reverse);

        // Tileset section:

        Align(ref ptr, start, 16);
        uint tsOffset = (uint)(start - ptr);

        byte tileWidth = (byte)btm.Tiles[0].Width;
        byte tileHeight = (byte)btm.Tiles[0].Height;

        WriteValue<ushort>(ref ptr, 0x5453, reverse);
        *ptr++ = (byte)btm.Tiles.Length;
        *ptr++ = tileWidth;
        *ptr++ = tileHeight;

        foreach (Image<Rgba32> image in btm.Tiles)
        {
            for (int i = 0; i < tileHeight; i++)
            {
                for (int j = 0; j < tileWidth; j++)
                {
                    Rgba32 pixel = image[j, i];

                    if (pixel.A != 0xFF)
                    {
                        *ptr++ = 0xFF;
                        continue;
                    }

                    int index = Array.IndexOf(btm.Colors, new(pixel.R, pixel.G, pixel.B));

                    if (index < 0)
                    {
                        *ptr++ = 0xFF;
                        continue;
                    }

                    *ptr++ = (byte)index;
                }
            }
        }

        // Map section:

        Align(ref ptr, start, 16);
        uint mapOffset = (uint)(start - ptr);

        WriteValue<ushort>(ref ptr, 0x4D50, reverse);
        *ptr++ = btm.MapWidth;
        *ptr++ = btm.MapHeight;

        foreach (byte tileIdx in btm.Map)
            *ptr++ = tileIdx;

        // Header offsets:

        ptr = start + 8;
        WriteValue(ref ptr, tsOffset, reverse);
        WriteValue(ref ptr, mapOffset, reverse);
    }

    private static unsafe void ReadCL(BTM btm, byte* ptr, bool reverse)
    {
        ushort magic = ReadValue<ushort>(ref ptr, reverse);

        if (magic != 0x434C)
            return;

        byte colorCount = *ptr++;
        btm.Colors = ReadValues<Rgba32>(ref ptr, reverse, colorCount);

        for (int i = 0; i < colorCount; i++)
            btm.Colors[i].A = 0xFF;
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

                    image[k, j] = btm.Colors[colorIdx];
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
        btm.MapWidth = mapWidth;
        btm.MapHeight = mapHeight;
    }
}
