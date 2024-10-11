string helpStr =
    @"Usage: image2x68 [options] <filename>
    
    Options:
        -m / --minimal: Only outputs the value matrix of the file instead of an entire .x68 file.
        -o / --output <filename>: Specifies where to save the resulting file instead of printing it.";

if (args.Length < 1)
{
    Console.WriteLine(helpStr);
    return;
}
