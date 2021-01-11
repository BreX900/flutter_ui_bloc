import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class FormBlocBuilder<B extends FormBloc<S, F>, S, F> extends StatelessWidget {
  final B formBloc;
  final BlocWidgetBuilder<FormBlocState<S, F>> builder;

  const FormBlocBuilder({
    Key key,
    @required this.formBloc,
    @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, FormBlocState<S, F>>(
      cubit: formBloc,
      builder: builder,
    );
  }
}
