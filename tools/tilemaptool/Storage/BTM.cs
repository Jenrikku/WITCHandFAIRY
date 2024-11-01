namespace Autumn.Storage;

// Binary tile map
internal class BTM
{
    /// <summary>
    /// Opens a binary tile map from a file in disk.
    /// </summary>
    /// <param name="path">The path to the btm file</param>
    public BTM(string path)
    {
        if (!File.Exists(path))
            return;

        byte[] file = File.ReadAllBytes(path);

        if (file[0] != 'J' || file[1] != 'k' || file[2] != 'B' || file[3] != 'M')
            return; // Magic was not correct
    }
}
