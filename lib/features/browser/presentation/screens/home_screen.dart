import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../summarizer/presentation/providers/summarization_provider.dart';
import '../../../translator/presentation/providers/translation_provider.dart';
import '../../../../core/models/language.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MagTapp'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.summarize), text: 'Summarize'),
            Tab(icon: Icon(Icons.translate), text: 'Translate'),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [_buildSummarizeTab(), _buildTranslateTab()]),
    );
  }

  Widget _buildSummarizeTab() {
    final summarizationState = ref.watch(summarizationProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _textController,
            maxLines: 8,
            decoration: const InputDecoration(hintText: 'Enter or paste text to summarize...', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: summarizationState.isLoading
                ? null
                : () {
                    if (_textController.text.trim().isNotEmpty) {
                      ref.read(summarizationProvider.notifier).generateSummary(_textController.text.trim());
                    }
                  },
            icon: const Icon(Icons.auto_awesome),
            label: summarizationState.isLoading ? const Text('Generating...') : const Text('Generate Summary'),
          ),
          if (summarizationState.isLoading) ...[const SizedBox(height: 24), const Center(child: CircularProgressIndicator())],
          if (summarizationState.error != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(summarizationState.error!, style: TextStyle(color: Colors.red.shade900)),
              ),
            ),
          ],
          if (summarizationState.summary != null) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.summarize, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text('Summary', style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    const Divider(),
                    Text(summarizationState.summary!.summaryText),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Original: ${summarizationState.summary!.originalWordCount} words', style: Theme.of(context).textTheme.bodySmall),
                        Text('Summary: ${summarizationState.summary!.summaryWordCount} words', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Compression: ${summarizationState.summary!.compressionPercentage.toStringAsFixed(1)}%', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTranslateTab() {
    final translationState = ref.watch(translationProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLanguageSelector(translationState),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            maxLines: 6,
            decoration: const InputDecoration(hintText: 'Enter text to translate...', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: translationState.isLoading
                ? null
                : () {
                    if (_textController.text.trim().isNotEmpty) {
                      ref.read(translationProvider.notifier).translateText(_textController.text.trim());
                    }
                  },
            icon: const Icon(Icons.translate),
            label: translationState.isLoading ? const Text('Translating...') : const Text('Translate'),
          ),
          if (translationState.isLoading) ...[const SizedBox(height: 24), const Center(child: CircularProgressIndicator())],
          if (translationState.error != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(translationState.error!, style: TextStyle(color: Colors.red.shade900)),
              ),
            ),
          ],
          if (translationState.translation != null) ...[
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.translate, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('Translation', style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    const Divider(),
                    Text(translationState.translation!.translatedText, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(TranslationState state) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<Language>(
            value: state.sourceLanguage,
            decoration: const InputDecoration(labelText: 'From', border: OutlineInputBorder()),
            items: state.supportedLanguages.map((lang) => DropdownMenuItem(value: lang, child: Text(lang.name))).toList(),
            onChanged: (lang) {
              if (lang != null) ref.read(translationProvider.notifier).setSourceLanguage(lang);
            },
          ),
        ),
        IconButton(icon: const Icon(Icons.swap_horiz), onPressed: () => ref.read(translationProvider.notifier).swapLanguages()),
        Expanded(
          child: DropdownButtonFormField<Language>(
            value: state.targetLanguage,
            decoration: const InputDecoration(labelText: 'To', border: OutlineInputBorder()),
            items: state.supportedLanguages.map((lang) => DropdownMenuItem(value: lang, child: Text(lang.name))).toList(),
            onChanged: (lang) {
              if (lang != null) ref.read(translationProvider.notifier).setTargetLanguage(lang);
            },
          ),
        ),
      ],
    );
  }
}
