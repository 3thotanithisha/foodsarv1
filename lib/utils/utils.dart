import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

// ignore: non_constant_identifier_names
PickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  } else {
    if (kDebugMode) {
      print("No image selected");
    }
  }
}
