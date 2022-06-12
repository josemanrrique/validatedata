import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:ui';

import 'package:crop_image/crop_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readdata/models/informationDocuments.model.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';

class DataTextExtract {
  static InformationDocuments captureData(InformationOcrRequest dataOrc,
      ValidFace valid, File? pickedFile, Image image, File? selfie) {
    // File? _pickedImage;
    // _pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    InformationDocuments extractText = InformationDocuments("");
    if (pickedFile?.path != null) {
      extractText = InformationDocuments(
        dataOrc.dataRaw,
        dataOrc: dataOrc,
        valid: valid,
        path: pickedFile!.path,
        imageFace: image,
        selfiePath: selfie!.path,
      );
      // _extractText = await FlutterTesseractOcr.extractText(pickedFile.path, language: 'spa+eng',
      //   args: {
      //     "psm": "4",
      //     "preserve_interword_spaces": "1",
      //   });

    }
    return extractText;
  }

  static Future<File> readPhoto() async {
    final picker = ImagePicker();
    // PickedFile? pickedFile =
    //     await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxWidth: 1000,
      // maxHeight: 360,
    );
    File compressedFile = await compress(pickedFile!.path);
    return compressedFile;
    // return File(pickedFile!.path);
  }

  static Future<File> compress(String path) async {
    File compressedFile = await FlutterNativeImage.compressImage(
      path,
      quality: 90,
    );
    return compressedFile;
    // return File(pickedFile!.path);
  }

  static Future<File> getImgCi(CropController crop) async {
    final imageFace2 = await crop.croppedBitmap();
    imageFace2.toByteData();
    final data = await imageFace2.toByteData(
      format: ImageByteFormat.png,
    );
    return await writeToFile(data!);
  }

  static const String _baseUrl = 'ocr-face.herokuapp.com';
  static Future<ValidFace> validData(CropController crop, File selfie) async {
    final url = Uri.https(_baseUrl, '/validatFace');
    final request = http.MultipartRequest('POST', url);
    request.headers['Accept'] = 'application/json';

    final imageFace2 = await crop.croppedBitmap();
    imageFace2.toByteData();
    final data = await imageFace2.toByteData(
      format: ImageByteFormat.png,
    );
    final faceCrop = await convertFile(await writeToFile(data!));

    final faceDocumen = http.MultipartFile.fromBytes('faceDocument', faceCrop);
    request.files.add(faceDocumen);

    final face =
        http.MultipartFile.fromBytes('selfie', await selfie.readAsBytes());
    request.files.add(face);
    ValidFace result = ValidFace();
    try {
      final streamResponse = await request.send();
      final resp = await http.Response.fromStream(streamResponse);
      final Map<String, dynamic> decodedResp = json.decode(resp.body);
      if (decodedResp["error"] ?? true) {
        result.process = true;
        result.distance = double.parse(decodedResp["distance"]);
        result.diff = double.parse(decodedResp["diff"]);
      }
    } catch (e) {
      result = ValidFace();
    }
    // final selfiePhoto = await convertFile(File(selfie));

    // var result = await compareImages(
    //     src1: face, src2: selfiePhoto, algorithm: PixelMatching());
    return result; //result;
  }

  static Future<InformationOcrRequest> getOcrApi(File? pickedFilee) async {
    final url = Uri.https(_baseUrl, '/extract');
    final request = http.MultipartRequest('POST', url);
    request.headers['Accept'] = 'application/json';

    final faceDocumen = http.MultipartFile.fromBytes(
        'documentPhoto', await pickedFilee!.readAsBytes());
    request.files.add(faceDocumen);
    InformationOcrRequest result = InformationOcrRequest();
    try {
      final streamResponse = await request.send();
      final resp = await http.Response.fromStream(streamResponse);
      final Map<String, dynamic> decodedResp = json.decode(resp.body);
      if (decodedResp["error"] ?? true) {
        result.process = true;
        result.dataRaw = decodedResp["dataRaw"];
        result.id = decodedResp["id"];
        result.name = decodedResp["name"];
        result.lastname = decodedResp["lastname"];
        result.dateOfBirth = decodedResp["dateOfBirth"];
        result.expiration = decodedResp["expiration"];
      }
    } catch (e) {
      result = InformationOcrRequest();
    }
    // final selfiePhoto = await convertFile(File(selfie));

    // var result = await compareImages(
    //     src1: face, src2: selfiePhoto, algorithm: PixelMatching());
    return result; //result;
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
    return File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
