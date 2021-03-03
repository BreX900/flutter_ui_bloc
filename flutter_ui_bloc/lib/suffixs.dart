import 'package:flutter/material.dart';
import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';

class AddChekSuffixInputFieldBlocBuilder extends StatelessWidget {
  final InputFieldBloc<Object, Object> inputFieldBloc;
  final Widget Function(BuildContext context, bool hasValue) builder;

  const AddChekSuffixInputFieldBlocBuilder({
    Key key,
    @required this.inputFieldBloc,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (inputFieldBloc == null) return const SizedBox.shrink();

    return BlocBuilder<InputFieldBloc<Object, Object>, InputFieldBlocState<Object, Object>>(
      cubit: inputFieldBloc,
      builder: (context, state) {
        if (builder != null) return builder(context, state.hasValue);

        if (state.hasValue) {
          return const Icon(Icons.add);
        } else {
          return const Icon(Icons.check);
        }
      },
    );
  }
}
