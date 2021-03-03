import 'package:flutter/material.dart';
import 'package:flutter_ui_bloc/flutter_ui_bloc.dart';
import 'package:flutter_ui_bloc/image_picker.dart';

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
        ),
        home: TestPage(),
      ),
    );
  }
}

class TestFormBloc extends FormBloc<int, int> {
  final inputFileFB = InputFieldBloc<ReadableFile, int>();

  TestFormBloc() {
    addFieldBlocs(fieldBlocs: [inputFileFB]);
    inputFileFB.listen(print);
  }

  @override
  void onSubmitting() {
    // TODO: implement onSubmitting
  }
}

class TestPage extends StatelessWidget {
  TestPage({Key key}) : super(key: key);

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
              inputFieldBloc: bloc.inputFileFB,
              decoration: InputDecoration(labelText: "ciao"),
              // picker: (context, _) => FormBlocFilePicker().pickSingleFile(type: FileType.image),
              picker: (context, _) => FieldImagePicker().pickSingleImage(),
            ),
            Expanded(child: Text("test")),
          ],
        ),
      ),
    );
  }
}
