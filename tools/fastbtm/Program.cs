using LibBTM;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;

const byte tileWidth = 16;
const byte tileHeight = 16;

const byte mapWidth = 10;
const byte mapHeight = 10;

const string tiles = "in.png";
const string output = "out.btm";

byte[,] map = new byte[,]
{
    { 1 }
};

Image<Rgba32> image = Image.Load<Rgba32>(tiles);

if (image.Width % tileWidth != 0 || image.Height % tileHeight != 0)
{
    Console.WriteLine("Image incorrectly sized.");
    return;
}

List<Image<Rgba32>> images = new();

image.ProcessPixelRows(accessor =>
{
    Rgba32 pixel = Color.Transparent;

    for (int k = 0; k < accessor.Height; k += tileHeight)
    {
        Image<Rgba32> tile = new(tileWidth, tileHeight);

        for (int y = 0; y < tileHeight; y++)
        {
            Span<Rgba32> row = accessor.GetRowSpan(k + y);

            for (int l = 0; l < accessor.Width; l += tileWidth)
            {
                for (int x = 0; x < tileWidth; x++)
                {
                    tile[x, y] = row[l + x];
                }
            }
        }
    }
});

BTM btm = new(images.ToArray(), map, mapWidth, mapHeight);

BTM.Write(btm, output);
