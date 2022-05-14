import 'package:flutter/material.dart';
import 'package:readdata/models/informationDocuments.model.dart';

class InformationPersonComponent extends StatelessWidget {
  InformationPersonComponent(this.data);

  final InformationDocuments data;

  @override
  Widget build(BuildContext context) {
    return Text(data.hasData ? data.dataRaw : "No hay informacion");
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