import 'package:flutter/material.dart';
import 'package:speech_text_speech/state/stt.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ListenButton extends StatefulWidget {
  const ListenButton({Key? key, required this.textNotifier}) : super(key: key);

  final ValueNotifier<String> textNotifier;

  @override
  _ListenButtonState createState() => _ListenButtonState();
}

class _ListenButtonState extends State<ListenButton> {
  _ListenState _listenState = _ListenState.initializing;
  late final Stt _stt;

  @override
  void initState() {
    super.initState();
    _stt = Stt(
      onStatus: (status) {
        switch (status) {
          case SttStatus.listening:
          case SttStatus.notListening:
            setState(() {
              _listenState = _ListenState.listening;
            });
            break;
          case SttStatus.done:
            setState(() {
              _listenState = _ListenState.idle;
            });
            break;
          case SttStatus.error:
            setState(() {
              _listenState = _ListenState.idle;
            });
            break;
        }
      },
      onError: (e) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (event) async {
        print('onTapDown');
        try {
          await _stt.listen((result) {
            print('words: ' + result);
            widget.textNotifier.value = result;
          });
        } on ListenFailedException catch (e) {
          widget.textNotifier.value = e.details;
        }
        setState(() {
          _listenState = _ListenState.listening;
        });
      },
      onTapUp: (event) {
        print('onTapUp');
        _stt.stop();
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
              child: Text(_buildLabel()),
            ),
          ),
        ),
      ),
    );
  }

  String _buildLabel() {
    switch (_listenState) {
      case _ListenState.initializing:
        return 'Initializing...';
      case _ListenState.listening:
        return 'Transcribing...';
      case _ListenState.idle:
        return 'Speak';
    }
  }
}

enum _ListenState {
  initializing,
  listening,
  idle,
}
