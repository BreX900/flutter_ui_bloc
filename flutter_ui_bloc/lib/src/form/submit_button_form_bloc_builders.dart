import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_ui_bloc/src/form/submit_button_form_bloc_builder_base.dart';

typedef BlocNullWidgetBuilder<S> = Widget? Function(BuildContext context, S state);
typedef WillSubmitCallback = Future<bool> Function();

enum _SubmitButtonType { text, elevated, outlined }

class SubmitButtonFormBlocBuilder<TFormBloc extends FormBloc<TSuccess, TFailure>, TSuccess,
    TFailure> extends SubmitButtonFormBlocBuilderBase<TFormBloc, TSuccess, TFailure> {
  final _SubmitButtonType type;

  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final BlocNullWidgetBuilder<FormBlocState>? iconBuilder;
  final BlocWidgetBuilder<FormBlocState> labelBuilder;

  static const int validateCurrentStep = -1;
  static const int? validateAllSteps = null;
  static const int ignoreStepValidation = -2;

  const SubmitButtonFormBlocBuilder.text({
    Key? key,
    TFormBloc? formBloc,
    int? validationStep = SubmitButtonFormBlocBuilder.ignoreStepValidation,
    WillSubmitCallback? willSubmit,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.iconBuilder,
    required this.labelBuilder,
  })  : type = _SubmitButtonType.text,
        super(key: key, formBloc: formBloc, validationStep: validationStep, willSubmit: willSubmit);

  const SubmitButtonFormBlocBuilder.elevated({
    Key? key,
    TFormBloc? formBloc,
    int? validationStep = SubmitButtonFormBlocBuilder.ignoreStepValidation,
    WillSubmitCallback? willSubmit,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.iconBuilder,
    required this.labelBuilder,
  })  : type = _SubmitButtonType.elevated,
        super(key: key, formBloc: formBloc, validationStep: validationStep, willSubmit: willSubmit);

  const SubmitButtonFormBlocBuilder.outlined({
    Key? key,
    TFormBloc? formBloc,
    int? validationStep = SubmitButtonFormBlocBuilder.ignoreStepValidation,
    WillSubmitCallback? willSubmit,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.iconBuilder,
    required this.labelBuilder,
  })  : type = _SubmitButtonType.outlined,
        super(key: key, formBloc: formBloc, validationStep: validationStep, willSubmit: willSubmit);

  @override
  Widget buildButton(
    BuildContext context,
    TFormBloc formBloc,
    FormBlocState<TSuccess, TFailure> state,
  ) {
    final onPressed = canSubmit(state) ? () => submit(formBloc) : null;
    final child = labelBuilder(context, state);
    final icon = iconBuilder != null ? iconBuilder!(context, state) : null;

    switch (type) {
      case _SubmitButtonType.text:
        return icon != null
            ? TextButton.icon(
                onPressed: onPressed,
                onLongPress: onLongPress,
                style: style,
                focusNode: focusNode,
                autofocus: autofocus,
                clipBehavior: clipBehavior,
                icon: icon,
                label: child,
              )
            : TextButton(
                onPressed: onPressed,
                onLongPress: onLongPress,
                style: style,
                focusNode: focusNode,
                autofocus: autofocus,
                clipBehavior: clipBehavior,
                child: child,
              );
      case _SubmitButtonType.elevated:
        return icon != null
            ? ElevatedButton.icon(
                onPressed: onPressed,
                onLongPress: onLongPress,
                style: style,
                focusNode: focusNode,
                autofocus: autofocus,
                clipBehavior: clipBehavior,
                icon: icon,
                label: child,
              )
            : ElevatedButton(
                onPressed: onPressed,
                onLongPress: onLongPress,
                style: style,
                focusNode: focusNode,
                autofocus: autofocus,
                clipBehavior: clipBehavior,
                child: child,
              );
      case _SubmitButtonType.outlined:
        return icon != null
            ? OutlinedButton.icon(
                onPressed: onPressed,
                onLongPress: onLongPress,
                style: style,
                focusNode: focusNode,
                autofocus: autofocus,
                clipBehavior: clipBehavior,
                label: child,
                icon: icon,
              )
            : OutlinedButton(
                onPressed: onPressed,
                onLongPress: onLongPress,
                style: style,
                focusNode: focusNode,
                autofocus: autofocus,
                clipBehavior: clipBehavior,
                child: child,
              );
    }
  }
}

class SubmitFloatingButtonFormBlocBuilder<TFormBloc extends FormBloc<TSuccess, TFailure>, TSuccess,
    TFailure> extends SubmitButtonFormBlocBuilderBase<TFormBloc, TSuccess, TFailure> {
  final BlocWidgetBuilder<FormBlocState<TSuccess, TFailure>> builder;

  const SubmitFloatingButtonFormBlocBuilder({
    Key? key,
    TFormBloc? formBloc,
    int? validationStep = SubmitButtonFormBlocBuilder.ignoreStepValidation,
    WillSubmitCallback? willSubmit,
    this.builder = buildIcon,
  }) : super(key: key, formBloc: formBloc, validationStep: validationStep, willSubmit: willSubmit);

  static Widget buildIcon(BuildContext context, FormBlocState<dynamic, dynamic> state) {
    return const Icon(Icons.check);
  }

  @override
  Widget buildButton(
      BuildContext context, TFormBloc formBloc, FormBlocState<TSuccess, TFailure> state) {
    return FloatingActionButton(
      onPressed: canSubmit(state) ? () => submit(formBloc) : null,
      child: builder(context, state),
    );
  }
}

class SubmitIconButtonFormBlocBuilder<TFormBloc extends FormBloc<TSuccess, TFailure>, TSuccess,
    TFailure> extends SubmitButtonFormBlocBuilderBase<TFormBloc, TSuccess, TFailure> {
  final BlocWidgetBuilder<FormBlocState<TSuccess, TFailure>> builder;

  const SubmitIconButtonFormBlocBuilder({
    Key? key,
    TFormBloc? formBloc,
    int? validationStep = SubmitButtonFormBlocBuilder.ignoreStepValidation,
    WillSubmitCallback? willSubmit,
    this.builder = buildIcon,
  }) : super(key: key, formBloc: formBloc, validationStep: validationStep, willSubmit: willSubmit);

  static Widget buildIcon(BuildContext context, FormBlocState<dynamic, dynamic> state) {
    return const Icon(Icons.check);
  }

  @override
  Widget buildButton(
      BuildContext context, TFormBloc formBloc, FormBlocState<TSuccess, TFailure> state) {
    return IconButton(
      onPressed: canSubmit(state) ? () => submit(formBloc) : null,
      icon: builder(context, state),
    );
  }
}
