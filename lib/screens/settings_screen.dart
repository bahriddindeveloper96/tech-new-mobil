import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../controllers/translation_controller.dart';
import '../widgets/app_header.dart';
import './personal_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _buildSettingItem({
    required String title,
    required String description,
    required Widget trailing,
    bool showBorder = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: showBorder
            ? Border(
                bottom: BorderSide(
                  color: Get.isDarkMode
                      ? Colors.grey[800]!
                      : Colors.grey[200]!,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Get.isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          trailing,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final translationController = Get.find<TranslationController>();

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('settings'.tr),
          centerTitle: true,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Account Settings
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "account".tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Profile
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonalScreen(),
                        ),
                      );
                    },
                    child: _buildSettingItem(
                      title: "profile".tr,
                      description: "profile_edit".tr,
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Get.isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ),
                  // Language
                  _buildSettingItem(
                    title: "language".tr,
                    description: "language_change".tr,
                    trailing: PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() => Text(
                                  translationController.getCurrentLanguageName(),
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.grey[800],
                                  ),
                                )),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                      itemBuilder: (context) => translationController.languages
                          .map(
                            (language) => PopupMenuItem<String>(
                              value: language['code'],
                              child: Text(language['name']!),
                            ),
                          )
                          .toList(),
                      onSelected: (String langCode) {
                        translationController.changeLocale(langCode);
                      },
                    ),
                  ),
                  // Theme
                  _buildSettingItem(
                    title: "theme".tr,
                    description: "theme_mode".tr,
                    trailing: Obx(
                      () => Switch(
                        value: themeController.isDarkMode.value,
                        onChanged: (value) => themeController.toggleTheme(),
                      ),
                    ),
                  ),
                  // Currency
                  _buildSettingItem(
                    title: "currency".tr,
                    description: "currency_display".tr,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Colors.grey[800]
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "UZS",
                            style: TextStyle(
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.grey[800],
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    showBorder: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Notifications
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "notifications".tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Email notifications
                  _buildSettingItem(
                    title: "email_notifications".tr,
                    description: "email_notifications_desc".tr,
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                  // SMS notifications
                  _buildSettingItem(
                    title: "sms_notifications".tr,
                    description: "sms_notifications_desc".tr,
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                    ),
                    showBorder: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
