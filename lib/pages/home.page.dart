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
  CropController controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  late XFile? _pickedFile;
  late int step = 1;
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
      // body: ListView(
      //_loading ? _getLoading() : _getBody(),
      //   ],
      // ),
      body: _getStepCurrent(),
      floatingActionButton: FloatingActionButton(
        onPressed: captureData,
        tooltip: 'Next Step',
        child: _getIconFloatingActionButton(),
      ), //
    );
  }

  _getIconFloatingActionButton() {
    if (step == 1) {
      return const Icon(Icons.camera);
    } else if (step == 2) {
      return const Icon(Icons.crop);
    } else if (step == 3) {
      return const Icon(Icons.camera);
    } else if (step == 4) {
      return const Icon(Icons.restore_rounded);
    } else {
      return const Icon(Icons.camera);
    }
  }

  captureData() async {
    if (step == 1) {
      _pickedFile = await DataTextExtract.readPhoto();
      step = 2;
    } else if (step == 2) {
      step = 3;
    } else if (step == 3) {
      final imageFace = await controller.croppedImage();
      final selfie = await DataTextExtract.readPhoto();
      _loading = true;
      step = 4;
      setState(() {});
      _extractText =
          await DataTextExtract.captureData(_pickedFile, imageFace, selfie);
      _loading = false;
    } else {
      step = 1;
      _extractText = InformationDocuments("");
      controller = CropController(
        aspectRatio: 1,
        defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
      );
    }
    setState(() {});
  }

  _getStepCurrent() {
    if (step == 1) {
      return _getStep1();
    } else if (step == 2) {
      return _getStep2();
    } else if (step == 3) {
      return _getStep3();
    } else if (step == 4) {
      return _loading ? _getLoading() : _getStep4();
    } else {
      return _getStep1();
    }
  }

  String _getTitleCurrent() {
    if (step == 1) {
      return "OCR Venezuela";
    } else if (step == 2) {
      return "Seleccione el rostro";
    } else if (step == 3) {
      return "Seleccione el rostro";
    } else if (step == 4) {
      return _loading ? "Extrayendo datos" : "Datos extraidos";
    } else if (step == 5) {
      return _loading ? "Extrayendo datos" : "Datos extraidos";
    } else {
      return "OCR Venezuela";
    }
  }

  _getStep1() {
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

  _getStep2() {
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

  _getStep3() {
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

  _getStep4() {
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
