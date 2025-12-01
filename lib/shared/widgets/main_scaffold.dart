import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/presentation/screens/new_home_screen.dart';
import '../../features/browser/presentation/screens/tab_manager_screen.dart';
import '../../features/browser/presentation/screens/new_tab_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/browser/presentation/providers/browser_state.dart';
import '../../core/models/browser_tab.dart';
import '../../features/browser/presentation/screens/browser_screen.dart';

/// Main Scaffold with Bottom Navigation
class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [NewHomeScreen(), TabManagerScreen(), NewTabScreen(), SettingsScreen()];

  void _createNewTab() {
    final newTab = BrowserTab(id: DateTime.now().millisecondsSinceEpoch.toString(), url: 'https://www.google.com', title: 'New Tab', createdAt: DateTime.now(), lastAccessedAt: DateTime.now(), isActive: true);

    ref.read(browserProvider.notifier).addTab(newTab);

    Navigator.push(context, MaterialPageRoute(builder: (context) => const BrowserScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.tab), label: 'TABS'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'NEW TAB'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'SETTINGS'),
        ],
      ),
    );
  }
}
