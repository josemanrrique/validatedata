import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:readdata/models/informationDocuments.model.dart';
import 'package:image_compare/image_compare.dart';
import 'package:path_provider/path_provider.dart';

class DataTextExtract {
  static Future<InformationDocuments> captureData(
      XFile? pickedFile, Image image, XFile? selfie) async {
    // File? _pickedImage;
    // _pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    InformationDocuments extractText = InformationDocuments("");
    if (pickedFile?.path != null) {
      extractText = InformationDocuments(
          await FlutterTesseractOcr.extractText(pickedFile!.path,
              language: 'spa',
              args: {
                "psm": "4",
                "preserve_interword_spaces": "1",
              }),
          path: pickedFile.path,
          imageFace: image,
          selfiePath: selfie!.path);
      // _extractText = await FlutterTesseractOcr.extractText(pickedFile.path, language: 'spa+eng',
      //   args: {
      //     "psm": "4",
      //     "preserve_interword_spaces": "1",
      //   });

    }
    return extractText;
  }

  static Future<XFile?> readPhoto() async {
    final picker = ImagePicker();
    // PickedFile? pickedFile =
    //     await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    return pickedFile;
  }

  static Future<double> validData(CropController crop, String selfie) async {
    final imageFace2 = await crop.croppedBitmap();
    imageFace2.toByteData();
    final data = await imageFace2.toByteData(
      format: ImageByteFormat.png,
    );
    final face = await convertFile(await writeToFile(data!));
    final selfiePhoto =  await convertFile(File(selfie));

    var result = await compareImages(
        src1: face, src2: selfiePhoto, algorithm: PixelMatching());
    return 0; //result;
  }

  static Future<Uint8List> convertFile(File data) async {
    return await data.readAsBytes();
  }
  static Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        tempPath + '/file_01.tmp'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
