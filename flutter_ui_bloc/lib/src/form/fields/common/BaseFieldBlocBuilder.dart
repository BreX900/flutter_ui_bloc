import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

abstract class FocusFieldBlocBuilder extends StatefulWidget {
  FocusNode get focusNode;
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

  Widget buildFocus({@required Widget child}) {
    return Focus(
      focusNode: _effectiveFocusNode,
      child: child,
    );
  }
}

mixin DecorationOnFieldBlocBuilder {
  SingleFieldBloc get fieldBloc;

  bool get showClearIcon;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the
  /// extra padding introduced by the decoration to save space for the labels).
  InputDecoration get decoration;

  /// When [suffixButton] is [SuffixButton.clearText], this icon will be displayed.
  Widget get clearIcon;

  /// This function take the `context` and the [FieldBlocState.error]
  /// and must return a String error to display in the widget when
  /// has an error. By default is [defaultErrorBuilder].
  FieldBlocErrorBuilder get errorBuilder;

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
      suffixIcon: decoration.suffixIcon ??
          (showClearIcon
              ? AnimatedOpacity(
                  duration: Duration(milliseconds: 400),
                  opacity: state.value == null ? 0.0 : 1.0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    child: clearIcon ?? const Icon(Icons.clear),
                    onTap: state.value == null ? null : fieldBloc.clear,
                  ),
                )
              : null),
    );

    return decoration;
  }
}
