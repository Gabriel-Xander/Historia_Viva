# História Viva 📚

**Autor:** Gabriel Antonio Xander

## 📱 Sobre o Projeto

História Viva é um aplicativo inovador que transforma suas ideias em histórias envolventes usando Inteligência Artificial. Com uma interface intuitiva e moderna, o aplicativo permite que você fale sua ideia e automaticamente gera uma história criativa, que pode ser ouvida através da narração automática.

## ✨ Funcionalidades

- 🎤 Reconhecimento de voz em português
- 🤖 Geração de histórias usando IA (Google Gemini)
- 🗣️ Narração automática das histórias
- 📋 Cópia fácil do texto gerado
- 🎨 Interface moderna e responsiva
- 🔄 Timeout automático do microfone após 5 segundos de silêncio

## 📸 Screenshots

### Tela Inicial
![Tela Inicial](screenshots/tela_inicial.png)
*Tela inicial do aplicativo, mostrando a interface limpa e intuitiva.*

### Modo de Digitação
![Modo de Digitação](screenshots/modo_digitacao.png)
*Interface de digitação, permitindo entrada manual da ideia para a história.*

### Geração de História
![História Gerada](screenshots/historia_gerada.png)
*Exemplo de uma história gerada pela IA, com opções de copiar e narrar.*

### Reconhecimento de Voz
![Reconhecimento de Voz](screenshots/reconhecimento_voz.png)
*Captura mostrando o reconhecimento de voz em ação.*

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento multiplataforma
- **Google Gemini API**: LLM (Large Language Model) para geração de histórias
- **Provider**: Gerenciamento de estado
- **speech_to_text**: Reconhecimento de voz
- **flutter_tts**: Síntese de voz
- **Material Design 3**: Sistema de design moderno

## 📥 Instalação

1. **Pré-requisitos**
   ```bash
   - Flutter (versão 3.7.0 ou superior)
   - Dart (versão compatível com o Flutter)
   - Android Studio / VS Code
   - Git
   ```

2. **Clone o repositório**
   ```bash
   git clone https://github.com/Gabriel-Xander/Historia_Viva.git
   cd Historia_Viva
   ```

3. **Instale as dependências**
   ```bash
   flutter pub get
   ```

4. **Configure a API Key**
   - Substitua a API Key do Google Gemini no arquivo `lib/services/gemini_service.dart`
   ```dart
   final String apiKey = 'SUA_API_KEY';
   ```

5. **Execute o aplicativo**
   ```bash
   flutter run
   ```

## 🤖 Uso do LLM (Google Gemini)

O aplicativo utiliza o Google Gemini, um modelo de linguagem avançado, para gerar histórias criativas. A integração é feita através da API REST do Gemini, com os seguintes parâmetros de configuração:

```dart
generationConfig: {
  'temperature': 0.7,    // Controle de criatividade
  'topK': 40,           // Diversidade de vocabulário
  'topP': 0.95,         // Coerência do texto
  'maxOutputTokens': 800 // Tamanho máximo da história
}
```

O prompt é estruturado para garantir histórias:
- Adequadas para todas as idades
- Com tom positivo e inspirador
- Contextualmente relevantes à ideia fornecida
- Em português brasileiro

## 🎯 Como Usar

1. Abra o aplicativo
2. Escolha como quer inserir sua ideia:
   - Toque no botão "Falar" e dite sua ideia
   - Ou toque no campo de texto e digite sua ideia
3. Aguarde a geração automática da história
4. Use os botões para:
   - Copiar o texto para compartilhar
   - Limpar e começar uma nova história

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir uma issue ou enviar um pull request.
