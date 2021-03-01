library flutter_ui_bloc;

import 'dart:typed_data';

import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pure_extensions/path_extensions.dart';

export 'package:image_picker/image_picker.dart';

class PickedReadableFile extends ReadableFile {
  final PickedFile pickedFile;

  PickedReadableFile(this.pickedFile);

  @override
  String get name => pickedFile.path.getBasename();

  @override
  Stream<List<int>> onReadBytes() => pickedFile.openRead();

  @override
  Future<Uint8List> readBytes() => pickedFile.readAsBytes();

  @override
  Future<int> get size => throw UnimplementedError('Not implemented in image_picker package');
}

class FormBlocPhotoPicker {
  static final _picker = ImagePicker();

  const FormBlocPhotoPicker._();

  static const FormBlocPhotoPicker instance = FormBlocPhotoPicker._();

  factory FormBlocPhotoPicker() => instance;

  Future<ReadableFile> pickSinglePhoto({
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    double maxWidth,
    double maxHeight,
    int imageQuality,
  }) async {
    final file = await _picker.getImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      preferredCameraDevice: preferredCameraDevice,
    );
    if (file == null) return null;
    return PickedReadableFile(file);
  }
}
