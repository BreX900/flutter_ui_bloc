import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

abstract class FocusFieldBlocBuilder extends StatefulWidget {
  FocusNode? get focusNode;
}

mixin FocusFieldBlocBuilderState<W extends FocusFieldBlocBuilder> on State<W> {
  final FocusNode _focusNode = FocusNode();

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _focusNode;

  @override
  void initState() {
    _effectiveFocusNode.addListener(_onFocusRequest);
    super.initState();
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusRequest);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusRequest() {
    if (_effectiveFocusNode.hasFocus) {
      onHasFocus();
    }
  }

  void onHasFocus();

  Widget buildFocus({required Widget child}) {
    return Focus(
      focusNode: _effectiveFocusNode,
      child: child,
    );
  }
}

mixin DecorationOnFieldBlocBuilder {
  /// [TextFieldBlocBuilder.textFieldBloc]
  SingleFieldBloc get fieldBloc;

  /// [TextFieldBlocBuilder.suffixButton]
  SuffixButton? get suffixButton;

  /// [TextField.decoration]
  InputDecoration get decoration;

  /// [TextFieldBlocBuilder.clearTextIcon]
  Widget get clearIcon;

  /// [TextFieldBlocBuilder.errorBuilder]
  FieldBlocErrorBuilder? get errorBuilder;

  Widget? _buildSuffixIcon(BuildContext context, FieldBlocState state) {
    switch (suffixButton) {
      case SuffixButton.obscureText:
        throw 'Not supported';
      case SuffixButton.clearText:
        return AnimatedOpacity(
          duration: Duration(milliseconds: 400),
          opacity: state.value == null ? 0.0 : 1.0,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            child: clearIcon,
            onTap: state.value == null ? null : fieldBloc.clear,
          ),
        );
      case SuffixButton.asyncValidating:
        throw 'Not supported';
      case null:
        return null;
    }
  }

  InputDecoration buildDecoration(BuildContext context, FieldBlocState state, bool isEnabled) {
    InputDecoration decoration = this.decoration;

    decoration = decoration.copyWith(
      enabled: isEnabled,
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: errorBuilder,
        fieldBlocState: state,
        fieldBloc: fieldBloc,
      ),
      suffixIcon: decoration.suffixIcon ?? _buildSuffixIcon(context, state),
    );

    return decoration;
  }
}
