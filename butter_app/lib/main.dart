import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/guides_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/account_screen.dart';
import 'widgets/custom_tab_bar.dart';
import 'widgets/fake_status_bar.dart';
import 'utils/responsive.dart';

void main() {
  runApp(const ButterApp());
}

class ButterApp extends StatelessWidget {
  const ButterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Butter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 430),
          child: const MainScreen(),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  /// Notifier global pour changer d'onglet depuis n'importe où (ex: ResultsScreen)
  static final ValueNotifier<int?> tabSwitchNotifier = ValueNotifier(null);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    MainScreen.tabSwitchNotifier.addListener(_onTabSwitch);
  }

  @override
  void dispose() {
    MainScreen.tabSwitchNotifier.removeListener(_onTabSwitch);
    super.dispose();
  }

  void _onTabSwitch() {
    final newIndex = MainScreen.tabSwitchNotifier.value;
    if (newIndex != null) {
      setState(() => _currentIndex = newIndex);
      MainScreen.tabSwitchNotifier.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              _buildTabNavigator(0, const HomeScreen()),
              _buildTabNavigator(1, const GuidesScreen()),
              _buildTabNavigator(2, const FavoritesScreen()),
              _buildTabNavigator(3, const AccountScreen()),
            ],
          ),
          // Fausse status bar iPhone en haut
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FakeStatusBar(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomTabBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == _currentIndex) {
                  _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
                } else {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigator(int index, Widget rootScreen) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => rootScreen,
        );
      },
    );
  }
}
