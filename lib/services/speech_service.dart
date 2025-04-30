import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';

class SpeechService {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  Timer? _silenceTimer;

  Future<void> initialize() async {
    _speechEnabled = await _speechToText.initialize();
  }

  Future<void> startListening(Function(String) onResult, Function() onTimeout) async {
    if (_speechEnabled) {
      await _speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
          // Reseta o timer quando há fala
          _silenceTimer?.cancel();
          _silenceTimer = Timer(const Duration(seconds: 5), () {
            stopListening();
            onTimeout();
          });
        },
        localeId: 'pt_BR',
      );
    }
  }

  Future<void> stopListening() async {
    _silenceTimer?.cancel();
    await _speechToText.stop();
  }

  bool get isListening => _speechToText.isListening;
  bool get speechEnabled => _speechEnabled;
}
