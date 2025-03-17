import 'package:flutter/material.dart';
import '../../config/theme.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: AppTheme.navBarUnselectedColor,
      backgroundColor: AppTheme.navBarBackgroundColor,
      elevation: 8,
      items: [
        _buildNavItem(0, Icons.currency_exchange, 'Döviz'),
        _buildNavItem(1, Icons.monetization_on, 'Altın'),
        _buildNavItem(2, Icons.account_balance_wallet, 'Portföy'),
        _buildNavItem(3, Icons.grid_view, 'Daha Fazla'),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
      int index, IconData icon, String label) {
    final isSelected = currentIndex == index;

    Widget iconWidget;
    if (isSelected) {
      // Seçili ise ikon bir daire içinde gösterilir
      iconWidget = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      );
    } else {
      iconWidget = Icon(icon);
    }

    return BottomNavigationBarItem(
      icon: iconWidget,
      label: label,
    );
  }
}

// Üst navbar için benzersiz bir daha oluşturulan bir tab yapısı
class CustomTopTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CustomTopTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Expanded(
            child: _buildTabItem(index),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          tabs[index],
          style: TextStyle(
            color: isSelected
                ? AppTheme.primaryColor
                : AppTheme.textSecondaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
