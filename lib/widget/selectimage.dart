import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource imgsource) async {
  final _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: imgsource);
  if (_file != null) {
    return await _file.readAsBytes();
  } else {
    print("No images Selected");
  }
}
