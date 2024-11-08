using LibBTM;

namespace TilemapTool.Context;

internal static class ContextHandler
{
    public static BTM? BTM { get; private set; }

    public static bool IsSaved { get; set; } = true;

    /// <summary>
    /// Reads a BTM and sets it as the current opened one.
    /// </summary>
    /// <param name="path">The path to the BTM</param>
    /// <returns>Whether it was read correctly</returns>
    public static bool ReadBTM(string path)
    {
        if (!BTM.Identify(path))
            return false;

        BTM = BTM.Read(path);
        return true;
    }
}
