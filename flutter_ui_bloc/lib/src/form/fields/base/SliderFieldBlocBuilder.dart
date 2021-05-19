import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/utils/utils.dart';

class SliderFieldBlocBuilder extends StatelessWidget {
  final InputFieldBloc<double, dynamic>? sliderFieldBloc;

  /// [TextFieldBlocBuilder.isEnabled]
  final bool isEnabled;

  /// [TextFieldBlocBuilder.readOnly]
  final bool readOnly;

  /// [TextFieldBlocBuilder.animateWhenCanShow]
  final bool animateWhenCanShow;

  /// [TextFieldBlocBuilder.animateWhenCanShow]
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// [TextFieldBlocBuilder.padding]
  final EdgeInsets? padding;

  /// [TextField.decoration]
  final InputDecoration decoration;

  /// [Slider.min]
  final double min;

  /// [Slider.max]
  final double max;

  /// [Slider.divisions]
  final int? divisions;

  final String Function(BuildContext context, double value)? valueStringifier;

  const SliderFieldBlocBuilder({
    Key? key,
    required this.sliderFieldBloc,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.valueStringifier,
    this.isEnabled = true,
    this.readOnly = false,
    this.animateWhenCanShow = true,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.padding,
    this.decoration = const InputDecoration(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sliderFieldBloc == null) return const SizedBox.shrink();

    return CanShowFieldBlocBuilder(
      fieldBloc: sliderFieldBloc!,
      animate: animateWhenCanShow,
      builder: (context, _) {
        return BlocBuilder<InputFieldBloc<double, dynamic>, InputFieldBlocState<double?, dynamic>>(
          bloc: sliderFieldBloc,
          builder: (context, state) {
            final isEnabled = fieldBlocIsEnabled(
              isEnabled: this.isEnabled,
              enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
              fieldBlocState: state,
            );
            final value = state.value ?? 0.5;

            return DefaultFieldBlocBuilderPadding(
              padding: padding,
              child: InputDecorator(
                decoration: decoration,
                isEmpty: false,
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: isEnabled && !readOnly ? sliderFieldBloc!.updateValue : null,
                  label: valueStringifier?.call(context, value),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
