import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:flutter_ui_bloc/src/form/fields/common/BaseFieldBlocBuilder.dart';

class SliderFieldBlocBuilder extends StatelessWidget with DecorationOnFieldBlocBuilder {
  final InputFieldBloc<double, dynamic>? inputFieldBloc;

  /// [TextFieldBlocBuilder.animateWhenCanShow]
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// [TextFieldBlocBuilder.animateWhenCanShow]
  final bool animateWhenCanShow;

  /// [TextFieldBlocBuilder.isEnabled]
  final bool isEnabled;

  /// [TextFieldBlocBuilder.readOnly]
  final bool readOnly;

  /// [TextFieldBlocBuilder.padding]
  final EdgeInsets? padding;

  /// [TextField.decoration]
  @override
  final InputDecoration decoration;

  /// [TextFieldBlocBuilder.suffixButton]
  @override
  final SuffixButton? suffixButton;

  /// [TextFieldBlocBuilder.clearTextIcon]
  @override
  final Widget clearIcon;

  /// [Slider.min]
  final double min;

  /// [Slider.max]
  final double max;

  /// [Slider.divisions]
  final int? divisions;

  @override
  final FieldBlocErrorBuilder? errorBuilder;

  final String Function(BuildContext context, double value)? valueStringifier;

  @override
  SingleFieldBloc<dynamic, dynamic, FieldBlocState, dynamic> get fieldBloc => inputFieldBloc!;

  const SliderFieldBlocBuilder({
    Key? key,
    required this.inputFieldBloc,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.isEnabled = true,
    this.readOnly = false,
    this.animateWhenCanShow = true,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.padding,
    this.decoration = const InputDecoration(),
    this.suffixButton,
    this.clearIcon = const Icon(Icons.clear),
    this.errorBuilder,
    this.valueStringifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (inputFieldBloc == null) return const SizedBox.shrink();

    return CanShowFieldBlocBuilder(
      fieldBloc: inputFieldBloc!,
      animate: animateWhenCanShow,
      builder: (context, _) {
        return BlocBuilder<InputFieldBloc<double, dynamic>, InputFieldBlocState<double?, dynamic>>(
          bloc: inputFieldBloc,
          builder: (context, state) {
            final isEnabled = fieldBlocIsEnabled(
              isEnabled: this.isEnabled,
              enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
              fieldBlocState: state,
            );
            final value = state.value ?? 0.5;

            return Stack(
              children: [
                DefaultFieldBlocBuilderPadding(
                  padding: padding,
                  child: InputDecorator(
                    decoration: buildDecoration(context, state, isEnabled),
                    isEmpty: false,
                    child: const SizedBox(height: 20),
                  ),
                ),
                Positioned(
                  top: 15.0,
                  left: 0.0,
                  right: 0.0,
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: divisions,
                    onChanged: isEnabled && !readOnly ? inputFieldBloc!.updateValue : null,
                    label: valueStringifier?.call(context, value),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
