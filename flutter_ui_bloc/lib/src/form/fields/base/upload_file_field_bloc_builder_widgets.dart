import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_bloc/src/form/fields/base/upload_file_field_bloc_builder.dart';
import 'package:mime/mime.dart';

class FileFieldPlaceHolder extends StatelessWidget {
  const FileFieldPlaceHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final field = UploadFileFieldBlocBuilder.of(context);

    final iconTheme = IconTheme.of(context);

    return DottedBorder(
      color: iconTheme.color ?? Colors.black,
      child: InkWell(
        onTap: field.onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add),
              SizedBox(height: 16.0),
              Text('Upload'),
            ],
          ),
        ),
      ),
    );
  }
}

class FileFieldView extends StatelessWidget {
  final XFile file;

  const FileFieldView({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mimeType = lookupMimeType(file.name);
    if (mimeType != null && mimeType.startsWith('image')) {
      return _ImageFileFieldView(file: file);
    }

    final field = UploadFileFieldBlocBuilder.of(context);

    return InkWell(
      onTap: field.onTap,
      child: Center(
        child: Text(file.name),
      ),
    );
  }
}

class _ImageFileFieldView extends StatefulWidget {
  final XFile file;

  const _ImageFileFieldView({Key? key, required this.file}) : super(key: key);

  @override
  _ImageFileFieldViewState createState() => _ImageFileFieldViewState();
}

class _ImageFileFieldViewState extends State<_ImageFileFieldView> {
  Future<dynamic>? _done;
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _readBytes();
  }

  @override
  void didUpdateWidget(covariant _ImageFileFieldView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.file != oldWidget.file) {
      _readBytes();
    }
  }

  void _readBytes() {
    _bytes = null;
    late Future<dynamic> done;
    done = widget.file.readAsBytes().then((bytes) {
      if (_done != done) return null;
      setState(() {
        _bytes = bytes;
      });
    });
    _done = done;
  }

  @override
  void dispose() {
    _done = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _bytes;
    if (bytes == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final field = UploadFileFieldBlocBuilder.of(context);

    return Ink.image(
      image: MemoryImage(bytes),
      child: InkWell(
        onTap: field.onTap,
      ),
    );
  }
}
