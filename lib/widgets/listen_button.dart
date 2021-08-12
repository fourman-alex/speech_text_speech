import 'package:flutter/material.dart';

class ListenButton extends StatefulWidget {
  const ListenButton({Key? key, required this.textNotifier}) : super(key: key);

  final ValueNotifier<String> textNotifier;

  @override
  _ListenButtonState createState() => _ListenButtonState();
}

class _ListenButtonState extends State<ListenButton> {
  _ListenState _listenState = _ListenState.idle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (event) {
        setState(() {
          _listenState = _ListenState.listening;
        });
      },
      onTapUp: (event) {
        setState(() {
          _listenState = _ListenState.idle;
        });
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 120,
          minHeight: 30,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(4)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(_listenState == _ListenState.idle
                  ? 'Speak'
                  : 'Transcribing...'),
            ),
          ),
        ),
      ),
    );
  }
}

enum _ListenState {
  listening,
  idle,
}
