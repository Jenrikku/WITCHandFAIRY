using System.Text;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;

static void Help(int exitCode)
{
    string helpStr =
        @"Usage: image2x68 [options] <filename>
    
    Options:
        -h / --help: Show this message.
        -n / --name <name>: Sets the name used to generate comments optionally.
        -o / --output <filename>: Specifies where to save the resulting file instead of printing it.
        -p / --prefix <name>: Sets the prefix for generated variables. IMG by default.";

    Console.WriteLine(helpStr);
    Environment.Exit(exitCode);
}

void EnsureNextArgument(int current)
{
    if (args.Length >= current + 1)
        return;

    Console.WriteLine("Error: Not enough arguments.\n");
    Help(1);
}

void EnsureFileExists(string file)
{
    if (File.Exists(file))
        return;

    Console.WriteLine($"Error: {file} is not a valid file.");
    Environment.Exit(1);
}

string PixelToBGRHexString(Rgba32 pixel)
{
    return pixel.B.ToString("X2") + pixel.G.ToString("X2") + pixel.R.ToString("X2");
}

// Program starts here:

#region Argument parsing

EnsureNextArgument(0);

string? input = null;
string? output = null;
string? name = null;
string prefix = "IMG";

for (int i = 0; i < args.Length; i++)
{
    switch (args[i])
    {
        case "-h":
            goto case "--help";
        case "--help":
            Help(0);
            break;

        case "-o":
            goto case "--output";
        case "--output":
            EnsureNextArgument(i);
            output = args[++i];
            break;

        case "-n":
            goto case "--name";
        case "--name":
            EnsureNextArgument(i);
            name = args[++i];
            break;

        case "-p":
            goto case "--prefix";
        case "--prefix":
            EnsureNextArgument(i);
            prefix = args[++i].ToUpperInvariant();
            break;

        default:
            EnsureFileExists(args[i]);
            input = args[i];

            break;
    }
}

if (input is null)
{
    Console.WriteLine("You must specify a file.");
    return;
}

if (prefix.Length != 3)
{
    Console.WriteLine("The prefix must be of exactly 3 characters.");
    return;
}

#endregion

#region Read image

Image<Rgba32> image;

try
{
    image = Image.Load<Rgba32>(input);
}
catch
{
    Console.WriteLine("Invalid image format for file: " + input);
    Environment.Exit(1);
    return;
}

// Ensure image is a tileset.
if (image.Height % 16 != 0 || image.Width % 16 != 0)
{
    Console.WriteLine("The given image is not a proper 16×16 tileset.");
    return;
}

#endregion

#region Build the file

StringBuilder builder = new();

// Header:

if (name is not null)
{
    builder.Append($"; --- {name} ");
    int l = 80 - name.Length - 7;

    for (int i = 0; i < l; i++)
        builder.Append('-');

    builder.Append("\r\n\r\n");
}

// Width and height:

builder.Append($"{prefix}WIDTH     EQU     {image.Width / 16}");

if (name is not null)
    builder.Append($"                     ; {name} tileset width");

builder.Append("\r\n");

builder.Append($"{prefix}HEIGH     EQU     {image.Height / 16}");

if (name is not null)
    builder.Append($"                     ; {name} tileset height");

builder.Append("\r\n\r\n");

// Generate indexed color matrix:

List<Rgba32> colors = new();
int[,] indexedMatrix = new int[image.Width, image.Height];

for (int i = 0; i < image.Width; i++)
{
    for (int j = 0; j < image.Height; j++)
    {
        Rgba32 pixel = image[i, j];

        if (pixel.A < 128) // If alpha is less than half the max value of a byte.
        {
            indexedMatrix[i, j] = 0xFF;
            continue;
        }

        if (!colors.Contains(pixel))
        {
            colors.Add(pixel);
            indexedMatrix[i, j] = colors.Count - 1;
            continue;
        }

        indexedMatrix[i, j] = colors.IndexOf(pixel);
    }
}

// Color palette:

builder.Append($"{prefix}COLOR");

for (int i = 0; i < colors.Count; i++)
{
    string rgb = PixelToBGRHexString(colors[i]);

    if (i != 0)
        builder.Append("        "); // Alignment: 8 whitespaces.

    builder.Append($"     DC.L     $00{rgb}\r\n");
}

// Texture array:

// TO-DO

#endregion

#region Output

string result = builder.ToString();

if (output is not null)
{
    File.WriteAllText(output, result, Encoding.GetEncoding("ISO-8859-15"));
    return;
}

Console.WriteLine(result);

#endregion
