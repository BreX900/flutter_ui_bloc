import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_ui_bloc/src/form/submit_button_form_bloc_builders.dart';

abstract class SubmitButtonFormBlocBuilderBase<TFormBloc extends FormBloc<TSuccess, TFailure>,
    TSuccess, TFailure> extends StatelessWidget {
  final TFormBloc? formBloc;
  final int? validationStep;

  const SubmitButtonFormBlocBuilderBase({
    Key? key,
    this.formBloc,
    this.validationStep = SubmitButtonFormBlocBuilder.ignoreStepValidation,
  }) : super(key: key);

  bool canSubmit(FormBlocState<TSuccess, TFailure> state) {
    if (!state.canSubmit) return false;

    final validationStep = this.validationStep;
    if (validationStep == null ||
        validationStep > SubmitButtonFormBlocBuilder.ignoreStepValidation) {
      if (validationStep == SubmitButtonFormBlocBuilder.validateCurrentStep) {
        if (!state.isValid(state.currentStep)) return false;
      } else if (!state.isValid(validationStep)) {
        return false;
      }
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
