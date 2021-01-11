import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:value_bloc/value_bloc.dart';

class ChatBloc extends FormBloc<int, int> {
  final textFieldBloc = TextFieldBloc();

  final ListValueCubit messagesValueBloc;

  ChatBloc({@required this.messagesValueBloc})
      : super(
        // Todo: complete with isLoading
        );

  @override
  void onSubmitting() {
    // TODO: implement onSubmitting
  }
}

class ChatBlocBuilder extends StatefulWidget {
  final ChatMessageData Function(BuildContext context, int index) builder;

  const ChatBlocBuilder({Key key, this.builder}) : super(key: key);

  @override
  _ChatBlocBuilderState createState() => _ChatBlocBuilderState();
}

class _ChatBlocBuilderState extends State<ChatBlocBuilder> {
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final data = widget.builder(context, index);

        return data.child;
      },
    );
  }
}

class ChatMessageData {
  final DateTime sendAt;
  final Widget child;

  ChatMessageData(this.sendAt, this.child);
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({ValueKey<DateTime> key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class InputTextChatBlocBuilder extends StatelessWidget {
  const InputTextChatBlocBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.bloc<ChatBloc>();

    return BlocBuilder<ChatBloc, FormBlocState>(
      builder: (context, state) => TextFieldBlocBuilder(
        textFieldBloc: chatBloc.textFieldBloc,
        decoration: InputDecoration(hintText: 'Write your message'),
      ),
    );
  }
}

class SendButtonChatBlocBuilder extends StatelessWidget {
  const SendButtonChatBlocBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatBloc = context.bloc<ChatBloc>();

    return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
      cubit: chatBloc.textFieldBloc,
      builder: (context, state) => IconButton(
        onPressed: state.value.isEmpty
            ? null
            : () {
                chatBloc.submit();
              },
        icon: state.value.isEmpty ? const Icon(Icons.mic) : const Icon(Icons.send),
      ),
    );
  }
}
