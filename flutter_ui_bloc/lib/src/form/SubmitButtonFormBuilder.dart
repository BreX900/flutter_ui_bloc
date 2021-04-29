import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

enum _SubmitButtonType { text, elevated, outlined }

class SubmitButtonFormBlocBuilder extends StatelessWidget {
  final _SubmitButtonType type;
  final FormBloc formBloc;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final BlocWidgetBuilder<FormBlocState>? iconBuilder;
  final BlocWidgetBuilder<FormBlocState> childBuilder;

  const SubmitButtonFormBlocBuilder.text({
    Key? key,
    required this.formBloc,
    this.onLongPress,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.iconBuilder,
    required this.childBuilder,
  })   : type = _SubmitButtonType.text,
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
    required this.childBuilder,
  })   : type = _SubmitButtonType.elevated,
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
    required this.childBuilder,
  })   : type = _SubmitButtonType.outlined,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormBlocState>(
      bloc: formBloc,
      builder: (context, state) {
        final onPressed = state.canSubmit ? formBloc.submit : null;
        final child = childBuilder(context, state);
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

class FloatingSubmitButtonFormBuilder<B extends FormBloc> extends StatelessWidget {
  final B? formBloc;
  final Widget child;

  const FloatingSubmitButtonFormBuilder({
    Key? key,
    this.formBloc,
    this.child = const Icon(Icons.check),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formBloc = this.formBloc ?? BlocProvider.of<B>(context);
    return BlocBuilder<B, FormBlocState>(
      bloc: formBloc,
      builder: (context, state) {
        if (state is FormBlocSubmissionFailed) {
          return FloatingActionButton(
            onPressed: state.canSubmit ? formBloc.submit : null,
            child: child,
          );
        }
        return FloatingActionButton(
          onPressed: state.canSubmit ? formBloc.submit : null,
          child: child,
        );
      },
    );
  }
}

class IconSubmitButtonFormBuilder extends StatelessWidget {
  final FormBloc formBloc;
  final Widget icon;

  const IconSubmitButtonFormBuilder({
    Key? key,
    required this.formBloc,
    this.icon = const Icon(Icons.check),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormBlocState>(
      bloc: formBloc,
      builder: (context, state) {
        if (state is FormBlocSubmissionFailed) {
          return IconButton(
            onPressed: state.canSubmit ? formBloc.submit : null,
            icon: icon,
          );
        }
        return IconButton(
          onPressed: state.canSubmit ? formBloc.submit : null,
          icon: icon,
        );
      },
    );
  }
}
