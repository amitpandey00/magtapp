import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/google_translation_service.dart';

class TranslationScreen extends ConsumerStatefulWidget {
  const TranslationScreen({super.key});

  @override
  ConsumerState<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends ConsumerState<TranslationScreen> {
  final TextEditingController _sourceController = TextEditingController();
  final GoogleTranslationService _translationService = GoogleTranslationService();

  String _translatedText = '';
  String _sourceLanguage = 'en';
  String _targetLanguage = 'hi';
  bool _isTranslating = false;

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'Hindi'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'zh', 'name': 'Chinese'},
    {'code': 'ja', 'name': 'Japanese'},
    {'code': 'ar', 'name': 'Arabic'},
    {'code': 'bn', 'name': 'Bengali'},
    {'code': 'ta', 'name': 'Tamil'},
    {'code': 'te', 'name': 'Telugu'},
    {'code': 'mr', 'name': 'Marathi'},
  ];

  @override
  void dispose() {
    _sourceController.dispose();
    super.dispose();
  }

  Future<void> _translate() async {
    if (_sourceController.text.isEmpty) return;

    setState(() => _isTranslating = true);

    try {
      final translated = await _translationService.translateText(text: _sourceController.text, targetLanguage: _targetLanguage, sourceLanguage: _sourceLanguage);

      setState(() {
        _translatedText = translated;
        _isTranslating = false;
      });
    } catch (e) {
      setState(() => _isTranslating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Translation failed: $e')));
      }
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
        title: const Text('Translation', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.history), onPressed: () {})],
      ),
      body: Column(
        children: [
          _buildLanguageSelector(),
          Expanded(
            child: SingleChildScrollView(child: Column(children: [_buildSourceTextArea(), _buildTranslateButton(), _buildTranslatedTextArea()])),
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
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildLanguageDropdown(_sourceLanguage, (value) => setState(() => _sourceLanguage = value!))),
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.blue),
            onPressed: _swapLanguages,
          ),
          Expanded(child: _buildLanguageDropdown(_targetLanguage, (value) => setState(() => _targetLanguage = value!))),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(String value, void Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items: _languages.map((lang) => DropdownMenuItem(value: lang['code'], child: Text(lang['name']!))).toList(),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)],
      ),
      child: TextField(
        controller: _sourceController,
        maxLines: 8,
        decoration: const InputDecoration(hintText: 'Enter text to translate...', border: InputBorder.none),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isTranslating
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text(
                  'Translate',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
        ),
      ),
    );
  }

  Widget _buildTranslatedTextArea() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Translation',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              if (_translatedText.isNotEmpty)
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.copy, size: 20), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.volume_up, size: 20), onPressed: () {}),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(_translatedText.isEmpty ? 'Translation will appear here...' : _translatedText, style: TextStyle(fontSize: 16, color: _translatedText.isEmpty ? Colors.grey : Colors.black87)),
        ],
      ),
    );
  }
}
