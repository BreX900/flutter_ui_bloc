// ignore_for_file: avoid_print

import 'package:cross_file_picker/cross_file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestFormBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const TestPage(),
      ),
    );
  }
}

class TestFormBloc extends FormBloc<int, int> {
  final fileFieldBloc = InputFieldBloc<XFile?, Never>(
    initialValue: null,
  );
  final sliderFieldBloc = InputFieldBloc<double, Never>(
    initialValue: 0.5,
    validators: [(value) => value < 0.3 ? 'Error' : null],
  );
  final durationFieldBloc = InputFieldBloc<Duration?, Never>(
    initialValue: null,
  );

  TestFormBloc() {
    addFieldBlocs(fieldBlocs: [fileFieldBloc, sliderFieldBloc, durationFieldBloc]);
    fileFieldBloc.stream.listen(print);
  }

  @override
  void onSubmitting() async {
    await Future.delayed(const Duration(seconds: 3));
    emitSuccess(canSubmitAgain: true);
  }
}

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TestFormBloc>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            UploadFileFieldBlocBuilder(
              inputFieldBloc: bloc.fileFieldBloc,
              picker: (context, _) => CrossFilePicker().pickSingleFile(type: FileType.image),
            ),
            InputFileFieldBlocBuilder(
              inputFieldBloc: bloc.fileFieldBloc,
              decoration: const InputDecoration(labelText: 'ciao'),
              // picker: (context, _) => CrossFilePicker().pickSingleFile(type: FileType.image),
              picker: (context, _) =>
                  CrossFilePicker().pickSingleImage(source: ImageSource.gallery),
            ),
            SliderFieldBlocBuilder(
              inputFieldBloc: bloc.sliderFieldBloc,
              activeColor: Colors.greenAccent,
              inactiveColor: Colors.amberAccent,
              decoration: const InputDecoration(
                labelText: 'Slider',
              ),
            ),
            DurationFieldBlocBuilder(
              inputFieldBloc: bloc.durationFieldBloc,
              requests: [DurationPickerRequest.minutes()],
              decoration: const InputDecoration(
                labelText: 'Duration',
              ),
            ),
            SubmitButtonFormBlocBuilder.elevated(
              formBloc: context.read<TestFormBloc>(),
              labelBuilder: (context, _) => const Text('Ciao'),
            ),
          ],
        ),
      ),
    );
  }
}
