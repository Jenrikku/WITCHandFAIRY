using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;

internal static class ImageExt
{
    /// <summary>
    /// Checks if two images are equal pixel-wise.
    /// </summary>
    /// <typeparam name="TPixel">The type of the pixel in both images</typeparam>
    /// <param name="image1">The first image to compare</param>
    /// <param name="image2">The second image to compare</param>
    /// <returns>0 is both images are equal, a substraction of both pixels</returns>
    /// <exception cref="ArgumentException">If both images are not of the same dimensions</exception>
    public static bool Equals<TPixel>(this Image<TPixel> image1, Image<TPixel> image2)
        where TPixel : unmanaged, IPixel<TPixel>
    {
        if (image1.Width != image2.Width || image1.Height != image2.Height)
            throw new ArgumentException("Cannot compare images of different dimensions.");

        for (int y = 0; y < image1.Height; y++)
        {
            for (int x = 0; x < image1.Width; x++)
            {
                if (!image1[x, y].Equals(image2[x, y]))
                    return false;
            }
        }

        return true;
    }
}
