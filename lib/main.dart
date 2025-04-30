import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/story_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const HistoriaVivaApp());
}

class HistoriaVivaApp extends StatelessWidget {
  const HistoriaVivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StoryProvider(),
      child: MaterialApp(
        title: 'História Viva',
        theme: AppTheme.theme,
        home: const HomeScreen(),
      ),
    );
  }
}