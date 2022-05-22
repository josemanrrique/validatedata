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
                "No se pudo extraer el numero de identificacion"),
            _getInformation(
                "Nombre :", data.name, "No se pudo extraer el nombre"),
            _getInformation(
                "Apellido :", data.lastname, "No se pudo extraer el apellido"),
            _getInformation("Fecha de Nac :", data.dateOfBirth,
                "No se pudo extraer la fehca de nacimiento"),
                ImageDocument(data.photoDocumen!),
          ])
        : const Text("La fecha de expiracion no es válida");
  }

  _getInformation(label, data, noData) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 15.0)),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const Padding(padding: EdgeInsets.only(left: 15.0)),
        Text(
          data ?? noData,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
          ),
        )
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