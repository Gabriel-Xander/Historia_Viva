import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;

  TTSService() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _flutterTts.setLanguage('pt-BR');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
    });
  }

  Future<void> speak(String text) async {
    if (!_isPlaying) {
      _isPlaying = true;
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    _isPlaying = false;
    await _flutterTts.stop();
  }

  bool get isPlaying => _isPlaying;
}
