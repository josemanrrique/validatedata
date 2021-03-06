import 'package:flutter/material.dart';
import 'package:readdata/components/photoCrop.dart';
import 'package:readdata/models/informationDocuments.model.dart';

class InformationPersonComponent extends StatelessWidget {
  const InformationPersonComponent(this.data, {Key? key}) : super(key: key);

  final InformationDocuments data;

  @override
  Widget build(BuildContext context) {
    return (data.active)
        ? Column(children: [
            const Padding(padding: EdgeInsets.only(top: 10.0)),
            _getInformation("Número :", data.id,
                "Fallo lectura"),
            _getInformation(
                "Nombre :", data.name, "Fallo lectura"),
            _getInformation(
                "Apellido :", data.lastname, "Fallo lectura"),
            _getInformation("Fecha de Nac :", data.dateOfBirth,
                "Fallo lectura"),
            _getIsValidSelfie(data.valid!),
            ImageDocument(data.photoDocumen!),
          ])
        : const Text("Fallo lectura");
  }

  _getInformation(label, data, noData) {
    return Row(
      children: [
        _getText(label),
        _getText(data ?? noData),
      ],
    );
  }

  _getIsValidSelfie(ValidFace data) {
    String result = "";
    if (data.diff! < 0.80) {
      result = "Validación exitosa";
    } else if (data.diff! >= 0.80) {
      result = "Validación no exitosa";
    }
    return _getText(result);
  }

  _getText(String data) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 15.0)),
        Text(
          data,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

// class InformationPersonComponent extends StatefulWidget {
//   const InformationPersonComponent({ Key? key, InformationDocuments? data }) : super(key: key);

//   @override
//   State<InformationPersonComponent> createState() => _InformationPersonComponentState();
// }

// class _InformationPersonComponentState extends State<InformationPersonComponent> {
//   _InformationPersonComponentState({ InformationDocuments? data });
//   late InformationDocuments data;

//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       data.hasData ? data.dataRaw : "No hay informacion"
//     );
//   }
// }