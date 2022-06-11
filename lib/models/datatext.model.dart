import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:crop_image/crop_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readdata/models/informationDocuments.model.dart';

class DataTextExtract {
  static InformationDocuments captureData(InformationOcrRequest dataOrc,
      ValidFace valid, XFile? pickedFile, Image image, XFile? selfie) {
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

  static Future<XFile?> readPhoto() async {
    final picker = ImagePicker();
    // PickedFile? pickedFile =
    //     await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    return pickedFile;
  }

  static const String _baseUrl = 'ocr-face.herokuapp.com';
  static Future<ValidFace> validData(CropController crop, XFile selfie) async {
    final url = Uri.https(_baseUrl, '/validatFace');
    final request = http.MultipartRequest('POST', url);
    request.headers['Accept'] = 'application/json';

    final faceDocumen = http.MultipartFile.fromBytes(
        'faceDocument', await selfie.readAsBytes());
    request.files.add(faceDocumen);
    final face =
        http.MultipartFile.fromBytes('selfie', await selfie.readAsBytes());
    request.files.add(face);
    final streamResponse = await request.send();
    final resp = await http.Response.fromStream(streamResponse);
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    ValidFace result = ValidFace();
    if (decodedResp["error"] ?? true) {
      result.process = true;
      result.distance = double.parse(decodedResp["distance"]);
      result.diff = double.parse(decodedResp["diff"]);
    }
    // final selfiePhoto = await convertFile(File(selfie));

    // var result = await compareImages(
    //     src1: face, src2: selfiePhoto, algorithm: PixelMatching());
    return result; //result;
  }

  static Future<InformationOcrRequest> getOcrApi(XFile? pickedFilee) async {
    final url = Uri.https(_baseUrl, '/extract');
    final request = http.MultipartRequest('POST', url);
    request.headers['Accept'] = 'application/json';

    final faceDocumen = http.MultipartFile.fromBytes(
        'documentPhoto', await pickedFilee!.readAsBytes());
    request.files.add(faceDocumen);

    final streamResponse = await request.send();
    final resp = await http.Response.fromStream(streamResponse);
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    InformationOcrRequest result = InformationOcrRequest();
    if (decodedResp["error"] ?? true) {
      result.process = true;
      result.dataRaw = decodedResp["dataRaw"];
      result.id = decodedResp["id"];
      result.name = decodedResp["name"];
      result.lastname = decodedResp["lastname"];
      result.dateOfBirth = decodedResp["dateOfBirth"];
      result.expiration = decodedResp["expiration"];
    }
    // final selfiePhoto = await convertFile(File(selfie));

    // var result = await compareImages(
    //     src1: face, src2: selfiePhoto, algorithm: PixelMatching());
    return result; //result;
  }

  static Future<Uint8List> convertFile(File data) async {
    return await data.readAsBytes();
  }
}
