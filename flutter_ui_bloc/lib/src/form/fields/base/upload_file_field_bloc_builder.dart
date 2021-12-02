import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:flutter_ui_bloc/src/form/fields/base/upload_file_field_bloc_builder_widgets.dart';
import 'package:flutter_ui_bloc/src/form/fields/common/base_field_bloc_builder.dart';
import 'package:flutter_ui_bloc/src/form/fields/utils.dart';

class FileFieldBlocBuilderTheme {
  final double aspectRatio;
  final BoxConstraints constraints;

  const FileFieldBlocBuilderTheme({
    this.aspectRatio = 1,
    this.constraints = const BoxConstraints(maxHeight: 172, maxWidth: 172),
  });

  static FileFieldBlocBuilderTheme from(BuildContext context) {
    try {
      return context.read<FileFieldBlocBuilderTheme>();
    } on ProviderNotFoundException {
      return const FileFieldBlocBuilderTheme();
    }
  }

  FileFieldBlocBuilderTheme copyWith({
    double? aspectRatio,
    BoxConstraints? constraints,
  }) {
    return FileFieldBlocBuilderTheme(
      aspectRatio: aspectRatio ?? this.aspectRatio,
      constraints: constraints ?? this.constraints,
    );
  }
}

class UploadFileFieldBlocBuilder extends StatefulWidget with DecorationOnFieldBlocBuilder {
  final InputFieldBloc<XFile?, dynamic>? inputFieldBloc;

  /// [TextFieldBlocBuilder.animateWhenCanShow]
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// [TextFieldBlocBuilder.animateWhenCanShow]
  final bool animateWhenCanShow;

  /// [TextFieldBlocBuilder.isEnabled]
  final bool isEnabled;

  /// [TextFieldBlocBuilder.readOnly]
  final bool readOnly;

  /// [TextFieldBlocBuilder.padding]
  final EdgeInsets? padding;

  /// Pick a value from previous value when user click on the field or the field receive the focus
  final FieldValuePicker<XFile> picker;

  @override
  final FieldBlocErrorBuilder? errorBuilder;

  final double? aspectRation;

  final BoxConstraints? constraints;

  final Widget? placeHolder;

  final Widget Function(BuildContext context, XFile file)? builder;

  const UploadFileFieldBlocBuilder({
    Key? key,
    required this.inputFieldBloc,
    this.isEnabled = true,
    this.readOnly = false,
    this.animateWhenCanShow = true,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.padding,
    required this.picker,
    this.errorBuilder,
    this.aspectRation,
    this.constraints,
    this.placeHolder,
    this.builder,
  }) : super(key: key);

  static _UploadFileFieldBlocBuilderState of(BuildContext context) {
    return context.findAncestorStateOfType<_UploadFileFieldBlocBuilderState>()!;
  }

  @override
  _UploadFileFieldBlocBuilderState createState() => _UploadFileFieldBlocBuilderState();

  @override
  SingleFieldBloc<dynamic, dynamic, FieldBlocState, dynamic> get fieldBloc => inputFieldBloc!;
}

class _UploadFileFieldBlocBuilderState extends State<UploadFileFieldBlocBuilder> {
  Widget _buildPlaceHolder(BuildContext context) {
    if (widget.placeHolder != null) return widget.placeHolder!;
    return const FileFieldPlaceHolder();
  }

  Widget _buildFile(BuildContext context, XFile file) {
    if (widget.builder != null) return widget.builder!(context, file);
    return FileFieldView(file: file);
  }

  late VoidCallback? _onTap;
  late bool _isEnabled;
  VoidCallback? get onTap => _onTap;
  bool get isEnabled => _isEnabled;

  @override
  Widget build(BuildContext context) {
    final inputFieldBloc = widget.inputFieldBloc;
    if (inputFieldBloc == null) return const SizedBox.shrink();

    final builderTheme = FileFieldBlocBuilderTheme.from(context);

    return CanShowFieldBlocBuilder(
      fieldBloc: inputFieldBloc,
      animate: widget.animateWhenCanShow,
      builder: (context, _) {
        return DefaultFieldBlocBuilderPadding(
          padding: widget.padding,
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: widget.constraints ?? builderTheme.constraints,
              child: AspectRatio(
                aspectRatio: widget.aspectRation ?? builderTheme.aspectRatio,
                child: BlocBuilder<InputFieldBloc<XFile?, dynamic>,
                    InputFieldBlocState<XFile?, dynamic>>(
                  bloc: inputFieldBloc,
                  builder: (context, state) {
                    final isEnabled = _isEnabled = fieldBlocIsEnabled(
                      isEnabled: widget.isEnabled,
                      enableOnlyWhenFormBlocCanSubmit: widget.enableOnlyWhenFormBlocCanSubmit,
                      fieldBlocState: state,
                    );
                    final value = state.value;

                    _onTap = fieldBlocBuilderOnPick<XFile>(
                      context: context,
                      isEnabled: isEnabled && !widget.readOnly,
                      currentValue: state.value,
                      nextFocusNode: null,
                      onPick: widget.picker,
                      onChanged: inputFieldBloc.updateValue,
                    );

                    return Stack(
                      children: [
                        DefaultFieldBlocBuilderPadding(
                          padding: widget.padding,
                          child: InputDecorator(
                            decoration: widget.buildDecoration(context, state, isEnabled),
                            isEmpty: false,
                            child: const SizedBox(height: 20),
                          ),
                        ),
                        Positioned.fill(
                          bottom: 12.0,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: value == null
                                ? KeyedSubtree(
                                    key: ValueKey('$UploadFileFieldBlocBuilder#null'),
                                    child: _buildPlaceHolder(context),
                                  )
                                : KeyedSubtree(
                                    key: ValueKey('$UploadFileFieldBlocBuilder#${value}'),
                                    child: _buildFile(context, value),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// abstract class FileValue {
//   final XFile file;
//
//   FileValue({required this.file});
// }
//
// class TemporaryFileItem extends FileValue {
//   TemporaryFileItem({required XFile file}) : super(file: file);
// }
//
// class PersistentFileItem extends FileValue {
//   final bool hasDeleteMark;
//
//   PersistentFileItem({required XFile file, this.hasDeleteMark = false}) : super(file: file);
//
//   PersistentFileItem copyWith({bool? hasDeleteMark}) {
//     return PersistentFileItem(
//       file: file,
//       hasDeleteMark: hasDeleteMark ?? this.hasDeleteMark,
//     );
//   }
// }
//
// class ListFileFieldBlocBuilder extends StatefulWidget
//     with DecorationOnFieldBlocBuilder
//     implements FocusFieldBlocBuilder {
//   /// The `fieldBloc` for rebuild the widget when its state changes.
//   final InputFieldBloc<BuiltList<FileValue>?, dynamic>? fileFieldBloc;
//
//   /// [DecorationOnFieldBlocBuilder.errorBuilder]
//   @override
//   final FieldBlocErrorBuilder? errorBuilder;
//
//   /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
//   final bool enableOnlyWhenFormBlocCanSubmit;
//
//   /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
//   final bool isEnabled;
//
//   /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
//   final EdgeInsets? padding;
//
//   /// [DecorationOnFieldBlocBuilder.decoration]
//   @override
//   final InputDecoration decoration;
//
//   /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
//   final bool animateWhenCanShow;
//
//   /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
//   final FocusNode? nextFocusNode;
//
//   /// {@macro flutter_form_bloc.FieldBlocBuilder.focusNode}
//   @override
//   final FocusNode? focusNode;
//
//   /// [DecorationOnFieldBlocBuilder.showClearIcon]
//   @override
//   final SuffixButton? suffixButton;
//
//   /// [DecorationOnFieldBlocBuilder.clearIcon]
//   @override
//   final Widget clearIcon;
//
//   final FieldValuePicker<Iterable<FileValue>> picker;
//
//   final FieldValueBuilder<FileValue?>? builder;
//
//   const ListFileFieldBlocBuilder({
//     Key? key,
//     required this.fileFieldBloc,
//     this.enableOnlyWhenFormBlocCanSubmit = true,
//     this.focusNode,
//     this.nextFocusNode,
//     this.isEnabled = true,
//     this.animateWhenCanShow = true,
//     this.suffixButton,
//     this.padding,
//     this.decoration = const InputDecoration(),
//     this.clearIcon = const Icon(Icons.clear),
//     required this.picker,
//     this.errorBuilder,
//     this.builder,
//   }) : super(key: key);
//
//   @override
//   SingleFieldBloc get fieldBloc => fileFieldBloc!;
//
//   @override
//   _ListFileFieldBlocBuilderState createState() => _ListFileFieldBlocBuilderState();
//
//   static _ListFileFieldBlocBuilderState? of(BuildContext context) {
//     return context.findAncestorStateOfType<_ListFileFieldBlocBuilderState>();
//   }
// }
//
// class _ListFileFieldBlocBuilderState extends State<ListFileFieldBlocBuilder>
//     with FocusFieldBlocBuilderState
//     implements FileFieldBlocBuilderState {
//   @override
//   void onHasFocus() {}
//
//   void _updateValue(BuiltList<FileValue> value) {
//     final updateValue = fieldBlocBuilderOnChange<BuiltList<FileValue>>(
//       isEnabled: widget.isEnabled,
//       nextFocusNode: widget.nextFocusNode!,
//       onChanged: widget.fileFieldBloc!.updateValue,
//     );
//     if (updateValue != null) updateValue(value);
//   }
//
//   @override
//   void pick() async {
//     FocusScope.of(context).requestFocus(FocusNode());
//     final files = await widget.picker(context, widget.fileFieldBloc!.value!);
//     if (files == null || files.isEmpty) return;
//     _updateValue(widget.fileFieldBloc!.value!.rebuild((b) => b..addAll(files)));
//   }
//
//   @override
//   void remove(FileValue file) {
//     if (file is TemporaryFileItem) {
//       _updateValue(widget.fileFieldBloc!.value!.rebuild((b) => b.remove(file)));
//     } else if (file is PersistentFileItem) {
//       _updateValue(widget.fileFieldBloc!.value!.rebuild((b) {
//         final index = widget.fileFieldBloc!.value!.indexOf(file);
//         b
//           ..removeAt(index)
//           ..insert(index, file.copyWith(hasDeleteMark: !file.hasDeleteMark));
//       }));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.fileFieldBloc == null) return const SizedBox.shrink();
//
//     return Provider.value(
//       value: this,
//       child: buildFocus(
//         child: CanShowFieldBlocBuilder(
//           fieldBloc: widget.fileFieldBloc!,
//           animate: widget.animateWhenCanShow,
//           builder: (context, _) => BlocBuilder<InputFieldBloc<BuiltList<FileValue>?, dynamic>,
//               InputFieldBlocState<BuiltList<FileValue>?, dynamic>>(
//             bloc: widget.fileFieldBloc,
//             builder: (context, state) {
//               final isEnabled = fieldBlocIsEnabled(
//                 isEnabled: widget.isEnabled,
//                 enableOnlyWhenFormBlocCanSubmit: widget.enableOnlyWhenFormBlocCanSubmit,
//                 fieldBlocState: state,
//               );
//
//               Widget current;
//               if (state.value!.isEmpty) {
//                 current = _buildPlaceHolder();
//               } else {
//                 current = ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: state.value!.length + 1,
//                   itemBuilder: (context, index) {
//                     if (index >= state.value!.length) {
//                       return AspectRatio(aspectRatio: 1, child: _buildPlaceHolder());
//                     }
//
//                     return _buildValue(state.value![index]);
//                   },
//                 );
//               }
//
//               return SizedBox(
//                 height: 128.0,
//                 child: DefaultFieldBlocBuilderPadding(
//                   padding: widget.padding,
//                   child: InputDecorator(
//                     decoration: widget.buildDecoration(context, state, isEnabled),
//                     isEmpty: false,
//                     child: current,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlaceHolder() {
//     if (widget.builder != null) return widget.builder!(context, null);
//
//     return FileFieldPlaceHolder(onTap: () => pick());
//   }
//
//   Widget _buildValue(FileValue value) {
//     if (widget.builder != null) return widget.builder!(context, value);
//
//     return FileValueMenuButton(
//       value: value,
//       child: ReadableFileView(
//         file: value.file,
//       ),
//     );
//   }
// }
//
// enum _Option { delete, add }
//
// abstract class FileFieldBlocBuilderState {
//   void pick();
//
//   void remove(FileValue value);
//
//   static FileFieldBlocBuilderState of(BuildContext context) {
//     return Provider.of(context, listen: false);
//   }
// }
//
// class ReadableFileView extends StatefulWidget {
//   final XFile file;
//
//   const ReadableFileView({Key? key, required this.file}) : super(key: key);
//
//   @override
//   _ReadableFileViewState createState() => _ReadableFileViewState();
// }
//
// class _ReadableFileViewState extends State<ReadableFileView> {
//   late Future<Uint8List> _bytes;
//
//   @override
//   void initState() {
//     super.initState();
//     _bytes = widget.file.readAsBytes();
//   }
//
//   @override
//   void didUpdateWidget(covariant ReadableFileView oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.file != oldWidget.file) {
//       _bytes = widget.file.readAsBytes();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Uint8List>(
//       future: _bytes,
//       builder: (context, snap) {
//         if (snap.hasData) {
//           return Image.memory(snap.data!);
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }
//
// class FileValueMenuButton extends StatelessWidget {
//   final FileValue value;
//   final Widget child;
//
//   const FileValueMenuButton({Key? key, required this.value, required this.child}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final value = this.value;
//
//     return PopupMenuButton<_Option>(
//       onSelected: (option) {
//         switch (option) {
//           case _Option.delete:
//             FileFieldBlocBuilderState.of(context).remove(value);
//             break;
//           case _Option.add:
//             FileFieldBlocBuilderState.of(context).pick();
//             break;
//         }
//       },
//       itemBuilder: (context) => [
//         PopupMenuItem(
//           value: _Option.add,
//           child: ListTile(
//             trailing: const Icon(Icons.add),
//             title: Text('Add'),
//           ),
//         ),
//         PopupMenuItem(
//           value: _Option.delete,
//           child: ListTile(
//             trailing: const Icon(Icons.delete),
//             title: Text('Delete'),
//           ),
//         ),
//       ],
//       child: value is PersistentFileItem && value.hasDeleteMark || value is TemporaryFileItem
//           ? DecoratedBox(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   width: 2.0,
//                   color: value is PersistentFileItem ? Colors.red : Colors.green,
//                 ),
//               ),
//               position: DecorationPosition.foreground,
//               child: child,
//             )
//           : child,
//     );
//   }
// }

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
