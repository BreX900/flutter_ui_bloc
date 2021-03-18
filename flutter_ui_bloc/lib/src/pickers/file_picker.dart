import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FieldFilePicker {
  const FieldFilePicker._();

  static const FieldFilePicker instance = FieldFilePicker._();

  factory FieldFilePicker() => instance;

  Future<List<XFile>> pickMultiFile({
    FileType type = FileType.any,
    List<String> allowedExtensions,
  }) async {
    return await _pick(
      allowMultiple: true,
      type: type,
      allowedExtensions: allowedExtensions,
    );
  }

  Future<XFile> pickSingleFile({
    FileType type = FileType.any,
    List<String> allowedExtensions,
  }) async {
    final files = await _pick(
      allowMultiple: false,
      type: type,
      allowedExtensions: allowedExtensions,
    );
    if (files == null) return null;
    return files.single;
  }

  Future<List<XFile>> _pick({
    @required bool allowMultiple,
    FileType type = FileType.any,
    List<String> allowedExtensions,
  }) async {
    final files = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: type,
      allowedExtensions: allowedExtensions,
      allowCompression: false,
      withData: kIsWeb,
      withReadStream: false,
    );
    if (files == null) return const <XFile>[];
    return files.files.map((file) {
      if (file.path != null) {
        return XFile(file.path, name: file.name, length: file.size);
      } else {
        return XFile.fromData(file.bytes, name: file.name, length: file.size);
      }
    }).toList();
  }
}
