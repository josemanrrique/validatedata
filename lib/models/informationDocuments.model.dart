class InformationDocuments {
  InformationDocuments(dataRaw) {
    this.dataRaw = dataRaw;
    if(dataRaw != ""){
      hasData = true;
    }
  }
  bool hasData = false;
  late String dataRaw;
  String? test;
}
