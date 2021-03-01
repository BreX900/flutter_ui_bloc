import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';

typedef FieldValuePicker<T> = Future<T> Function(BuildContext context, T currentValue);

typedef FieldValueBuilder<T> = Widget Function(BuildContext context, T currentValue);

/// Makes the whole FieldBlocBuilder clickable
class InkWellFieldBlocBuilder extends StatelessWidget {
  final BooleanFieldBloc<Object> booleanFieldBloc;
  final Widget child;

  const InkWellFieldBlocBuilder({
    Key key,
    @required this.booleanFieldBloc,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

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
          onTap: () => booleanFieldBloc.updateValue(!booleanFieldBloc.value),
          child: child,
        );
      },
    );
  }
}
