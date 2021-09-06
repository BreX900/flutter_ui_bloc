import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

abstract class SubmitButtonFormBlocBuilderBase<TFormBloc extends FormBloc<TSuccess, TFailure>,
    TSuccess, TFailure> extends StatelessWidget {
  final TFormBloc? formBloc;
  final int? validationStep;

  const SubmitButtonFormBlocBuilderBase({
    Key? key,
    this.formBloc,
    this.validationStep = -1,
  }) : super(key: key);

  bool canSubmit(FormBlocState<TSuccess, TFailure> state) {
    if (!state.canSubmit) return false;

    final validationStep = this.validationStep;
    if (validationStep == null || validationStep >= 0) {
      if (!state.isValid(validationStep)) return false;
    }

    return true;
  }

  Widget buildButton(
    BuildContext context,
    TFormBloc formBloc,
    FormBlocState<TSuccess, TFailure> state,
  );

  @override
  Widget build(BuildContext context) {
    final formBloc = this.formBloc ?? context.read<TFormBloc>();

    return BlocBuilder<TFormBloc, FormBlocState<TSuccess, TFailure>>(
      bloc: formBloc,
      builder: (context, state) => buildButton(context, formBloc, state),
    );
  }
}
