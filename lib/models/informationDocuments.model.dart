class InformationDocuments {
  InformationDocuments(dataRaw) {
    this.dataRaw = dataRaw;
    if (dataRaw != "") {
      final String dataAux = dataRaw.replaceAll(".", "");
      final dataSplit = dataAux.split('\n');
      id = _getnumberci(dataAux);
      var index = 0;
      for (var i = 0; i < dataSplit.length - 1; i++) {
        if (dataSplit[i].indexOf(id!) > -1) {
          index = i;
        }
      }
      name = dataSplit[index + 1];
      lastname = dataSplit[index + 2];
      active = _getDateExp(dataAux);
      hasData = true;
    }
  }
  bool hasData = false;
  late String dataRaw;
  String? id;
  String? name;
  String? lastname;
  String? dateOfBirth;
  bool active = false;

  // final _regExp = RegExp(r"([0-9])");
  final _regExp = RegExp(r"([0-9]{7,8})");
  _getnumberci(data) {
    final match = _regExp.firstMatch(data);
    final matchedText = match?.group(0);
    return matchedText;
  }

  _getDateExp(data) {
    final _regExpVencimiento = RegExp(r"([0-9]{6,6})");
    Iterable<RegExpMatch> matches = _regExpVencimiento.allMatches(data);

    final now = DateTime.now();
    var result = false;
    for(RegExpMatch match in matches) {
      // print("${data.substring(match.start, match.end)}");
      final date = data.substring(match.start, match.end);
      if (now.year < int.parse(date) ) {
        result = true;
      }
    }
    return result;
  }
}
