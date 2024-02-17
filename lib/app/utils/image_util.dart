import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;

class ImageResizer {
  static Future<void> resizeAndSaveImage(
      Uint8List imageData, int width, int height, String filePath) async {
    // Decode the image from Uint8List
    img.Image originalImage = img.decodeImage(imageData)!;

    // Resize the image
    img.Image resizedImage = img.copyResize(
      originalImage,
      width: width,
      height: height,
      interpolation: img.Interpolation.cubic,
    );

    // Save the resized image to a file
    File file = File(filePath);
    await file.writeAsBytes(
      img.encodePng(resizedImage),
    );
  }
}
