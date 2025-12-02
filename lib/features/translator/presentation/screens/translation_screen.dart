import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:magtapp/features/translator/data/services/gemini_translation_service.dart';
import 'package:magtapp/core/models/language.dart';
import 'package:magtapp/core/models/translation.dart';

class TranslationScreen extends ConsumerStatefulWidget {
  const TranslationScreen({super.key});

  @override
  ConsumerState<TranslationScreen> createState() =>
      _TranslationScreenState();
}

class _TranslationScreenState extends ConsumerState<TranslationScreen> {
  final TextEditingController _sourceController = TextEditingController();
  final GeminiTranslationService _translationService =
  GeminiTranslationService();

  late final List<Language> _languages;
  late Language _sourceLanguage;
  late Language _targetLanguage;

  String _translatedText = '';
  bool _isTranslating = false;

  @override
  void initState() {
    super.initState();

    _languages = _translationService.getSupportedLanguages();

    // Default source/target
    _sourceLanguage = _languages.firstWhere(
          (l) => l.code == 'en',
      orElse: () => _languages.first,
    );

    _targetLanguage = _languages.firstWhere(
          (l) => l.code == 'hi',
      orElse: () => _languages.length > 1 ? _languages[1] : _languages.first,
    );
  }

  @override
  void dispose() {
    _sourceController.dispose();
    super.dispose();
  }

  Future<void> _translate() async {
    final text = _sourceController.text;
    if (text.trim().isEmpty) return;

    setState(() => _isTranslating = true);

    try {
      final Translation translation = await _translationService.translateText(
        text,
        _sourceLanguage,
        _targetLanguage,
      );

      if (!mounted) return;

      setState(() {
        _translatedText = translation.translatedText;
        _isTranslating = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isTranslating = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Translation failed: $e'),
        ),
      );
    }
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;

      _sourceController.text = _translatedText;
      _translatedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Translation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: navigate to history screen using Hive translations
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildLanguageSelector(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSourceTextArea(),
                  _buildTranslateButton(),
                  _buildTranslatedTextArea(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildLanguageDropdown(
              value: _sourceLanguage,
              onChanged: (value) {
                if (value == null) return;
                setState(() => _sourceLanguage = value);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.blue),
            onPressed: _swapLanguages,
          ),
          Expanded(
            child: _buildLanguageDropdown(
              value: _targetLanguage,
              onChanged: (value) {
                if (value == null) return;
                setState(() => _targetLanguage = value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown({
    required Language value,
    required ValueChanged<Language?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Language>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items: _languages
              .map(
                (lang) => DropdownMenuItem<Language>(
              value: lang,
              child: Text(lang.name),
            ),
          )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSourceTextArea() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: _sourceController,
        maxLines: 8,
        decoration: const InputDecoration(
          hintText: 'Enter text to translate...',
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildTranslateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isTranslating ? null : _translate,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isTranslating
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : const Text(
            'Translate',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTranslatedTextArea() {
    final hasText = _translatedText.isNotEmpty;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Translation',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              if (hasText)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () {
                        if (!hasText) return;
                        Clipboard.setData(
                          ClipboardData(text: _translatedText),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up, size: 20),
                      onPressed: () {
                        // TODO: TTS integration
                      },
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hasText ? _translatedText : 'Translation will appear here...',
            style: TextStyle(
              fontSize: 16,
              color: hasText ? Colors.black87 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
