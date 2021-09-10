import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class FormBlocBuilder<B extends FormBloc<S, F>, S, F> extends BlocBuilder<B, FormBlocState<S, F>> {
  const FormBlocBuilder({
    Key? key,
    B? formBloc,
    BlocBuilderCondition<FormBlocState<S, F>>? buildWhen,
    required BlocWidgetBuilder<FormBlocState<S, F>> builder,
  }) : super(key: key, bloc: formBloc, buildWhen: buildWhen, builder: builder);
}
