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

byte[,] map = new byte[0, 0];

if (generateMap)
    map = new byte[mapWidth, mapHeight];

Image<Rgba32> image = Image.Load<Rgba32>(mapImage);

if (image.Width % tileWidth != 0 || image.Height % tileHeight != 0)
{
    Console.WriteLine("Image incorrectly sized.");
    return;
}

List<Image<Rgba32>> tiles = new();

// Add empty tile (not added to the btm file)
tiles.Add(new(tileWidth, tileHeight));

image.ProcessPixelRows(accessor =>
{
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
                int index = tiles.FindIndex(img => img.Equals<Rgba32>(tile)) - 1;
                map[k / tileHeight, l / tileWidth] = (byte)index;
            }
        }
    }
});

BTM btm = new(tiles.Skip(1).ToArray(), map, mapWidth, mapHeight) { IsBigEndian = false };

btm.Write(output);
