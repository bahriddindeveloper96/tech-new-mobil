import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../controllers/theme_controller.dart';
import '../screens/order_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/personal_screen.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    bool showDivider = true,
    Color? iconColor,
    Widget? trailing,
  }) {
    final isDarkMode = Get.isDarkMode;
    final backgroundColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final iconBgColor = isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF5F7FA);
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2D3142);
    final subtitleColor = isDarkMode ? Colors.grey[400] : const Color(0xFF9094A0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.3)
                : Colors.grey[300]!.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: iconColor ?? textColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                trailing ?? Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: subtitleColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.isDarkMode;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8FAFD);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2D3142);
    final subtitleColor = isDarkMode ? Colors.grey[400] : const Color(0xFF9094A0);
    final iconBgColor = isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppHeader(
          title: 'my_profile'.tr,
          showBackButton: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.3)
                        : Colors.grey[300]!.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black.withOpacity(0.3)
                              : Colors.grey[300]!.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 35,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Foydalanuvchi",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "+998 90 123 45 67",
                          style: TextStyle(
                            fontSize: 15,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'profile'.tr,
              subtitle: 'profile_edit'.tr,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.shopping_bag_outlined,
              title: 'orders'.tr,
              subtitle: 'order_history'.tr,
              onTap: () => Get.to(() => const OrderScreen()),
            ),
            _buildMenuItem(
              icon: Icons.favorite_outline,
              title: 'favorites'.tr,
              subtitle: 'saved_products'.tr,
              onTap: () => Get.to(() => const FavoriteScreen()),
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'help_support'.tr,
              subtitle: 'contact_support'.tr,
              onTap: () {},
            ),        
            _buildMenuItem(
              icon: Icons.settings_outlined,
              title: 'settings'.tr,
              subtitle: 'language_change'.tr,
              onTap: () => Get.to(() => const SettingsScreen()),
            ),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'logout'.tr,
              onTap: () {},
              iconColor: Theme.of(context).colorScheme.error,
              showDivider: false,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
