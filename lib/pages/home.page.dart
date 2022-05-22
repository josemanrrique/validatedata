import 'package:flutter/material.dart';
import 'package:readdata/components/informationPerson.component.dart';
import 'package:readdata/models/datatext.model.dart';
import 'package:readdata/models/informationDocuments.model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String textDisplay = "";
  InformationDocuments _extractText = InformationDocuments("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: const Text("OCR Venezuela"),
      ),
      body: ListView(
        children: [
          _extractText.hasData
              ? InformationPersonComponent(_extractText)
              : Container(
                  child: const Text(
                    "No se ha leido ningun documento",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 10.0),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: captureData,
        tooltip: 'Increment',
        child: const Icon(Icons.camera),
      ), //
    );
  }

  captureData() async {
    // File? _pickedImage;
    // _pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    // final picker = ImagePicker();
    // PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);
    // if(pickedFile?.path != null){
    //   _extractText = await FlutterTesseractOcr.extractText(pickedFile!.path, language: 'spa',
    //     args: {
    //       "psm": "4",
    //       "preserve_interword_spaces": "1",
    //     });
    // }

    // _extractText = await FlutterTesseractOcr.extractText(pickedFile.path, language: 'spa+eng',
    //   args: {
    //     "psm": "4",
    //     "preserve_interword_spaces": "1",
    //   });
    _extractText = await DataTextExtract.captureData();
    setState(() {});
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
