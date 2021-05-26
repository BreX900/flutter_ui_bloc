import 'package:cross_file_picker/cross_file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: TestPage(),
      ),
    );
  }
}

class TestFormBloc extends FormBloc<int, int> {
  final fileFieldBloc = InputFieldBloc<XFile, Never>();
  final sliderFieldBloc = InputFieldBloc<double, Never>(
    initialValue: 0.5,
  );
  final durationFieldBloc = InputFieldBloc<Duration, Never>();

  TestFormBloc() {
    addFieldBlocs(fieldBlocs: [fileFieldBloc, sliderFieldBloc, durationFieldBloc]);
    fileFieldBloc.stream.listen(print);
  }

  @override
  void onSubmitting() async {
    await Future.delayed(Duration(seconds: 3));
    emitSuccess(canSubmitAgain: true);
  }
}

class TestPage extends StatelessWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TestFormBloc>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InputFileFieldBlocBuilder(
              inputFieldBloc: bloc.fileFieldBloc,
              decoration: InputDecoration(labelText: "ciao"),
              picker: (context, _) => CrossFilePicker().pickSingleFile(type: FileType.image),
              // picker: (context, _) =>
              //     CrossFilePicker().pickSingleImage(source: ImageSource.gallery),
            ),
            SliderFieldBlocBuilder(
              sliderFieldBloc: bloc.sliderFieldBloc,
              decoration: InputDecoration(
                labelText: 'Slider',
              ),
            ),
            DurationFieldBlocBuilder(
              inputFieldBloc: bloc.durationFieldBloc,
              requests: [],
              decoration: InputDecoration(
                labelText: 'Duration',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
