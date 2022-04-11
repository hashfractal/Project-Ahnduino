using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Drawing;

namespace Ahnduino
{
    internal class Imagetostr
    {
        static void ImageToStr(string f)
        {
            fileName = fileName.ToLower(); // string 경로
            string imageToString = string.Empty;

            if (fileName.Contains(".png") || fileName.Contains(".jpg"))
            {
                FileInfo fileInfo = new FileInfo(fileName);
                if (!fileInfo.Exists)
                    return;

                using (MemoryStream memoryStream = new MemoryStream())
                {
                    var bitmap = new Bitmap(fileName);
                    bitmap.Save(memoryStream, bitmap.RawFormat);

                    byte[] bitmapByte = memoryStream.ToArray();
                    imageToString = Convert.ToBase64String(bitmapByte);
                }
            }

            if (string.IsNullOrEmpty(imageToString))
            {
                MemoryStream stringToImage = new MemoryStream(Convert.FromBase64String(imageToString));
                var bitmap = new Bitmap(imageToString);
                // bitmap 로직 처리
            }
        }
    }
}
