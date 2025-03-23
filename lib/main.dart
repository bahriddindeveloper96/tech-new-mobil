import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/home_screen.dart';
import 'controllers/theme_controller.dart';
import 'controllers/translation_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/favorite_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/product_controller.dart';
import 'services/api_client.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';
import 'translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  
  // Initialize API services
  Get.put(ApiClient());
  Get.put(ApiService());
  
  // Initialize controllers
  Get.put(ThemeController());
  Get.put(TranslationController());
  Get.put(CartController());
  Get.put(FavoriteController());
  Get.put(CategoryController());
  Get.put(ProductController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TechMarket',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: const Locale('uz', 'UZ'),
      fallbackLocale: const Locale('uz', 'UZ'),
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uz', 'UZ'),
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
      home: const HomeScreen(),
    );
  }
}
