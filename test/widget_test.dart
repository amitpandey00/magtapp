import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:magtapp/main.dart';
import 'package:magtapp/core/models/browser_tab.dart';
import 'package:magtapp/core/models/document.dart';
import 'package:magtapp/core/models/summary.dart';
import 'package:magtapp/core/models/translation.dart';

void main() {
  setUpAll(() async {
    Hive.init('./test/hive_test');
    Hive.registerAdapter(BrowserTabAdapter());
    Hive.registerAdapter(DocumentAdapter());
    Hive.registerAdapter(SummaryAdapter());
    Hive.registerAdapter(TranslationAdapter());

    await Hive.openBox<BrowserTab>('tabs');
    await Hive.openBox<Document>('documents');
    await Hive.openBox<Summary>('summaries');
    await Hive.openBox<Translation>('translations');
    await Hive.openBox('settings');
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MagTappApp()));
    await tester.pumpAndSettle();

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Files'), findsOneWidget);
    expect(find.text('Tabs'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches screens', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MagTappApp()));
    await tester.pumpAndSettle();

    expect(find.text('MagTapp'), findsOneWidget);

    await tester.tap(find.text('Files'));
    await tester.pumpAndSettle();
    expect(find.text('File Manager'), findsOneWidget);

    await tester.tap(find.text('Tabs'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Tabs'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsAtLeastNWidgets(1));
  });

  testWidgets('Home screen has summarize and translate tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MagTappApp()));
    await tester.pumpAndSettle();

    expect(find.text('Summarize'), findsOneWidget);
    expect(find.text('Translate'), findsOneWidget);
  });

  testWidgets('Settings screen displays theme options', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MagTappApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Theme Mode'), findsOneWidget);
    expect(find.text('Storage'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });
}
