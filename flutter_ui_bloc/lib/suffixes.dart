import 'package:flutter/material.dart';
import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';

class AddChekSuffixInputFieldBlocBuilder extends StatelessWidget {
  final InputFieldBloc<Object, Object>? inputFieldBloc;
  final Color? color;
  final double? opacity;
  final double? size;
  final Widget Function(BuildContext context, bool hasValue)? builder;

  const AddChekSuffixInputFieldBlocBuilder({
    Key? key,
    required this.inputFieldBloc,
    this.color,
    this.opacity,
    this.size,
    this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (inputFieldBloc == null) return const SizedBox.shrink();

    return IconTheme.merge(
      data: IconThemeData(
        color: color,
        opacity: opacity,
        size: size,
      ),
      child: BlocBuilder<InputFieldBloc<Object?, dynamic>, InputFieldBlocState<Object?, dynamic>>(
        bloc: inputFieldBloc,
        builder: (context, state) {
          if (builder != null) return builder!(context, state.hasValue);

          if (state.hasValue) {
            return const Icon(Icons.check);
          } else {
            return const Icon(Icons.add);
          }
        },
      ),
    );
  }
}
