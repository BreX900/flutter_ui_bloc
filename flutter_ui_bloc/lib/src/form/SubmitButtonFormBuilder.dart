import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

typedef BlocNullWidgetBuilder<S> = Widget? Function(BuildContext context, S state);

enum _SubmitButtonType { text, elevated, outlined }

class SubmitButtonFormBlocBuilder<TSuccess, TFailure> extends StatelessWidget {
  final _SubmitButtonType type;
  final FormBloc<TSuccess, TFailure> formBloc;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final BlocNullWidgetBuilder<FormBlocState>? iconBuilder;
  final BlocWidgetBuilder<FormBlocState> labelBuilder;

  const SubmitButtonFormBlocBuilder.text({
    Key? key,
    required this.formBloc,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.iconBuilder,
    required this.labelBuilder,
  })  : type = _SubmitButtonType.text,
        super(key: key);

  const SubmitButtonFormBlocBuilder.elevated({
    Key? key,
    required this.formBloc,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.iconBuilder,
    required this.labelBuilder,
  })  : type = _SubmitButtonType.elevated,
        super(key: key);

  const SubmitButtonFormBlocBuilder.outlined({
    Key? key,
    required this.formBloc,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.iconBuilder,
    required this.labelBuilder,
  })  : type = _SubmitButtonType.outlined,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormBlocState>(
      bloc: formBloc,
      builder: (context, state) {
        final onPressed = state.canSubmit ? formBloc.submit : null;
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
      },
    );
  }
}

class FloatingSubmitButtonFormBuilder<TSuccess, TFailure> extends StatelessWidget {
  final FormBloc<TSuccess, TFailure> formBloc;
  final BlocWidgetBuilder<FormBlocState<TSuccess, TFailure>> builder;

  const FloatingSubmitButtonFormBuilder({
    Key? key,
    required this.formBloc,
    this.builder = buildIcon,
  }) : super(key: key);

  static Widget buildIcon(BuildContext context, FormBlocState<dynamic, dynamic> state) {
    return const Icon(Icons.check);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc<TSuccess, TFailure>, FormBlocState<TSuccess, TFailure>>(
      bloc: formBloc,
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: state.canSubmit ? formBloc.submit : null,
          child: builder(context, state),
        );
      },
    );
  }
}

class IconSubmitButtonFormBuilder<TSuccess, TFailure> extends StatelessWidget {
  final FormBloc<TSuccess, TFailure> formBloc;
  final BlocWidgetBuilder<FormBlocState<TSuccess, TFailure>> builder;

  const IconSubmitButtonFormBuilder({
    Key? key,
    required this.formBloc,
    this.builder = buildIcon,
  }) : super(key: key);

  static Widget buildIcon(BuildContext context, FormBlocState<dynamic, dynamic> state) {
    return const Icon(Icons.check);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc<TSuccess, TFailure>, FormBlocState<TSuccess, TFailure>>(
      bloc: formBloc,
      builder: (context, state) {
        return IconButton(
          onPressed: state.canSubmit ? formBloc.submit : null,
          icon: builder(context, state),
        );
      },
    );
  }
}
