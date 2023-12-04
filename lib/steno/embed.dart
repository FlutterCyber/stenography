import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
class Embed{


  Future<Uint8List> embedMessageInImage(String imagePath, String secretMessage) async {
    // Read the input image
    final ByteData imageBytes = await rootBundle.load(imagePath);
    final Uint8List imageBytesList = imageBytes.buffer.asUint8List();
    img.Image? originalImage = img.decodeImage(imageBytesList);

    if (originalImage == null) {
      throw Exception('Could not decode the input image.');
    }

    // Check if the message is too large to embed
    if (secretMessage.length > (originalImage.length * 0.125).floor()) {
      throw Exception('The secret message is too large to embed in this image.');
    }

    // Embed the message in the image using LSB
    int messageIndex = 0;
    for (int y = 0; y < originalImage.height; y++) {
      for (int x = 0; x < originalImage.width; x++) {
        final pixel = originalImage.getPixel(x, y);
        int alpha = img.getAlpha(pixel);
        int red = img.getRed(pixel);
        int green = img.getGreen(pixel);
        int blue = img.getBlue(pixel);

        if (messageIndex < secretMessage.length) {
          final charCode = secretMessage.codeUnitAt(messageIndex);

          // Embed one bit of the character in each color channel
          red = (red & 0xFE) | ((charCode >> 6) & 0x01);
          green = (green & 0xFE) | ((charCode >> 5) & 0x01);
          blue = (blue & 0xFE) | ((charCode >> 4) & 0x01);

          messageIndex++;
        }

        final newPixel = img.getColor(alpha, red, green, blue);
        originalImage.setPixel(x, y, newPixel);
      }
    }

    // Encode the modified image
    final embeddedImageBytes = Uint8List.fromList(img.encodePng(originalImage));

    return embeddedImageBytes;
  }

}