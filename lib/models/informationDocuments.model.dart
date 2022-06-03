import 'dart:io';

import 'package:flutter/cupertino.dart';

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
  double? validSelfie;
  bool active = false;

  InformationDocuments(dataRaw,
      {String? path, Image? imageFace, String? selfiePath, double? validPhoto}) {
    if (dataRaw != "") {
      this.dataRaw = dataRaw;
      _extractText(dataRaw);
      photoDocumen = File(path!);
      selfie = File(selfiePath!);
      if (imageFace != null) imageDNIFace = imageFace;
      validSelfie = validPhoto;
      hasData = true;
    }
  }

  _extractText(data) {
    final String dataAux = dataRaw.replaceAll(".", "");
    final dataSplitAux = dataAux.split('\n');
    final List<String> dataSplit = [];
    for (var element in dataSplitAux) {
      String temp = _getAllUppercase(element);
      if (temp.length > 1) {
        dataSplit.add(temp);
      }
    }

    final _id = _getnumberci(dataAux);
    id = _id != null ? _getDataFormtatNumber(_id, 3, ".") : null;

    var index = 0;
    for (var i = 0; i < dataSplit.length - 1; i++) {
      if (dataSplit[i].contains(_id!)) {
        index = i;
        i = 100;
      }
    }
    lastname = _getName(dataSplit[index + 1]); //dataSplit[index + 2];
    name = _getName(dataSplit[index + 2]); //dataSplit[index + 1];
    dateOfBirth = _getDateOfBirth(dataAux.replaceAll(_id!, ""));
    active = _getDateExp(dataAux.replaceAll(_id, ""));
  }

  String? _getnumberci(data) {
    final _regExp = RegExp(r"([0-9]{7,8})");
    final match = _regExp.firstMatch(data);
    final matchedText = match?.group(0);
    return matchedText;
  }

  _getDateExp(data) {
    final _regExpVencimiento = RegExp(r"([0-9]{6,6})");
    Iterable<RegExpMatch> matches = _regExpVencimiento.allMatches(data);
    final now = DateTime.now();
    var result = false;
    for (RegExpMatch match in matches) {
      final date = data.substring(match.start + 2, match.end);
      if (now.year > int.parse(date)) {
        //revisa, cambiar condicion para que la fecha no este vencida
        result = true;
      }
    }
    return result;
  }

  _getDateOfBirth(data) {
    final _regExp = RegExp(r"([0-9]{6,6})");
    final match = _regExp.firstMatch(data);
    final matchedText = match?.group(0);
    return matchedText != null
        ? _getDataFormtatNumber(matchedText, 2, "-")
        : null;
  }

  String _getAllUppercase(data) {
    final _regExp = RegExp(r"([0-9A-Z\s])");
    Iterable<RegExpMatch> matches = _regExp.allMatches(data);
    List<String> result = [];
    for (RegExpMatch match in matches) {
      result.add(data.substring(match.start, match.end));
    }
    return result.join("").trim();
  }

  String _getName(data) {
    final _regExp = RegExp(r"([A-Z\s])");
    Iterable<RegExpMatch> matches = _regExp.allMatches(data);
    List<String> result = [];
    for (RegExpMatch match in matches) {
      result.add(data.substring(match.start, match.end));
    }
    final tempResult = result.join("").trim().split(' ');
    return tempResult[0] + " " + (tempResult[1] ?? '');
  }

  String _getDataFormtatNumber(String data, int length, String chart) {
    final dataAux = data.split("").reversed.join("");
    List<String> result = [];
    // result.add(dataAux.substring(0, 3));
    // result.add(dataAux.substring(3, 6));
    // result.add(dataAux.substring(6, data.length == 8 ? 8 : 7));
    for (var i = 0; i < data.length - 1; i = i + length) {
      final to = ((i + length) < (data.length - 1)) ? i + length : data.length;
      result.add(dataAux.substring(i, to));
    }
    final resultaAux = result.join(chart);
    return resultaAux.split("").reversed.join();
  }
}
