import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future.microtask(() {
      context.read<StoryProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StoryProvider>(
        builder: (context, provider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // AppBar personalizada
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          'História Viva',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          // Área de entrada do usuário
                          AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) => Transform.scale(
                              scale: _scaleAnimation.value,
                              child: child,
                            ),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Sua ideia para a história',
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Text(
                                        provider.userInput.isEmpty
                                            ? 'Pressione o botão do microfone e fale sua ideia...'
                                            : provider.userInput,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: provider.userInput.isEmpty
                                              ? Theme.of(context).colorScheme.outline
                                              : Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildActionButton(
                                          icon: provider.isListening ? Icons.mic_off : Icons.mic,
                                          label: provider.isListening ? 'Parar' : 'Falar',
                                          onPressed: provider.isListening
                                              ? () {
                                                  provider.stopListening();
                                                  _controller.reverse();
                                                }
                                              : () {
                                                  provider.startListening();
                                                  _controller.forward();
                                                },
                                          context: context,
                                          isListening: provider.isListening,
                                        ),
                                        _buildActionButton(
                                          icon: Icons.auto_stories,
                                          label: 'Gerar História',
                                          onPressed: provider.userInput.isEmpty ? null : provider.generateStory,
                                          context: context,
                                        ),
                                        IconButton(
                                          onPressed: provider.userInput.isEmpty ? null : provider.clearInput,
                                          icon: const Icon(Icons.clear),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Área da história
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'História Gerada',
                                          style: Theme.of(context).textTheme.titleLarge,
                                        ),
                                        Row(
                                          children: [
                                            if (provider.currentStory.isNotEmpty)
                                              IconButton(
                                                onPressed: () async {
                                                  await Clipboard.setData(
                                                    ClipboardData(text: provider.currentStory),
                                                  );
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: const Text('História copiada para a área de transferência!'),
                                                        backgroundColor: Theme.of(context).colorScheme.secondary,
                                                        behavior: SnackBarBehavior.floating,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                icon: const Icon(Icons.copy),
                                                tooltip: 'Copiar história',
                                                style: IconButton.styleFrom(
                                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
                                                ),
                                              ),
                                            if (provider.currentStory.isNotEmpty)
                                              const SizedBox(width: 8),
                                            if (provider.currentStory.isNotEmpty)
                                              IconButton(
                                                onPressed: provider.clearStory,
                                                icon: const Icon(Icons.clear),
                                                tooltip: 'Limpar história',
                                                style: IconButton.styleFrom(
                                                  backgroundColor: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    if (provider.isLoading)
                                      Expanded(
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircularProgressIndicator(
                                                color: Theme.of(context).colorScheme.secondary,
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'Gerando sua história...',
                                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                  color: Theme.of(context).colorScheme.secondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.surface,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                                            ),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Text(
                                              provider.currentStory.isEmpty
                                                  ? 'Sua história aparecerá aqui...'
                                                  : provider.currentStory,
                                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                color: provider.currentStory.isEmpty
                                                    ? Theme.of(context).colorScheme.outline
                                                    : Theme.of(context).colorScheme.onSurface,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required BuildContext context,
    bool isListening = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: isListening
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isListening
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isListening
            ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.1)
            : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
      ),
    );
  }
}