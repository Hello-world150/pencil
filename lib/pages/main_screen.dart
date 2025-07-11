import 'package:flutter/material.dart';
import 'package:pencil/pages/add_thought_page.dart';
import 'package:pencil/pages/home_page.dart';
import '../services/thought_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final ThoughtService _thoughtService = ThoughtService();
  final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();

  @override
  void initState() {
    super.initState();
  }

  List<Widget> get _pages => [
    AddThoughtPage(
      thoughtService: _thoughtService,
      onThoughtAdded: _onThoughtAdded,
    ),
    HomePage(
      key: _homePageKey,
      thoughtService: _thoughtService,
    ),
  ];

  void _onThoughtAdded() {
    // Refresh the HomePage when a thought is added
    _homePageKey.currentState?.refreshData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.add_outlined),
            selectedIcon: Icon(Icons.add),
            label: '新增',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb),
            label: '想法',
          ),
        ],
      ),
    );
  }
}
