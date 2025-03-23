import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class TranslationController extends GetxController {
  final RxString currentLocale = 'uz'.obs;
  final List<Map<String, String>> languages = [
    {'code': 'uz', 'name': "O'zbekcha"},
    {'code': 'ru', 'name': "Русский"},
    {'code': 'en', 'name': "English"},
  ];

  @override
  void onInit() async {
    super.onInit();
    try {
      await loadSavedLocale();
    } catch (e) {
      debugPrint('Error loading locale: $e');
      currentLocale.value = 'uz';
      await Get.updateLocale(const Locale('uz', 'UZ'));
    }
  }

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale') ?? 'uz';
    currentLocale.value = savedLocale;
    await Get.updateLocale(Locale(savedLocale, savedLocale.toUpperCase()));
  }

  Future<void> changeLocale(String langCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('locale', langCode);
      currentLocale.value = langCode;
      await Get.updateLocale(Locale(langCode, langCode.toUpperCase()));
      update(); 
    } catch (e) {
      debugPrint('Error changing locale: $e');
    }
  }

  String getCurrentLanguageName() {
    return languages.firstWhere(
      (lang) => lang['code'] == currentLocale.value,
      orElse: () => languages[0],
    )['name']!;
  }
}
