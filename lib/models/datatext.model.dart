import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:readdata/models/informationDocuments.model.dart';
class DataTextExtract {
  
  static Future<InformationDocuments> captureData() async {
    // File? _pickedImage;
    // _pickedImage = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    InformationDocuments extractText = InformationDocuments("");
    final picker = ImagePicker();
    PickedFile? pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile?.path != null){
      extractText = InformationDocuments( await FlutterTesseractOcr.extractText(pickedFile!.path, language: 'spa',
        args: {
          "psm": "4",
          "preserve_interword_spaces": "1",
        }));
      // _extractText = await FlutterTesseractOcr.extractText(pickedFile.path, language: 'spa+eng',
      //   args: {
      //     "psm": "4",
      //     "preserve_interword_spaces": "1",
      //   });
    }
    return extractText;
  }
}