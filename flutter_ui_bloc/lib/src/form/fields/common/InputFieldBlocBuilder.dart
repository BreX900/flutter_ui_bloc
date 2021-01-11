import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/can_show_field_bloc_builder.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:flutter_ui_bloc/src/form/fields/utils.dart';
import 'package:form_bloc/form_bloc.dart';

import 'BaseFieldBlocBuilder.dart';

/// A material design date picker.
class InputFieldBlocBuilder<T> extends StatefulWidget
    with DecorationOnFieldBlocBuilder
    implements FocusFieldBlocBuilder {
  const InputFieldBlocBuilder({
    Key key,
    @required this.inputFieldBloc,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.decoration = const InputDecoration(),
    this.animateWhenCanShow = true,
    this.showClearIcon = true,
    this.clearIcon,
    this.nextFocusNode,
    this.focusNode,
    @required this.picker,
    @required this.builder,
  })  : assert(enableOnlyWhenFormBlocCanSubmit != null),
        assert(isEnabled != null),
        assert(decoration != null),
        super(key: key);

  /// The `fieldBloc` for rebuild the widget when its state changes.
  final InputFieldBloc<T, Object> inputFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  @override
  final FieldBlocErrorBuilder errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry padding;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.decoration}
  @override
  final InputDecoration decoration;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.focusNode}
  @override
  final FocusNode focusNode;

  @override
  final bool showClearIcon;

  @override
  final Icon clearIcon;

  /// @macro [FieldValuePicker]
  final FieldValuePicker<T> picker;

  /// @macro [FieldValueBuilder]
  final FieldValueBuilder<T> builder;

  @override
  SingleFieldBloc get fieldBloc => inputFieldBloc;

  @override
  _InputFieldBlocBuilderState<T> createState() => _InputFieldBlocBuilderState<T>();
}

class _InputFieldBlocBuilderState<T> extends State<InputFieldBlocBuilder<T>>
    with FocusFieldBlocBuilderState {
  void updateValue(T value) {
    final updateValue = fieldBlocBuilderOnChange<T>(
      isEnabled: widget.isEnabled,
      nextFocusNode: widget.nextFocusNode,
      onChanged: widget.inputFieldBloc.updateValue,
    );
    if (updateValue != null) updateValue(value);
  }

  @override
  void onHasFocus() => pick(context);

  void pick(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    final result = await widget.picker(context, widget.inputFieldBloc.value);
    if (result == null) return;
    updateValue(result);
  }

  Widget _buildValue(T value) {
    if (value == null) return const Text('');
    return widget.builder(context, value);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.inputFieldBloc == null) return const SizedBox.shrink();

    return buildFocus(
        child: CanShowFieldBlocBuilder(
      fieldBloc: widget.inputFieldBloc,
      animate: widget.animateWhenCanShow,
      builder: (_, __) {
        return BlocBuilder<InputFieldBloc<T, Object>, InputFieldBlocState<T, Object>>(
          cubit: widget.inputFieldBloc,
          builder: (context, state) {
            final isEnabled = fieldBlocIsEnabled(
              isEnabled: widget.isEnabled,
              enableOnlyWhenFormBlocCanSubmit: widget.enableOnlyWhenFormBlocCanSubmit,
              fieldBlocState: state,
            );

            Widget child;

            if (state.value == null && widget.decoration.hintText != null) {
              child = Text(
                widget.decoration.hintText,
                style: widget.decoration.hintStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: widget.decoration.hintMaxLines,
              );
            } else {
              child = DefaultTextStyle(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: Style.getDefaultTextStyle(
                  context: context,
                  isEnabled: isEnabled,
                ),
                child: _buildValue(state.value),
              );
            }

            return DefaultFieldBlocBuilderPadding(
              padding: widget.padding,
              child: GestureDetector(
                onTap: !isEnabled ? null : () => pick(context),
                child: InputDecorator(
                  decoration: widget.buildDecoration(context, state, isEnabled),
                  isEmpty: state.value == null && widget.decoration.hintText == null,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    ));
  }
}
