import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../../../../core/database/hive_service.dart';

/// Settings Screen - Browser configuration and preferences
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final isDarkMode = settingsState.themeMode == ThemeMode.dark;

    return Scaffold(
      body: ListView(
        children: [
          // Contact Us
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: const Text('Contact Us'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact: support@magtapp.com')));
            },
          ),
          const Divider(height: 1),

          // Set as Default Browser
          ListTile(
            leading: const Icon(Icons.web),
            title: const Text('Set as Default Browser'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening system settings...')));
            },
          ),
          const Divider(height: 1),

          // Standard Tab
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Standard Tab'),
            subtitle: const Text('https://www.google.com'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showUrlDialog(context, 'Standard Tab', 'https://www.google.com');
            },
          ),
          const Divider(height: 1),

          // Private Tab
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Private Tab'),
            subtitle: const Text('https://www.google.com'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showUrlDialog(context, 'Private Tab', 'https://www.google.com');
            },
          ),
          const Divider(height: 1),

          // Search Engine
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search Engine'),
            subtitle: const Text('Google'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showSearchEngineDialog(context);
            },
          ),
          const Divider(height: 1),

          // Change Language
          ListTile(
            leading: const Icon(Icons.translate),
            title: const Text('Change Language'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/language-selection');
            },
          ),
          const Divider(height: 1),

          // Clear Browsing History
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Clear Browsing History'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final confirmed = await _showConfirmDialog(context, 'Clear Browsing History', 'This will delete all browsing history. This action cannot be undone.');
              if (confirmed == true && context.mounted) {
                await HiveService.clearAll();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Browsing history cleared')));
                }
              }
            },
          ),
          const Divider(height: 1),

          // Web browser Dark Mode
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Web browser Dark Mode'),
            value: isDarkMode,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleTheme();
            },
          ),
          const Divider(height: 1),

          // Copy to show meaning
          SwitchListTile(
            secondary: const Icon(Icons.content_copy),
            title: const Text('Copy to show meaning'),
            value: false,
            onChanged: (value) {
              // TODO: Implement copy to show meaning
            },
          ),
          const Divider(height: 1),

          // Continue Reading
          SwitchListTile(
            secondary: const Icon(Icons.auto_stories),
            title: const Text('Continue Reading'),
            value: false,
            onChanged: (value) {
              // TODO: Implement continue reading
            },
          ),
          const Divider(height: 1),

          // Block all cookies
          SwitchListTile(
            secondary: const Icon(Icons.cookie),
            title: const Text('Block all cookies'),
            value: false,
            onChanged: (value) {
              // TODO: Implement block cookies
            },
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  void _showUrlDialog(BuildContext context, String title, String currentUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          decoration: const InputDecoration(labelText: 'URL', hintText: 'https://www.example.com'),
          controller: TextEditingController(text: currentUrl),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('URL updated')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSearchEngineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Search Engine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Google'),
              value: 'google',
              groupValue: 'google',
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Bing'),
              value: 'bing',
              groupValue: 'google',
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('DuckDuckGo'),
              value: 'duckduckgo',
              groupValue: 'google',
              onChanged: (value) {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
