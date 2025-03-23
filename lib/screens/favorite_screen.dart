import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/product_card.dart';
import '../controllers/cart_controller.dart';
import '../controllers/favorite_controller.dart';
import 'product_view.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      appBar: const AppHeader(),
      body: CustomScrollView(
        slivers: [
          // Header section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'favorites'.tr,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      favoriteController.clearFavorites();
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: Text('clear_all'.tr),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Grid of favorite products
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: Obx(() {
              if (favoriteController.favoriteProducts.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('no_favorites'.tr),
                  ),
                );
              }
              return SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = favoriteController.favoriteProducts[index];
                    return ProductCard(
                      images: [product['imageUrl'] as String],
                      name: product['name'] as String,
                      price: double.parse(product['price'].toString()),
                      oldPrice: product['oldPrice'] != null
                          ? double.parse(product['oldPrice'].toString())
                          : null,
                      isNew: product['isNew'] as bool,
                      isDiscount: product['isDiscount'] as bool,
                      productId: product['id'] as String,
                      onTap: () {
                        Get.to(
                          () => ProductView(
                            productId: product['id'].toString(),
                          ),
                          transition: Transition.fadeIn,
                        );
                      },
                    );
                  },
                  childCount: favoriteController.favoriteProducts.length,
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}