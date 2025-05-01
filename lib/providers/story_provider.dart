import 'package:flutter/foundation.dart';
import '../services/gemini_service.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';

class StoryProvider with ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final SpeechService _speechService = SpeechService();
  final TTSService _ttsService = TTSService();

  String _currentStory = '';
  String _userInput = '';
  bool _isLoading = false;
  bool _isListening = false;
  bool _isEditing = false;

  String get currentStory => _currentStory;
  String get userInput => _userInput;
  bool get isLoading => _isLoading;
  bool get isListening => _isListening;
  bool get isEditing => _isEditing;

  Future<void> initialize() async {
    await _speechService.initialize();
  }

  Future<void> startListening() async {
    _isListening = true;
    _isEditing = false;
    notifyListeners();

    await _speechService.startListening(
      (text) {
        _userInput = text;
        notifyListeners();
      },
      () {
        _isListening = false;
        notifyListeners();
      },
    );
  }

  Future<void> stopListening() async {
    await _speechService.stopListening();
    _isListening = false;
    notifyListeners();
  }

  void startEditing() {
    _isEditing = true;
    notifyListeners();
  }

  void updateUserInput(String text) {
    _userInput = text;
    notifyListeners();
  }

  void stopEditing() {
    _isEditing = false;
    notifyListeners();
  }

  Future<void> generateStory() async {
    if (_userInput.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final prompt = 'Crie uma história criativa e envolvente baseada no seguinte tema ou ideia: $_userInput. '
          'A história deve ser adequada para todas as idades e ter um tom positivo e inspirador.';
      
      _currentStory = await _geminiService.generateStory(prompt);
      await _ttsService.speak(_currentStory);
    } catch (e) {
      _currentStory = 'Erro ao gerar história: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> stopSpeaking() async {
    await _ttsService.stop();
  }

  void clearInput() {
    _userInput = '';
    _isEditing = false;
    notifyListeners();
  }

  void clearStory() {
    _currentStory = '';
    notifyListeners();
  }
} 