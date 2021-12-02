import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/can_show_field_bloc_builder.dart';
// ignore: implementation_imports
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:flutter_ui_bloc/src/form/fields/common/base_field_bloc_builder.dart';

class ChipGroupFieldBlocBuilder<T> extends StatefulWidget
    with DecorationOnFieldBlocBuilder
    implements FocusFieldBlocBuilder {
  final MultiSelectFieldBloc<T, dynamic>? multiSelectFieldBloc;

  @override
  final FocusNode? focusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool readOnly;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsets? padding;

  @override
  final InputDecoration decoration;

  @override
  final FieldBlocErrorBuilder? errorBuilder;

  final Widget Function(BuildContext context, T value) labelBuilder;

  const ChipGroupFieldBlocBuilder({
    Key? key,
    required this.multiSelectFieldBloc,
    this.focusNode,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.readOnly = false,
    this.animateWhenCanShow = true,
    this.padding,
    this.decoration = const InputDecoration(),
    this.errorBuilder,
    required this.labelBuilder,
  }) : super(key: key);

  @override
  _ChipGroupFieldBlocBuilderState<T> createState() => _ChipGroupFieldBlocBuilderState<T>();

  @override
  Widget get clearIcon => const Icon(Icons.clear);

  @override
  SingleFieldBloc get fieldBloc => multiSelectFieldBloc!;

  @override
  SuffixButton? get suffixButton => null;
}

class _ChipGroupFieldBlocBuilderState<T> extends State<ChipGroupFieldBlocBuilder<T>>
    with FocusFieldBlocBuilderState {
  @override
  void onHasFocus() {}

  @override
  Widget build(BuildContext context) {
    if (widget.multiSelectFieldBloc == null) return const SizedBox.shrink();

    return CanShowFieldBlocBuilder(
      fieldBloc: widget.multiSelectFieldBloc!,
      animate: widget.animateWhenCanShow,
      builder: (_, __) {
        return BlocBuilder<MultiSelectFieldBloc<T, dynamic>, MultiSelectFieldBlocState<T, dynamic>>(
          bloc: widget.multiSelectFieldBloc,
          builder: (context, state) {
            final isEnabled = fieldBlocIsEnabled(
              isEnabled: widget.isEnabled,
              enableOnlyWhenFormBlocCanSubmit: widget.enableOnlyWhenFormBlocCanSubmit,
              fieldBlocState: state,
            );

            final values = state.value;
            final items = state.items;

            return DefaultFieldBlocBuilderPadding(
              padding: widget.padding,
              child: InputDecorator(
                decoration: widget.buildDecoration(context, state, isEnabled),
                isEmpty: false,
                child: Wrap(
                  spacing: 8.0,
                  children: items.map((i) {
                    return ChoiceChip(
                      selected: values.contains(i),
                      onSelected: isEnabled || !widget.readOnly
                          ? ((isSelected) => isSelected
                              ? widget.multiSelectFieldBloc!.select(i)
                              : widget.multiSelectFieldBloc!.deselect(i))
                          : null,
                      label: widget.labelBuilder(context, i),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
