import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_ui_bloc/src/form/fields/common/InputFieldBlocBuilder.dart';
import 'package:flutter_ui_bloc/src/form/fields/utils.dart';
import 'package:pure_extensions/pure_extensions.dart';

class DurationFieldBlocBuilder extends StatelessWidget {
  /// [InputFieldBlocBuilder.inputFieldBloc]
  final InputFieldBloc<Duration?, dynamic>? inputFieldBloc;

  /// Defines which properties of [Duration] should be requested from the user
  /// If requests is empty the field is in [TextField.readOnly]
  final List<DurationPickerRequest> requests;

  /// [TextFieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit]
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// [TextFieldBlocBuilder.animateWhenCanShow]
  final bool animateWhenCanShow;

  /// [TextFieldBlocBuilder.nextFocusNode]
  final FocusNode? nextFocusNode;

  /// [TextFieldBlocBuilder.focusNode]
  final FocusNode? focusNode;

  /// [TextFieldBlocBuilder.isEnabled]
  final bool isEnabled;

  /// [TextField.readOnly]
  final bool readOnly;

  /// [TextFieldBlocBuilder.padding]
  final EdgeInsets? padding;

  /// [TextFieldBlocBuilder.style]
  final TextStyle? style;

  /// [TextField.decoration]
  final InputDecoration decoration;

  /// [TextFieldBlocBuilder.suffixButton]
  final SuffixButton? suffixButton;

  /// [TextFieldBlocBuilder.clearTextIcon]
  final Icon? clearIcon;

  /// Pick a value from previous value when user click on the field or the field receive the focus
  final FieldValuePicker<Duration>? picker;

  /// See [TextFieldBlocBuilder.errorBuilder]
  final FieldBlocErrorBuilder? errorBuilder;

  /// Build a widget for specific value
  final FieldValueBuilder<Duration>? builder;

  DurationFieldBlocBuilder({
    Key? key,
    required this.inputFieldBloc,
    required this.requests,
    this.enableOnlyWhenFormBlocCanSubmit = true,
    this.animateWhenCanShow = true,
    this.focusNode,
    this.nextFocusNode,
    this.isEnabled = true,
    this.readOnly = false,
    this.padding,
    this.style,
    this.decoration = const InputDecoration(),
    this.suffixButton,
    this.clearIcon = const Icon(Icons.clear),
    this.picker,
    this.errorBuilder,
    this.builder,
  }) : super(key: key);

  Future<Duration?> pickValue(BuildContext context, Duration? value) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => _Picker(
        duration: value,
        requests: requests,
      ),
    );
  }

  Widget buildValue(BuildContext context, Duration value) {
    final b = StringBuffer();
    if (value.inDays > 0) b.write('Days: ${value.inDays} - ');
    b.write('Time: ${(value.inHours % 24)}:'
        '${(value.inMinutes % 60).toString().padLeft(2, "0")}');
    return Text(b.toString());
  }

  @override
  Widget build(BuildContext context) {
    return InputFieldBlocBuilder<Duration>(
      inputFieldBloc: inputFieldBloc,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      isEnabled: isEnabled,
      readOnly: requests.isEmpty,
      enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
      animateWhenCanShow: animateWhenCanShow,
      padding: padding,
      style: style,
      decoration: decoration,
      errorBuilder: errorBuilder,
      picker: picker ?? pickValue,
      builder: builder ?? buildValue,
    );
  }
}

enum _DurationPickerRequestType { days, hours, minutes, seconds }

class DurationPickerRequest {
  final _DurationPickerRequestType type;
  final int min;
  final int max;

  DurationPickerRequest.days({this.min = 0, this.max = 364})
      : assert(min >= 0),
        assert(min > max),
        type = _DurationPickerRequestType.days;

  DurationPickerRequest.hours({this.min = 0, this.max = 24})
      : assert(min >= 0),
        assert(max <= 24),
        assert(min > max),
        type = _DurationPickerRequestType.hours;

  DurationPickerRequest.minutes({this.min = 0, this.max = 60})
      : assert(min >= 0),
        assert(max <= 60),
        assert(min > max),
        type = _DurationPickerRequestType.minutes;

  DurationPickerRequest.seconds({this.min = 0, this.max = 60})
      : assert(min >= 0),
        assert(max <= 60),
        assert(min > max),
        type = _DurationPickerRequestType.seconds;
}

class _Picker extends StatefulWidget {
  final Duration? duration;
  final List<DurationPickerRequest> requests;

  const _Picker({Key? key, required this.duration, required this.requests}) : super(key: key);

  @override
  __PickerState createState() => __PickerState();
}

class __PickerState extends State<_Picker> {
  late DurationBuilder b;
  late Map<_DurationPickerRequestType, FixedExtentScrollController> controllers;

  @override
  void initState() {
    super.initState();
    b = widget.duration?.toBuilder() ?? DurationBuilder();
    controllers = Map.fromEntries(widget.requests.map((r) {
      return MapEntry(r.type, FixedExtentScrollController(initialItem: getDurationValue(r.type)));
    }));
  }

  @override
  void dispose() {
    controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  void updateBuilder(_DurationPickerRequestType type, int value) {
    switch (type) {
      case _DurationPickerRequestType.days:
        b.days = value;
        break;
      case _DurationPickerRequestType.hours:
        b.hours = value;
        break;
      case _DurationPickerRequestType.minutes:
        b.minutes = value;
        break;
      case _DurationPickerRequestType.seconds:
        b.seconds = value;
        break;
    }
  }

  int getDurationValue(_DurationPickerRequestType type) {
    switch (type) {
      case _DurationPickerRequestType.days:
        return b.days;
      case _DurationPickerRequestType.hours:
        return b.hours;
      case _DurationPickerRequestType.minutes:
        return b.minutes;
      case _DurationPickerRequestType.seconds:
        return b.seconds;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text('Cancel'),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(b.build());
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
        Expanded(
          child: Row(
            children: widget.requests.map((r) {
              return Expanded(
                child: CupertinoPicker.builder(
                  scrollController: controllers[r.type],
                  itemExtent: 48,
                  onSelectedItemChanged: (index) => updateBuilder(r.type, r.min + index),
                  childCount: r.max,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 48,
                      alignment: Alignment.center,
                      child: Text(
                        '${r.min + index}',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
