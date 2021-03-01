library flutter_ui_bloc;

import 'dart:io';
import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pure_extensions/pure_extensions.dart';

export 'package:file_picker/file_picker.dart';

class FilePickerReadableFile extends ReadableFile {
  final PlatformFile file;
  File _$file;
  File get _file => _$file ?? (file.path != null ? File(file.path) : null);

  FilePickerReadableFile(this.file);

  @override
  String get name => file.name;

  bool get canOpenManyReadStream => _file != null;

  @override
  Stream<List<int>> onReadBytes() => _file?.openRead() ?? file.readStream;

  @override
  Future<Uint8List> readBytes() async => file.bytes;

  @override
  Future<int> get size async => file.size;
}

class FormBlocFilePicker {
  const FormBlocFilePicker._();

  static const FormBlocFilePicker instance = FormBlocFilePicker._();

  factory FormBlocFilePicker() => instance;

  Future<Iterable<ReadableFile>> pickMultiFile({
    BuiltList<ReadableFile> oldFiles,
    FileType type = FileType.any,
    List<String> allowedExtensions,
  }) async {
    final files = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: type,
      allowedExtensions: allowedExtensions,
      allowCompression: false,
      withData: true,
      withReadStream: false,
    );
    if (files == null) return null;
    return files.files.map((file) => FilePickerReadableFile(file));
  }

  Future<ReadableFile> pickSingleFile({
    ReadableFile oldFile,
    FileType type = FileType.any,
    List<String> allowedExtensions,
  }) async {
    final files = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: type,
      allowedExtensions: allowedExtensions,
      allowCompression: false,
      withData: true,
      withReadStream: false,
    );
    if (files == null) return null;
    return files.files.map((file) => FilePickerReadableFile(file)).single;
  }
}
