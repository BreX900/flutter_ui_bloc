import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:flutter_ui_bloc/src/form/fields/common/BaseFieldBlocBuilder.dart';
import 'package:flutter_ui_bloc/src/form/fields/utils.dart';
import 'package:provider/provider.dart';

abstract class FileValue {
  final XFile file;

  FileValue({required this.file});
}

class TemporaryFileItem extends FileValue {
  TemporaryFileItem({required XFile file}) : super(file: file);
}

class PersistentFileItem extends FileValue {
  final bool hasDeleteMark;

  PersistentFileItem({required XFile file, this.hasDeleteMark = false}) : super(file: file);

  PersistentFileItem copyWith({bool? hasDeleteMark}) {
    return new PersistentFileItem(
      file: file,
      hasDeleteMark: hasDeleteMark ?? this.hasDeleteMark,
    );
  }
}

class ListFileFieldBlocBuilder extends StatefulWidget
    with DecorationOnFieldBlocBuilder
    implements FocusFieldBlocBuilder {
  /// The `fieldBloc` for rebuild the widget when its state changes.
  final InputFieldBloc<BuiltList<FileValue>?, dynamic>? fileFieldBloc;

  /// [DecorationOnFieldBlocBuilder.errorBuilder]
  @override
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsets? padding;

  /// [DecorationOnFieldBlocBuilder.decoration]
  @override
  final InputDecoration decoration;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode? nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.focusNode}
  @override
  final FocusNode? focusNode;

  /// [DecorationOnFieldBlocBuilder.showClearIcon]
  @override
  final bool showClearIcon;

  /// [DecorationOnFieldBlocBuilder.clearIcon]
  @override
  final Icon? clearIcon;

  final FieldValuePicker<Iterable<FileValue>> picker;

  final FieldValueBuilder<FileValue?>? builder;

  const ListFileFieldBlocBuilder({
    Key? key,
    required this.fileFieldBloc,
    this.enableOnlyWhenFormBlocCanSubmit = true,
    this.focusNode,
    this.nextFocusNode,
    this.isEnabled = true,
    this.animateWhenCanShow = true,
    this.showClearIcon = true,
    this.padding,
    this.decoration = const InputDecoration(),
    this.clearIcon,
    required this.picker,
    this.errorBuilder,
    this.builder,
  }) : super(key: key);

  @override
  SingleFieldBloc get fieldBloc => fileFieldBloc!;

  @override
  _ListFileFieldBlocBuilderState createState() => _ListFileFieldBlocBuilderState();

  static _ListFileFieldBlocBuilderState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ListFileFieldBlocBuilderState>();
  }
}

class _ListFileFieldBlocBuilderState extends State<ListFileFieldBlocBuilder>
    with FocusFieldBlocBuilderState
    implements FileFieldBlocBuilderState {
  @override
  void onHasFocus() {}

  void _updateValue(BuiltList<FileValue> value) {
    final updateValue = fieldBlocBuilderOnChange<BuiltList<FileValue>>(
      isEnabled: widget.isEnabled,
      nextFocusNode: widget.nextFocusNode!,
      onChanged: widget.fileFieldBloc!.updateValue,
    );
    if (updateValue != null) updateValue(value);
  }

  void pick() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final files = await widget.picker(context, widget.fileFieldBloc!.value!);
    if (files.isEmpty) return;
    _updateValue(widget.fileFieldBloc!.value!.rebuild((b) => b..addAll(files)));
  }

  void remove(FileValue file) {
    if (file is TemporaryFileItem) {
      _updateValue(widget.fileFieldBloc!.value!.rebuild((b) => b.remove(file)));
    } else if (file is PersistentFileItem) {
      _updateValue(widget.fileFieldBloc!.value!.rebuild((b) {
        final index = widget.fileFieldBloc!.value!.indexOf(file);
        b
          ..removeAt(index)
          ..insert(index, file.copyWith(hasDeleteMark: !file.hasDeleteMark));
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fileFieldBloc == null) return const SizedBox.shrink();

    return Provider.value(
      value: this,
      child: buildFocus(
        child: CanShowFieldBlocBuilder(
          fieldBloc: widget.fileFieldBloc!,
          animate: widget.animateWhenCanShow,
          builder: (context, _) => BlocBuilder<InputFieldBloc<BuiltList<FileValue>?, dynamic>,
              InputFieldBlocState<BuiltList<FileValue>?, dynamic>>(
            bloc: widget.fileFieldBloc,
            builder: (context, state) {
              final isEnabled = fieldBlocIsEnabled(
                isEnabled: widget.isEnabled,
                enableOnlyWhenFormBlocCanSubmit: widget.enableOnlyWhenFormBlocCanSubmit,
                fieldBlocState: state,
              );

              Widget current;
              if (state.value!.isEmpty) {
                current = _buildPlaceHolder();
              } else {
                current = ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.value!.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.value!.length) {
                      return AspectRatio(aspectRatio: 1, child: _buildPlaceHolder());
                    }

                    return _buildValue(value: state.value![index]);
                  },
                );
              }

              return SizedBox(
                height: 128.0,
                child: DefaultFieldBlocBuilderPadding(
                  padding: widget.padding,
                  child: InputDecorator(
                    decoration: widget.buildDecoration(context, state, isEnabled),
                    isEmpty: false,
                    child: current,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceHolder() {
    if (widget.builder != null) return widget.builder!(context, null);

    return FileValuePlaceHolder(onTap: () => pick());
  }

  Widget _buildValue({required FileValue value}) {
    if (widget.builder != null) return widget.builder!(context, value);

    return FileValueMenuButton(
      value: value,
      child: ReadableFileView(
        file: value.file,
      ),
    );
  }
}

enum _Option { delete, add }

abstract class FileFieldBlocBuilderState {
  void pick();

  void remove(FileValue value);

  static FileFieldBlocBuilderState of(BuildContext context) {
    return Provider.of(context, listen: false);
  }
}

class FileValuePlaceHolder extends StatelessWidget {
  final GestureTapCallback? onTap;

  const FileValuePlaceHolder({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ReadableFileView extends StatefulWidget {
  final XFile file;

  const ReadableFileView({Key? key, required this.file}) : super(key: key);

  @override
  _ReadableFileViewState createState() => _ReadableFileViewState();
}

class _ReadableFileViewState extends State<ReadableFileView> {
  late Future<Uint8List> _bytes;

  @override
  void initState() {
    super.initState();
    _bytes = widget.file.readAsBytes();
  }

  @override
  void didUpdateWidget(covariant ReadableFileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.file != oldWidget.file) {
      _bytes = widget.file.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _bytes,
      builder: (context, snap) {
        if (snap.hasData) {
          return Image.memory(snap.data!);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class FileValueMenuButton extends StatelessWidget {
  final FileValue value;
  final Widget child;

  const FileValueMenuButton({Key? key, required this.value, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;

    return PopupMenuButton<_Option>(
      onSelected: (option) {
        switch (option) {
          case _Option.delete:
            FileFieldBlocBuilderState.of(context).remove(value);
            break;
          case _Option.add:
            FileFieldBlocBuilderState.of(context).pick();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _Option.add,
          child: ListTile(
            trailing: const Icon(Icons.add),
            title: Text('Add'),
          ),
        ),
        PopupMenuItem(
          value: _Option.delete,
          child: ListTile(
            trailing: const Icon(Icons.delete),
            title: Text('Delete'),
          ),
        ),
      ],
      child: value is PersistentFileItem && value.hasDeleteMark || value is TemporaryFileItem
          ? DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2.0,
                  color: value is PersistentFileItem ? Colors.red : Colors.green,
                ),
              ),
              position: DecorationPosition.foreground,
              child: child,
            )
          : child,
    );
  }
}

// class GalleryFileFormBloc extends FormBloc<int, int> {
//   final GalleryFileFieldBloc<dynamic> galleryFileFieldBloc;
//   final FileFieldBloc<dynamic> listFileFieldBloc;
//
//   GalleryFileFormBloc({@required this.listFileFieldBloc, @required List<FileField> galleryItems})
//       : galleryFileFieldBloc = GalleryFileFieldBloc<dynamic>(
//           initialValue: listFileFieldBloc.value.toList(),
//           items: galleryItems,
//         ),
//         super();
//
//   @override
//   void onSubmitting() {
//     listFileFieldBloc.updateValue(galleryFileFieldBloc.value.toBuiltList());
//     emitSuccess();
//   }
// }
//
// class GalleyFileFieldBlocBuilder extends StatelessWidget {
//   final GalleryFileFormBloc galleryFileFormBloc;
//
//   const GalleyFileFieldBlocBuilder({Key key, @required this.galleryFileFormBloc}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FormBlocListener(
//       formBloc: galleryFileFormBloc,
//       onSuccess: (context, state) {
//         Navigator.pop(context);
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           actions: [
//             IconButton(
//               onPressed: () {
//                 galleryFileFormBloc.listFileFieldBloc.pick();
//               },
//               icon: const Icon(Icons.add),
//             ),
//           ],
//         ),
//         body: BlocBuilder<GalleryFileFieldBloc<dynamic>,
//             MultiSelectFieldBlocState<FileField, dynamic>>(
//           cubit: galleryFileFormBloc.galleryFileFieldBloc,
//           builder: (context, state) {
//             return GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//               itemCount: state.items.length,
//               itemBuilder: (context, index) {
//                 final item = state.items[index];
//
//                 return Stack(
//                   children: [
//                     Image(image: getImageProvider(item.file)),
//                     if (state.value.contains(item))
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: const Icon(Icons.check_circle_outline),
//                       )
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
