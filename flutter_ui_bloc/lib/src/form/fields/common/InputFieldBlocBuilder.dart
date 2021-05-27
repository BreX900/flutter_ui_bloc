import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/can_show_field_bloc_builder.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';
import 'package:flutter_ui_bloc/src/form/fields/utils.dart';
import 'package:form_bloc/form_bloc.dart';

import 'BaseFieldBlocBuilder.dart';

/// A material design date picker.
class InputFieldBlocBuilder<T> extends StatefulWidget
    with DecorationOnFieldBlocBuilder
    implements FocusFieldBlocBuilder {
  /// The `fieldBloc` for rebuild the widget when its state changes.
  final InputFieldBloc<T?, dynamic>? inputFieldBloc;

  /// [TextFieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit]
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// [TextFieldBlocBuilder.animateWhenCanShow]
  final bool animateWhenCanShow;

  /// [TextFieldBlocBuilder.focusNode]
  @override
  final FocusNode? focusNode;

  /// [TextFieldBlocBuilder.nextFocusNode]
  final FocusNode? nextFocusNode;

  /// [TextFieldBlocBuilder.isEnabled]
  final bool isEnabled;

  /// [TextField.readOnly]
  final bool readOnly;

  /// [TextFieldBlocBuilder.padding]
  final EdgeInsets? padding;

  /// [TextFieldBlocBuilder.style]
  final TextStyle? style;

  /// [TextField.decoration]
  @override
  final InputDecoration decoration;

  /// [TextFieldBlocBuilder.suffixButton]
  @override
  final SuffixButton? suffixButton;

  /// [TextFieldBlocBuilder.clearTextIcon]
  @override
  final Icon clearIcon;

  /// Pick a value from previous value when user click on the field or the field receive the focus
  final FieldValuePicker<T>? picker;

  /// See [TextFieldBlocBuilder.errorBuilder]
  @override
  final FieldBlocErrorBuilder? errorBuilder;

  /// Build a widget for specific value
  final FieldValueBuilder<T> builder;

  const InputFieldBlocBuilder({
    Key? key,
    required this.inputFieldBloc,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.readOnly = false,
    this.padding,
    this.style,
    this.decoration = const InputDecoration(),
    this.animateWhenCanShow = true,
    this.suffixButton,
    this.clearIcon = const Icon(Icons.clear),
    this.nextFocusNode,
    this.focusNode,
    this.errorBuilder,
    required this.picker,
    required this.builder,
  }) : super(key: key);

  @override
  SingleFieldBloc get fieldBloc => inputFieldBloc!;

  @override
  _InputFieldBlocBuilderState<T> createState() => _InputFieldBlocBuilderState<T>();
}

class _InputFieldBlocBuilderState<T> extends State<InputFieldBlocBuilder<T>>
    with FocusFieldBlocBuilderState {
  void updateValue(T value) {
    final updateValue = fieldBlocBuilderOnChange<T>(
      isEnabled: widget.isEnabled,
      nextFocusNode: widget.nextFocusNode,
      onChanged: widget.inputFieldBloc!.updateValue,
    );
    if (updateValue != null) updateValue(value);
  }

  @override
  void onHasFocus() => pick(context);

  void pick(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (widget.picker == null) return;
    final result = await widget.picker!(context, widget.inputFieldBloc!.value);
    if (result == null) return;
    updateValue(result);
  }

  Widget? _buildValue(T? value, bool isEnabled) {
    if (value == null) return null;

    return DefaultTextStyle(
      style: widget.style ??
          Style.getDefaultTextStyle(
            context: context,
            isEnabled: isEnabled,
          )!,
      child: widget.builder(context, value),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.inputFieldBloc == null) return const SizedBox.shrink();

    return buildFocus(
      child: CanShowFieldBlocBuilder(
        fieldBloc: widget.inputFieldBloc!,
        animate: widget.animateWhenCanShow,
        builder: (_, __) {
          return BlocBuilder<InputFieldBloc<T?, dynamic>, InputFieldBlocState<T?, dynamic>>(
            bloc: widget.inputFieldBloc,
            builder: (context, state) {
              final isEnabled = fieldBlocIsEnabled(
                isEnabled: widget.isEnabled,
                enableOnlyWhenFormBlocCanSubmit: widget.enableOnlyWhenFormBlocCanSubmit,
                fieldBlocState: state,
              );
              final value = state.value;

              return DefaultFieldBlocBuilderPadding(
                padding: widget.padding,
                child: GestureDetector(
                  onTap: isEnabled && !widget.readOnly ? () => pick(context) : null,
                  child: InputDecorator(
                    decoration: widget.buildDecoration(context, state, isEnabled),
                    isEmpty: value == null,
                    child: _buildValue(state.value, isEnabled),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
