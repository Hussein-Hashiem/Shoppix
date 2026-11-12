import 'package:flutter/material.dart';
import 'package:mobile/core/utils/constants/colors.dart';
import 'package:mobile/core/utils/constants/style.dart';
import 'package:mobile/core/utils/responsive/responsive.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border, width: Responsive.w(1)),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.button,
        unselectedItemColor: AppColors.outlinedButtonText,
        selectedLabelStyle: AppTextStyles.bodyMedium,
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_outlined, size: 24),
            activeIcon: Icon(Icons.shop, size: 24),
            label: 'SHOP',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined, size: 24),
            activeIcon: Icon(Icons.shopping_cart, size: 24),
            label: 'CART',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined, size: 24),
            activeIcon: Icon(Icons.receipt, size: 24),
            label: 'ORDERS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 24),
            activeIcon: Icon(Icons.person, size: 24),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }
}
