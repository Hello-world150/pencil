import 'package:flutter/material.dart';
import 'package:pencil/pages/add_thought_page.dart';
import 'package:pencil/pages/home_page.dart';
import '../services/thought_service.dart';

/// 主屏幕 - 管理底部导航和页面切换
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final ThoughtService _thoughtService;
  late final GlobalKey<HomePageState> _homePageKey;

  @override
  void initState() {
    super.initState();
    _thoughtService = ThoughtService();
    _homePageKey = GlobalKey<HomePageState>();
  }

  /// 获取页面列表
  List<Widget> get _pages => [
    AddThoughtPage(
      thoughtService: _thoughtService,
      onThoughtAdded: _refreshHomePage,
    ),
    HomePage(
      key: _homePageKey,
      thoughtService: _thoughtService,
    ),
  ];

  /// 想法添加后刷新主页
  void _refreshHomePage() {
    _homePageKey.currentState?.refreshData();
  }

  /// 处理底部导航栏点击
  void _onNavigationTapped(int index) {
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// 构建底部导航栏
  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onNavigationTapped,
      destinations: _buildNavigationDestinations(),
    );
  }

  /// 构建导航目标列表
  List<NavigationDestination> _buildNavigationDestinations() {
    return const [
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
    ];
  }
}
