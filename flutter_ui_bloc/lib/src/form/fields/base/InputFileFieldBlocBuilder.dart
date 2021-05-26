import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:flutter_ui_bloc/src/form/fields/common/InputFieldBlocBuilder.dart';
import 'package:flutter_ui_bloc/src/form/fields/utils.dart';

class InputFileFieldBlocBuilder extends StatelessWidget {
  final InputFieldBloc<XFile?, dynamic>? inputFieldBloc;

  /// [TextFieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit]
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// [TextFieldBlocBuilder.animateWhenCanShow]
  final bool animateWhenCanShow;

  /// [TextFieldBlocBuilder.nextFocusNode]
  final FocusNode? nextFocusNode;

  /// [TextFieldBlocBuilder.focusNode]
  final FocusNode? focusNode;

  /// [TextFieldBlocBuilder.isEnabled]
  final bool isEnabled;

  /// [TextField.readOnly]
  final bool readOnly;

  /// [TextFieldBlocBuilder.padding]
  final EdgeInsets? padding;

  /// [TextField.decoration]
  final InputDecoration decoration;

  /// [TextFieldBlocBuilder.suffixButton]
  final SuffixButton? suffixButton;

  /// [TextFieldBlocBuilder.clearTextIcon]
  final Icon clearIcon;

  /// Pick a value from previous value when user click on the field or the field receive the focus
  final FieldValuePicker<XFile> picker;

  /// See [TextFieldBlocBuilder.errorBuilder]
  final FieldBlocErrorBuilder? errorBuilder;

  /// Build a widget for specific value
  final FieldValueBuilder<XFile>? builder;

  const InputFileFieldBlocBuilder({
    Key? key,
    required this.inputFieldBloc,
    this.enableOnlyWhenFormBlocCanSubmit = true,
    this.animateWhenCanShow = true,
    this.focusNode,
    this.nextFocusNode,
    this.isEnabled = true,
    this.readOnly = false,
    this.padding,
    this.decoration = const InputDecoration(),
    this.suffixButton,
    this.clearIcon = const Icon(Icons.clear),
    required this.picker,
    this.errorBuilder,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (inputFieldBloc == null) return const SizedBox.shrink();

    return InputFieldBlocBuilder<XFile>(
      inputFieldBloc: inputFieldBloc,
      enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
      animateWhenCanShow: animateWhenCanShow,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      isEnabled: isEnabled,
      readOnly: readOnly,
      padding: padding,
      decoration: decoration,
      suffixButton: suffixButton,
      clearIcon: clearIcon,
      picker: picker,
      errorBuilder: errorBuilder,
      builder: builder ?? _buildValue,
    );
  }

  Widget _buildValue(BuildContext context, XFile file) {
    return Text(file.name);
  }
}
