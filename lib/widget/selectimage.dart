import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage(ImageSource imgsource) async {
  final _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: imgsource);
  if (_file != null) {
    return await _file.readAsBytes();
  } else {
    print("No image selected");
    return null; // Make sure to return null if no image is selected
  }
}
