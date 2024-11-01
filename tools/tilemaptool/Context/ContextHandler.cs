using TilemapTool.Storage;

namespace TilemapTool.Context;

internal static class ContextHandler
{
    public static Tile[,] Map { get; } = new Tile[10, 10];
    public static List<Tile> TileSet { get; } = new();

    public static bool IsSaved { get; } = true; // TO-DO
}
