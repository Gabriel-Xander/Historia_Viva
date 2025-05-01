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
  final TextEditingController _textController = TextEditingController();

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
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      body: Consumer<StoryProvider>(
        builder: (context, provider, child) {
          // Atualiza o controlador de texto quando o userInput muda
          if (_textController.text != provider.userInput) {
            _textController.text = provider.userInput;
            _textController.selection = TextSelection.fromPosition(
              TextPosition(offset: _textController.text.length),
            );
          }

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
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16.0 : screenSize.width * 0.1,
                    vertical: 16.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título
                      Text(
                        'História Viva',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: isSmallScreen ? 32 : 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Área de entrada do usuário
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Sua ideia para a história',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: isSmallScreen ? 20 : 24,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: isSmallScreen ? 100 : 120,
                                  maxHeight: 200,
                                ),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                                  ),
                                ),
                                child: provider.isEditing
                                    ? TextField(
                                        controller: _textController,
                                        autofocus: true,
                                        maxLines: null,
                                        onChanged: provider.updateUserInput,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Digite sua ideia para a história...',
                                          hintStyle: TextStyle(
                                            color: Theme.of(context).colorScheme.outline,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: provider.isListening ? null : provider.startEditing,
                                        child: Text(
                                          provider.userInput.isEmpty
                                              ? 'Pressione o botão do microfone para falar ou toque aqui para digitar...'
                                              : provider.userInput,
                                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            color: provider.userInput.isEmpty
                                                ? Theme.of(context).colorScheme.outline
                                                : Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 24),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                alignment: WrapAlignment.spaceEvenly,
                                children: [
                                  _buildActionButton(
                                    icon: provider.isListening ? Icons.mic_off : Icons.mic,
                                    label: provider.isListening ? 'Parar' : 'Falar',
                                    onPressed: provider.isEditing
                                        ? null
                                        : (provider.isListening
                                            ? () {
                                                provider.stopListening();
                                                _controller.reverse();
                                              }
                                            : () {
                                                provider.startListening();
                                                _controller.forward();
                                              }),
                                    context: context,
                                    isListening: provider.isListening,
                                  ),
                                  _buildActionButton(
                                    icon: Icons.edit,
                                    label: provider.isEditing ? 'Concluir' : 'Digitar',
                                    onPressed: provider.isListening
                                        ? null
                                        : (provider.isEditing
                                            ? provider.stopEditing
                                            : provider.startEditing),
                                    context: context,
                                    isEditing: provider.isEditing,
                                  ),
                                  _buildActionButton(
                                    icon: Icons.auto_stories,
                                    label: 'Gerar História',
                                    onPressed: provider.userInput.isEmpty ? null : provider.generateStory,
                                    context: context,
                                  ),
                                  if (provider.userInput.isNotEmpty)
                                    IconButton.filled(
                                      onPressed: provider.clearInput,
                                      icon: const Icon(Icons.clear),
                                      tooltip: 'Limpar entrada',
                                      style: IconButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.errorContainer,
                                        foregroundColor: Theme.of(context).colorScheme.error,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Área da história
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'História Gerada',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontSize: isSmallScreen ? 20 : 24,
                                    ),
                                  ),
                                  if (provider.currentStory.isNotEmpty)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton.filled(
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
                                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                            foregroundColor: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton.filled(
                                          onPressed: provider.clearStory,
                                          icon: const Icon(Icons.clear),
                                          tooltip: 'Limpar história',
                                          style: IconButton.styleFrom(
                                            backgroundColor: Theme.of(context).colorScheme.errorContainer,
                                            foregroundColor: Theme.of(context).colorScheme.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: isSmallScreen ? 200 : 300,
                                  maxHeight: isSmallScreen ? 300 : 500,
                                ),
                                child: provider.isLoading
                                    ? Center(
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
                                      )
                                    : Container(
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
                    ],
                  ),
                ),
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
    bool isEditing = false,
  }) {
    final isActive = isListening || isEditing;
    final activeColor = isListening
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.secondary;

    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: isActive
            ? (isListening
                ? Theme.of(context).colorScheme.errorContainer
                : Theme.of(context).colorScheme.secondaryContainer)
            : Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: isActive
            ? (isListening
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.secondary)
            : Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}