import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/hive_service.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'shared/widgets/main_scaffold.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'features/language/presentation/screens/language_selection_screen.dart';
import 'features/documents/presentation/screens/documents_screen.dart';
import 'features/translator/presentation/screens/translation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive database
  await HiveService.init();

  runApp(const ProviderScope(child: MagTappApp()));
}

class MagTappApp extends ConsumerWidget {
  const MagTappApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsState.themeMode,
      home: const MainScaffold(),
      routes: {
        '/language-selection': (context) => const LanguageSelectionScreen(),
        '/documents': (context) => const DocumentsScreen(),
        '/translation': (context) => const TranslationScreen(),
        '/smart-dictionary': (context) => const Scaffold(body: Center(child: Text('Smart Dictionary - Coming Soon'))),
        '/books': (context) => const Scaffold(body: Center(child: Text('Books - Coming Soon'))),
        '/quiz': (context) => const Scaffold(body: Center(child: Text('Quiz - Coming Soon'))),
        '/games': (context) => const Scaffold(body: Center(child: Text('Games - Coming Soon'))),
        '/notes': (context) => const Scaffold(body: Center(child: Text('Notes - Coming Soon'))),
        '/course': (context) => const Scaffold(body: Center(child: Text('Course - Coming Soon'))),
      },
    );
  }
}
