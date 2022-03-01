import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/utils/utils.dart';

class CircularCheckboxFieldBlocBuilder extends StatelessWidget {
  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final BooleanFieldBloc<dynamic>? booleanFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode? nextFocusNode;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool? animateWhenCanShow;

  /// {@template flutter_form_bloc.FieldBlocBuilderControlAffinity}
  /// Where to place the control in widgets
  /// {@endtemplate}
  final FieldBlocBuilderControlAffinity controlAffinity;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@template flutter_form_bloc.FieldBlocBuilder.checkboxActiveColor}
  /// The color to use when this checkbox is checked.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor].
  /// {@endtemplate}
  final Color? checkColor;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.checkboxActiveColor}
  final Color? activeColor;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsets? padding;

  /// {@template flutter_form_bloc.FieldBlocBuilder.checkboxBody}
  /// The widget on the right side of the checkbox
  /// {@endtemplate}
  final Widget body;

  const CircularCheckboxFieldBlocBuilder({
    Key? key,
    required this.booleanFieldBloc,
    this.nextFocusNode,
    this.animateWhenCanShow,
    this.isEnabled = true,
    this.checkColor,
    this.activeColor,
    this.errorBuilder,
    this.controlAffinity = FieldBlocBuilderControlAffinity.leading,
    this.padding,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (booleanFieldBloc == null) return const SizedBox.shrink();

    return CanShowFieldBlocBuilder(
      fieldBloc: booleanFieldBloc!,
      animate: animateWhenCanShow!,
      builder: (context, _) => DefaultFieldBlocBuilderPadding(
        padding: padding,
        child: BlocBuilder<BooleanFieldBloc<dynamic>, BooleanFieldBlocState<dynamic>>(
          bloc: booleanFieldBloc,
          builder: (context, state) {
            return InputDecorator(
              decoration: Style.inputDecorationWithoutBorder.copyWith(
                prefixIcon: controlAffinity == FieldBlocBuilderControlAffinity.leading
                    ? _buildCheckbox(context: context, state: state)
                    : null,
                suffixIcon: controlAffinity == FieldBlocBuilderControlAffinity.trailing
                    ? _buildCheckbox(context: context, state: state)
                    : null,
                errorText: Style.getErrorText(
                  context: context,
                  errorBuilder: errorBuilder!,
                  fieldBlocState: state,
                  fieldBloc: booleanFieldBloc!,
                ),
              ),
              child: DefaultFieldBlocBuilderTextStyle(
                isEnabled: isEnabled,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: body,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCheckbox({
    required BuildContext context,
    required BooleanFieldBlocState state,
  }) {
    return CircularCheckbox(
      checkColor: checkColor,
      activeColor: activeColor,
      value: state.value,
      onChanged: fieldBlocBuilderOnChange<bool>(
        isEnabled: isEnabled,
        nextFocusNode: nextFocusNode,
        onChanged: booleanFieldBloc!.updateValue,
      ),
    );
  }
}

// Todo: improve with [RenderToggleable]
class CircularCheckbox extends StatelessWidget {
  final bool value;
  final Color? checkColor;
  final Color? activeColor;
  final ValueChanged<bool>? onChanged;

  const CircularCheckbox({
    Key? key,
    required this.value,
    this.checkColor,
    this.activeColor,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const size = Checkbox.width;

    const baseDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(100)),
    );

    final current = value
        ? DecoratedBox(
            decoration: baseDecoration.copyWith(
              color: activeColor ?? theme.toggleableActiveColor,
            ),
            child: Icon(Icons.check, color: checkColor ?? Colors.white, size: size),
          )
        : DecoratedBox(
            decoration: baseDecoration.copyWith(
              border: Border.all(width: 2, color: theme.unselectedWidgetColor),
            ),
          );

    return InkResponse(
      onTap: onChanged != null ? () => onChanged!(value) : null,
      child: FittedBox(
        fit: BoxFit.none,
        alignment: Alignment.center,
        child: SizedBox(
          width: size + 2,
          height: size + 2,
          child: current,
        ),
      ),
    );
  }
}
