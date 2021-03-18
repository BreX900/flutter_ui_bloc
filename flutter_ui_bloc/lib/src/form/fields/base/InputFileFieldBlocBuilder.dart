import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:flutter_ui_bloc/src/form/fields/common/BaseFieldBlocBuilder.dart';
import 'package:flutter_ui_bloc/src/form/fields/utils.dart';

class InputFileFieldBlocBuilder extends StatefulWidget
    with DecorationOnFieldBlocBuilder
    implements FocusFieldBlocBuilder {
  final InputFieldBloc<XFile, Object> inputFieldBloc;

  /// [DecorationOnFieldBlocBuilder.errorBuilder]
  @override
  final FieldBlocErrorBuilder errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry padding;

  /// [DecorationOnFieldBlocBuilder.decoration]
  @override
  final InputDecoration decoration;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.focusNode}
  @override
  final FocusNode focusNode;

  /// [DecorationOnFieldBlocBuilder.showClearIcon]
  @override
  final bool showClearIcon;

  /// [DecorationOnFieldBlocBuilder.clearIcon]
  @override
  final Icon clearIcon;

  final FieldValuePicker<XFile> picker;

  final FieldValueBuilder<XFile> builder;

  const InputFileFieldBlocBuilder({
    Key key,
    @required this.inputFieldBloc,
    this.enableOnlyWhenFormBlocCanSubmit = true,
    this.focusNode,
    this.nextFocusNode,
    this.isEnabled = true,
    this.animateWhenCanShow = true,
    this.showClearIcon = true,
    this.padding,
    this.decoration = const InputDecoration(),
    this.clearIcon,
    @required this.picker,
    this.errorBuilder,
    this.builder,
  })  : assert(picker != null),
        super(key: key);

  @override
  SingleFieldBloc get fieldBloc => inputFieldBloc;

  @override
  _InputFileFieldBlocBuilderState createState() => _InputFileFieldBlocBuilderState();

  @override
  InputDecoration buildDecoration(BuildContext context, FieldBlocState state, bool isEnabled) {
    return super.buildDecoration(context, state, isEnabled);
  }
}

class _InputFileFieldBlocBuilderState extends State<InputFileFieldBlocBuilder>
    with FocusFieldBlocBuilderState {
  @override
  void onHasFocus() {}

  void _updateValue(XFile file) {
    final updateValue = fieldBlocBuilderOnChange<XFile>(
      isEnabled: widget.isEnabled,
      nextFocusNode: widget.nextFocusNode,
      onChanged: widget.inputFieldBloc.updateValue,
    );
    if (updateValue != null) updateValue(file);
  }

  void pick() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final file = await widget.picker(context, widget.inputFieldBloc.value);
    if (file == null) return;
    _updateValue(file);
  }

  @override
  Widget build(BuildContext context) {
    return buildFocus(
      child: CanShowFieldBlocBuilder(
        fieldBloc: widget.inputFieldBloc,
        animate: widget.animateWhenCanShow,
        builder: (context, _) =>
            BlocBuilder<InputFieldBloc<XFile, dynamic>, InputFieldBlocState<XFile, dynamic>>(
          cubit: widget.inputFieldBloc,
          builder: (context, state) {
            final isEnabled = fieldBlocIsEnabled(
              isEnabled: widget.isEnabled,
              enableOnlyWhenFormBlocCanSubmit: widget.enableOnlyWhenFormBlocCanSubmit,
              fieldBlocState: state,
            );

            return DefaultFieldBlocBuilderPadding(
              padding: widget.padding,
              child: InkWell(
                onTap: pick,
                child: InputDecorator(
                  decoration: widget.buildDecoration(context, state, isEnabled),
                  isEmpty: state.value == null,
                  child: state.value == null ? null : _buildValue(isEnabled, state.value),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildValue(bool isEnabled, XFile file) {
    final child = widget.builder != null ? widget.builder(context, file) : Text(file.name);

    return DefaultFieldBlocBuilderTextStyle(
      isEnabled: isEnabled,
      child: child,
    );
  }
}
