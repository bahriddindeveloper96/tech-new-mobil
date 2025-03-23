import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../screens/cart.dart';
import '../screens/favorite_screen.dart';
import '../screens/catalog_menu.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../controllers/cart_controller.dart';
import '../controllers/favorite_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final favoriteController = Get.find<FavoriteController>();
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface.withOpacity(0.8),
            theme.colorScheme.surface,
          ],
        ),
        boxShadow: AppTheme.customShadow,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'nav_home'.tr,
                isActive: Get.currentRoute == '/',
                onTap: () {
                  if (Get.currentRoute != '/') {
                    Get.offAll(() => const HomeScreen());
                  }
                },
              ),
              _buildNavItem(
                context,
                icon: Icons.category_outlined,
                activeIcon: Icons.category_rounded,
                label: 'nav_categories'.tr,
                isActive: Get.currentRoute == '/catalog',
                onTap: () {
                  Get.to(
                    () => const CatalogMenu(),
                    transition: Transition.fadeIn,
                  );
                },
              ),
              _buildNavItem(
                context,
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart_rounded,
                label: 'nav_cart'.tr,
                isActive: Get.currentRoute == '/cart',
                badge: cartController.itemCount,
                onTap: () {
                  Get.to(
                    () => CartScreen(),
                    transition: Transition.fadeIn,
                  );
                },
              ),
              _buildNavItem(
                context,
                icon: Icons.favorite_outline_rounded,
                activeIcon: Icons.favorite_rounded,
                label: 'nav_favorites'.tr,
                isActive: Get.currentRoute == '/favorites',
                badge: favoriteController.favoriteProducts.length,
                onTap: () {
                  Get.to(
                    () => const FavoriteScreen(),
                    transition: Transition.fadeIn,
                  );
                },
              ),              
              _buildNavItem(
                context,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'nav_profile'.tr,
                isActive: Get.currentRoute == '/profile',
                onTap: () {
                  Get.to(
                    () => const ProfileScreen(),
                    transition: Transition.fadeIn,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    int? badge,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final color = isActive ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isActive ? activeIcon : icon,
                    key: ValueKey(isActive),
                    color: color,
                    size: 26,
                  ),
                ),
                if (badge != null && badge > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          badge.toString(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onError,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}