import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readdata/components/informationPerson.component.dart';
import 'package:readdata/models/datatext.model.dart';
import 'package:readdata/models/informationDocuments.model.dart';
import 'package:custom_image_crop/custom_image_crop.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = false;
  InformationDocuments _extractText = InformationDocuments("");
  late CustomImageCropController controller;
  late PickedFile? _pickedFile;
  late int step = 1;
  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

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
        title: const Text("OCR Venezuela"),
      ),
      // body: ListView(
      //_loading ? _getLoading() : _getBody(),
      //   ],
      // ),
      body: _getStepCurrent(),
      floatingActionButton: FloatingActionButton(
        onPressed: captureData,
        tooltip: 'Increment',
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
      _loading = true;
      step = 3;
      setState(() {});
      _extractText = await DataTextExtract.captureData(_pickedFile);
      _loading = false;
    } else {
      step = 1;
    }
    setState(() {});
  }

  _getStepCurrent() {
    if (step == 1) {
      return _getStep1();
    } else if (step == 2) {
      return _getStep2();
    } else if (step == 3) {
      return _loading ? _getLoading() : _getStep3();
    } else {
      return _getStep1();
    }
  }

  _getStep1() {
    return ListView(
      children: [
        Container(
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

  _getStep2() {
    return Column(children: [
      Expanded(
        child: CustomImageCrop(
          cropController: controller,
          // image: const AssetImage('assets/test.png'), // Any Imageprovider will work, try with a NetworkImage for example...
          image: const NetworkImage(
              'https://upload.wikimedia.org/wikipedia/en/7/7d/Lenna_%28test_image%29.png'),
          shape: CustomCropShape.Square,
        ),
      )
    ]);
  }

  _getStep3() {
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
