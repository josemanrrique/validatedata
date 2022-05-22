import 'dart:io';
import 'package:flutter/material.dart';

class ImageDocument extends StatelessWidget {
  const ImageDocument(this.path, {Key? key}) : super(key: key);
  final File path;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.file(
        path,
        fit: BoxFit.cover,
      ),
      padding: const EdgeInsets.all(30.0),
    );
    // return Image.memory(base64Decode(photoBase64), fit: BoxFit.cover);
  }
}
