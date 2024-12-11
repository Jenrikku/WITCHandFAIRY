using LibBTM;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;

namespace TilemapTool.Context;

internal static class ContextHandler
{
    public static BTM BTM { get; private set; } = new([], new byte[0, 0]);

    public static bool IsSaved { get; private set; } = true;

    public static string? SavePath { get; set; }

    public static void Reset()
    {
        BTM = new([], new byte[0, 0]);
        IsSaved = true;
        SavePath = null;
    }

    /// <summary>
    /// Creates a new BTM with the given arguments.
    /// </summary>
    /// <param name="tiles">The tiles of the btm</param>
    /// <param name="map">The map data</param>
    public static void NewBTM(Image<Rgba32>[] tiles, byte[,] map)
    {
        BTM = new(tiles, map);
        IsSaved = false;
    }

    /// <summary>
    /// Reads a BTM and sets it as the currently opened one.
    /// </summary>
    /// <param name="path">The path to the BTM</param>
    /// <returns>Whether it was read correctly</returns>
    public static bool ReadBTM(string path)
    {
        if (!BTM.Identify(path))
            return false;

        BTM = BTM.Read(path);
        IsSaved = true;
        return true;
    }

    /// <summary>
    /// Writes the current BTM to a file.
    /// </summary>
    /// <param name="path">The path where to write the BTM</param>
    public static void WriteBTM(string path)
    {
        if (BTM is null)
            return;

        btm.Write(path);
        IsSaved = false;
    }
}
