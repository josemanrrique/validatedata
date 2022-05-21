import 'package:flutter/material.dart';
import 'package:readdata/models/informationDocuments.model.dart';

class InformationPersonComponent extends StatelessWidget {
  InformationPersonComponent(this.data);

  final InformationDocuments data;

  @override
  Widget build(BuildContext context) {
    return 
    (data.active) ?
     Column(
      children:[
        Text(data.id != null ? data.id! : "No se pudo extraer el numero de identificacion"),
        Text(data.name != null ? data.name! : "No se pudo extraer el nombre"),
        Text(data.lastname != null ? data.lastname! : "No se pudo extraer el apellido"),
        Text(data.dateOfBirth != null ? data.dateOfBirth! : "No se pudo extraer la fehca de nacimiento"),
      ]
    ) :
    Text("La fecha de expiracion no es válida");
    
    
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