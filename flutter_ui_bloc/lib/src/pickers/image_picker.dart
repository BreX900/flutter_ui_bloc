import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';
import 'package:image_picker/image_picker.dart' hide ImagePicker;
import 'package:image_picker/image_picker.dart' as ip;
import 'package:pure_extensions/path_extensions.dart';

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

class FieldImagePicker {
  static final _picker = ip.ImagePicker();

  const FieldImagePicker._();

  static const FieldImagePicker instance = FieldImagePicker._();

  factory FieldImagePicker() => instance;

  Future<ReadableFile> pickSingleImage({
    @required ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    double maxWidth,
    double maxHeight,
    int imageQuality,
  }) async {
    final file = await _picker.getImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      preferredCameraDevice: preferredCameraDevice,
    );
    if (file == null) return null;
    return PickedReadableFile(file);
  }
}
