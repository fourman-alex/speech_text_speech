import 'package:speech_to_text/speech_to_text.dart';

class Stt {
  Stt({
    required this.onStatus,
    required this.onError,
  }) {
    Future(() async {
      try {
        final res = await _speechToText.initialize(
          onError: (errorNotification) {
            print('error: ' + errorNotification.errorMsg);
            onError(Exception(errorNotification.errorMsg));
            onStatus(SttStatus.error);
          },
          onStatus: (status) {
            print('status: ' + status);
            switch (status) {
              case 'listening':
                onStatus(SttStatus.listening);
                break;
              case 'notListening':
                onStatus(SttStatus.notListening);
                break;
              case 'done':
                onStatus(SttStatus.done);
                break;
            }
          },
        );
        if (!res) {
          onError(Exception('Could not initialize speech to text service'));
          onStatus(SttStatus.error);
        } else {
          _sttDidInit = true;
          onStatus(SttStatus.done);
        }
      } on Exception catch (e) {
        onError(e);
        onStatus(SttStatus.error);
      }
    });
  }

  final void Function(SttStatus status) onStatus;
  final void Function(Exception e) onError;
  late final SpeechToText _speechToText = SpeechToText();
  bool _sttDidInit = false;

  Future<void> listen(void Function(String result) onResult) async {
    if (!_sttDidInit) {
      throw Exception('Service not initialized');
    }
    try {
      await _speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
      );
    } on Exception catch (e) {
      onError(e);
      onStatus(SttStatus.error);
    }
  }

  Future<void> stop() async {
    if (!_sttDidInit) {
      throw Exception('Service not initialized');
    }
    try {
      await _speechToText.stop();
    } on Exception catch (e) {
      onError(e);
      onStatus(SttStatus.error);
    }
  }
}

enum SttStatus {
  listening,
  notListening,
  done,
  error,
}
