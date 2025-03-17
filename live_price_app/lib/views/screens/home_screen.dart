import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_bottom_nav.dart';
import 'currency_screen.dart';
import 'gold_screen.dart';
import 'portfolio_screen.dart';
import 'more_screen.dart';
import '../../config/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Ekran başlıkları
  final List<String> _titles = [
    'Döviz Kurları',
    'Altın Fiyatları',
    'Portföyüm',
    'Daha Fazla',
  ];

  // Ekranlar
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      CurrencyScreen(onAddFavoritePressed: _showAddFavoriteDialog),
      GoldScreen(onAddFavoritePressed: _showAddFavoriteDialog),
      const PortfolioScreen(),
      const MoreScreen(),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showAddFavoriteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Favorilere Ekle'),
        content: const Text('Bu özellik henüz aktif değil.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _onCategorySelected(int index) {
    Navigator.pop(context); // Drawer'ı kapat
    setState(() {
      if (index <= 1) {
        // 0: Döviz, 1: Altın
        _currentIndex = index;
      } else {
        _currentIndex = 3; // Diğer kategoriler için Daha Fazla sekmesine git
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      drawer: CustomDrawer(
        onCategorySelected: _onCategorySelected,
        selectedIndex:
            _currentIndex <= 1 ? _currentIndex : (_currentIndex == 3 ? 2 : -1),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
