import 'package:flutter/material.dart';
import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';

typedef FieldValuePicker<T> = Future<T?> Function(BuildContext context, T? currentValue);

typedef FieldValueBuilder<T> = Widget Function(BuildContext context, T value);

/// Makes the whole FieldBlocBuilder clickable
class InkWellFieldBlocBuilder extends StatelessWidget {
  final BooleanFieldBloc<Object>? booleanFieldBloc;
  final Widget child;

  const InkWellFieldBlocBuilder({
    Key? key,
    required this.booleanFieldBloc,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (booleanFieldBloc == null) return const SizedBox.shrink();

    return BlocBuilder<BooleanFieldBloc<Object>, BooleanFieldBlocState<Object>>(
      buildWhen: (p, c) => p.formBloc != c.formBloc,
      builder: (context, state) {
        if (state.formBloc == null) {
          return child;
        }
        return InkWell(
          onTap: () => booleanFieldBloc!.changeValue(booleanFieldBloc!.value),
          child: child,
        );
      },
    );
  }
}

VoidCallback? fieldBlocBuilderOnPick<T>({
  required BuildContext context,
  required bool isEnabled,
  required FocusNode? nextFocusNode,
  required T? currentValue,
  required FieldValuePicker<T> onPick,
  required void Function(T value) onChanged,
}) {
  if (!isEnabled) return null;
  return () async {
    final value = await onPick(context, currentValue);
    if (value == null) return;
    onChanged(value);
    if (nextFocusNode != null) {
      nextFocusNode.requestFocus();
    }
  };
}
