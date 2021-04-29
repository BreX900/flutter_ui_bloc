import 'package:cross_file/cross_file.dart';
import 'package:image_picker/image_picker.dart' hide ImagePicker;
import 'package:image_picker/image_picker.dart' as ip;

class FieldImagePicker {
  static final _picker = ip.ImagePicker();

  const FieldImagePicker._();

  static const FieldImagePicker instance = FieldImagePicker._();

  factory FieldImagePicker() => instance;

  Future<XFile?> pickSingleImage({
    required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final file = await _picker.getImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      preferredCameraDevice: preferredCameraDevice,
    );
    if (file == null) return null;
    return XFile(file.path);
  }
}
