import 'dart:io';

import 'package:flutter/cupertino.dart';

class InformationOcrRequest {
  late bool process = false;
  String? dataRaw = "";
  String? id;
  String? name;
  String? lastname;
  String? dateOfBirth;
  String? expiration;
}

class ValidFace {
  late bool process = false;
  late double? diff;
  late double? distance;
}

class InformationDocuments {
  bool hasData = false;
  late String dataRaw = "";
  String? id;
  String? name;
  String? lastname;
  String? dateOfBirth;
  File? photoDocumen;
  File? selfie;
  Image? imageDNIFace;
  InformationOcrRequest? dataOrc;
  ValidFace? valid;
  bool active = false;

  InformationDocuments(dataRaw,
      {InformationOcrRequest? dataOrc,
      ValidFace? valid,
      String? path,
      Image? imageFace,
      String? selfiePath}) {
    if (dataRaw != "") {
      this.dataRaw = dataRaw;
      this.dataOrc = dataOrc;
      this.valid = valid;
      _extractText(dataOrc);
      photoDocumen = File(path!);
      selfie = File(selfiePath!);
      if (imageFace != null) imageDNIFace = imageFace;
      hasData = true;
    }
  }

  _extractText(data) {
    id = data!.id;
    name = data!.name;
    lastname = data!.lastname;
    dateOfBirth = data!.dateOfBirth;
    // active
    active = true;
  }

}
