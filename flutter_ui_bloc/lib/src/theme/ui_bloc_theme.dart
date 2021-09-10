import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class SubmitButtonTheme {
  final BlocWidgetBuilder<FormBlocState> iconBuilder;
  final ButtonStyle style;

  const SubmitButtonTheme({
    required this.iconBuilder,
    required this.style,
  });

  static Widget? buildIcon(BuildContext context, FormBlocState state) {
    if (state is FormBlocSubmissionFailed) {
      return const Icon(Icons.error_outline);
    }
    return null;
  }
}

class UiBlocTheme {
  final SubmitButtonTheme submitButton;

  const UiBlocTheme({
    required this.submitButton,
  });
}
