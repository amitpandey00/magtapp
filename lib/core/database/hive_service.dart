import 'package:hive_flutter/hive_flutter.dart';
import '../models/browser_tab.dart';
import '../models/document.dart';
import '../models/summary.dart';
import '../models/translation.dart';

/// Hive Database Service
class HiveService {
  // Box names
  static const String tabsBox = 'tabs';
  static const String documentsBox = 'documents';
  static const String summariesBox = 'summaries';
  static const String translationsBox = 'translations';
  static const String settingsBox = 'settings';

  /// Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(BrowserTabAdapter());
    Hive.registerAdapter(DocumentAdapter());
    Hive.registerAdapter(SummaryAdapter());
    Hive.registerAdapter(TranslationAdapter());

    // Open boxes
    await Hive.openBox<BrowserTab>(tabsBox);
    await Hive.openBox<Document>(documentsBox);
    await Hive.openBox<Summary>(summariesBox);
    await Hive.openBox<Translation>(translationsBox);
    await Hive.openBox(settingsBox);
  }

  /// Get tabs box
  static Box<BrowserTab> getTabsBox() {
    return Hive.box<BrowserTab>(tabsBox);
  }

  /// Get documents box
  static Box<Document> getDocumentsBox() {
    return Hive.box<Document>(documentsBox);
  }

  /// Get summaries box
  static Box<Summary> getSummariesBox() {
    return Hive.box<Summary>(summariesBox);
  }

  /// Get translations box
  static Box<Translation> getTranslationsBox() {
    return Hive.box<Translation>(translationsBox);
  }

  /// Get settings box
  static Box getSettingsBox() {
    return Hive.box(settingsBox);
  }

  /// Close all boxes
  static Future<void> closeAll() async {
    await Hive.close();
  }

  /// Clear all data
  static Future<void> clearAll() async {
    await getTabsBox().clear();
    await getDocumentsBox().clear();
    await getSummariesBox().clear();
    await getTranslationsBox().clear();
    await getSettingsBox().clear();
  }
}

