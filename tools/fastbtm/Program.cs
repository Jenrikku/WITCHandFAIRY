using System.Diagnostics;
using LibBTM;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;

const byte tileWidth = 16;
const byte tileHeight = 16;

const byte mapWidth = 10;
const byte mapHeight = 10;

const string mapImage = "in.png";
const string output = "out.btm";

const bool generateMap = true; // Disable for only tilesets.

byte[,] map;

if (generateMap)
    map = new byte[mapWidth, mapHeight];

Image<Rgba32> image = Image.Load<Rgba32>(mapImage);

if (image.Width % tileWidth != 0 || image.Height % tileHeight != 0)
{
    Console.WriteLine("Image incorrectly sized.");
    return;
}

List<Image<Rgba32>> tiles = new();

image.ProcessPixelRows(accessor =>
{
    Rgba32 pixel = Color.Transparent;

    for (int k = 0; k < accessor.Height; k += tileHeight)
    {
        for (int l = 0; l < accessor.Width; l += tileWidth)
        {
            Image<Rgba32> tile = new(tileWidth, tileHeight);

            for (int y = 0; y < tileHeight; y++)
            {
                Span<Rgba32> row = accessor.GetRowSpan(k + y);

                for (int x = 0; x < tileWidth; x++)
                {
                    tile[x, y] = row[l + x];
                }
            }

            if (!tiles.Where(img => img.Equals<Rgba32>(tile)).Any())
                tiles.Add(tile);

            if (generateMap)
            {
                int index = tiles.FindIndex(img => img.Equals<Rgba32>(tile));

                Debug.Assert(index != -1);

                map[l / tileWidth, k / tileHeight] = (byte)index;
            }
        }
    }
});

BTM btm = new(tiles.ToArray(), map, mapWidth, mapHeight);

btm.Write(output);
