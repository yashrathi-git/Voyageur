import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

pickMultipleImages() async {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> files = await imagePicker.pickMultiImage();
  List<Uint8List> images = [];
  for (XFile file in files) {
    images.add(await file.readAsBytes());
  }
  return images;
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
