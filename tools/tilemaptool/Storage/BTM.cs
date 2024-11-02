using SixLabors.ImageSharp.PixelFormats;
using static TilemapTool.Utils.ValueParser;

namespace TilemapTool.Storage;

/// <summary>
/// Class that represents a Binary Tile Map file.
/// </summary>
internal class BTM
{
    public bool IsBigEndian { get; set; } = true;

    public Rgb24[] Colors { get; private set; }

    /// <summary>
    /// Opens a binary tile map from a file in disk.
    /// </summary>
    /// <param name="path">The path to the btm file</param>
    /// <returns>A BTM with the read data</returns>
    public static unsafe BTM Read(string path)
    {
        BTM btm = new();

        byte[] contents = File.ReadAllBytes(path);
        fixed (byte* start = contents)
        {
            byte* ptr = start;
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
            ReadCOL(btm, ptr, reverse);

            ptr = start + imgOffset;
            ReadIMG(btm, ptr, reverse);

            if (mapOffset != 0)
            {
                ptr = start + mapOffset;
                ReadMAP(btm, ptr, reverse);
            }
        }

        return btm;
    }

    private static unsafe void ReadCOL(BTM btm, byte* ptr, bool reverse)
    {
        byte magic0 = ReadValue<byte>(ref ptr, reverse);
        byte magic1 = ReadValue<byte>(ref ptr, reverse);
        byte magic2 = ReadValue<byte>(ref ptr, reverse);

        if (magic0 != 'C' || magic1 != 'O' || magic2 != 'L')
            return;

        byte colorCount = ReadValue<byte>(ref ptr, reverse);
        btm.Colors = ReadValues<Rgb24>(ref ptr, reverse, colorCount);
    }

    private static unsafe void ReadIMG(BTM btm, byte* ptr, bool reverse)
    {
        byte magic0 = ReadValue<byte>(ref ptr, reverse);
        byte magic1 = ReadValue<byte>(ref ptr, reverse);
        byte magic2 = ReadValue<byte>(ref ptr, reverse);

        if (magic0 != 'I' || magic1 != 'M' || magic2 != 'G')
            return;
    }

    private static unsafe void ReadMAP(BTM btm, byte* ptr, bool reverse)
    {
        byte magic0 = ReadValue<byte>(ref ptr, reverse);
        byte magic1 = ReadValue<byte>(ref ptr, reverse);
        byte magic2 = ReadValue<byte>(ref ptr, reverse);

        if (magic0 != 'M' || magic1 != 'A' || magic2 != 'P')
            return;
    }
}
