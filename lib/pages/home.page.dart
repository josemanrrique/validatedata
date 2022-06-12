import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readdata/components/informationPerson.component.dart';
import 'package:readdata/models/datatext.model.dart';
import 'package:readdata/models/informationDocuments.model.dart';

// import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:crop_image/crop_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = false;
  InformationDocuments _extractText = InformationDocuments("");
  InformationOcrRequest _dataOrc = InformationOcrRequest();
  ValidFace _validFace = ValidFace();
  Image? _imageFace;
  File? _selfie;
  bool show = false;

  CropController controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  late File? _pickedFile;
  late String step = "information";
  // @override
  // void initState() {
  //   super.initState();
  //   controller = CustomImageCropController();
  // }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: Text(_getTitleCurrent()),
      ),
      body: _getStepCurrent(),
      // body: show
      //     ? Container(
      //         child: Image.file(
      //           File(_pickedFile!.path),
      //           fit: BoxFit.cover,
      //         ),
      //       )
      //     : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: captureData,
        tooltip: 'Next Step',
        child: _getIconFloatingActionButton(),
      ), //
    );
  }

  _getIconFloatingActionButton() {
    switch (step) {
      case "cropCI":
        return const Icon(Icons.crop);
      case "cropFace":
        return const Icon(Icons.crop);
      case "process":
        return const Icon(Icons.restore_rounded);
      default:
        return const Icon(Icons.camera);
    }
  }

  _testcaptureData() async {
    if (!show) {
      final pickedFileTemp = await DataTextExtract.readPhoto();

      show = true;
      setState(() {});
    } else {
      show = false;
      setState(() {});
    }
  }

  validState() {
    if ((_dataOrc.process) && (_validFace.process)) {
      _extractText = DataTextExtract.captureData(
          _dataOrc, _validFace, _pickedFile, _imageFace!, _selfie);
      _loading = false;
      setState(() {});
      //  // _extractText =
      //   //     await DataTextExtract.captureData(_pickedFile, imageFace, selfie, validFace);
      //   _loading = false;
    }
    // _dataOrc;
    // _imageFace;
    // _pickedFile;
    // _selfie;
    // _validFace;
  }

  captureData() async {
    switch (step) {
      case "information":
        _pickedFile = await DataTextExtract.readPhoto();
        step = "cropCI";
        break;
      case "cropCI":
        final img = await DataTextExtract.getImgCi(controller);
        DataTextExtract.getOcrApi(_pickedFile!)
            .then((value) => {_dataOrc = value, validState()});
        step = "cropFace";
        break;
      case "cropFace":
        step = "selfie";
        break;
      case "selfie":
        _imageFace = await controller.croppedImage();
        _selfie = await DataTextExtract.readPhoto();
        // final validFace = await DataTextExtract.validData(controller, _selfie!);
        DataTextExtract.validData(controller, _selfie!)
            .then((value) => {_validFace = value, validState()});
        _loading = true;
        step = "process";
        break;
      default:
        step = "information";
        _extractText = InformationDocuments("");
        _dataOrc = InformationOcrRequest();
        _validFace = ValidFace();
        controller = CropController(
          aspectRatio: 1,
          defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
        );
        break;
    }
    setState(() {});
  }

  _getStepCurrent() {
    switch (step) {
      case "information":
        return _getStepInformation();
      case "cropCI":
        return _getStepcropCI();
      case "cropFace":
        return _getStepcropFace();
      case "selfie":
        return _getStepSelfie();
      case "process":
        return _loading ? _getLoading() : _getStepData();
      default:
        return _getStepInformation();
    }
  }

  String _getTitleCurrent() {
    switch (step) {
      case "cropCI":
        return "Seleccione la ci";
      case "cropFace":
        return "Seleccione el rostro";
      case "process":
        return _loading ? "Extrayendo datos" : "Datos extraidos";
      default:
        return "OCR Venezuela";
    }
  }

  _getStepInformation() {
    return ListView(
      children: [
        Container(
          child: const Text(
            "Escanee un documento para comenzar y luego seleccione su rostro",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          padding: const EdgeInsets.only(top: 10.0),
        ),
        Container(
          child: const Image(
              image: AssetImage(
                'assets/document.png',
              ),
              fit: BoxFit.cover),
          padding: const EdgeInsets.only(top: 10.0),
        ),
      ],
    );
  }

  _getStepcropCI() {
    //revisar
    final img = File(_pickedFile!.path);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: CropImage(
          controller: controller,
          image: Image.file(img),
        ),
      ),
    );
  }

  _getStepcropFace() {
    //revisar
    final img = File(_pickedFile!.path);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: CropImage(
          controller: controller,
          image: Image.file(img),
        ),
      ),
    );
  }

  _getStepSelfie() {
    return ListView(
      children: [
        Container(
          child: const Text(
            "Tome una foto de su rostro",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          padding: const EdgeInsets.only(top: 10.0),
        ),
        Container(
          child: const Image(
              image: AssetImage(
                'assets/selfie.png',
              ),
              fit: BoxFit.cover),
          padding: const EdgeInsets.only(top: 10.0),
        ),
      ],
    );
  }

  _getStepData() {
    return ListView(
      children: [
        _extractText.hasData
            ? InformationPersonComponent(_extractText)
            : Container(
                child: const Text(
                  "Escanee un documento para comenzar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                padding: const EdgeInsets.only(top: 10.0),
              )
      ],
    );
  }

  _getLoading() {
    return Container(
      child: const Image(
          image: AssetImage(
            'assets/loading.gif',
          ),
          fit: BoxFit.cover),
      padding: const EdgeInsets.only(top: 10.0),
    );
  }
}

// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(""),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),

//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: captureData,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), //
//     );
//   }
//   captureData(){
//     executeFlutterTesseractOcr();
//   }
//   executeFlutterTesseractOcr() async{

//   }
// }
