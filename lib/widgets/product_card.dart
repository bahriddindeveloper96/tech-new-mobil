import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';
import '../screens/product_view.dart';
import '../screens/product_view_modal.dart';
import '../controllers/favorite_controller.dart';

extension FormatMoney on String {
  String formatMoney() {
    final buffer = StringBuffer();
    final chars = split('').reversed.toList();
    for (var i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(chars[i]);
    }
    return '${buffer.toString().split('').reversed.join('')} so\'m';
  }
}

class ProductCard extends StatelessWidget {
  final List<String> images;
  final String name;
  final double price;
  final double? oldPrice;
  final bool isNew;
  final bool isDiscount;
  final VoidCallback? onTap;
  final String productId;

  const ProductCard({
    Key? key,
    required this.images,
    required this.name,
    required this.price,
    this.oldPrice,
    this.isNew = false,
    this.isDiscount = false,
    this.onTap,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap ?? () {
        Get.to(() => ProductView(
              productId: productId,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
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
            // Image Section
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Product Image Slider
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: PageView.builder(
                        itemCount: images.length,
                        itemBuilder: (context, index) => CachedNetworkImage(
                          imageUrl: images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => _buildShimmerEffect(),
                          errorWidget: (context, url, error) => Container(
                            color: theme.colorScheme.surfaceVariant,
                            child: Icon(
                              Icons.error_outline,
                              color: theme.colorScheme.error,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Badges Container
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Discount Badge
                        if (isDiscount && oldPrice != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF0000),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '-${(((oldPrice! - price) / oldPrice!) * 100).round()}%',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        // New Badge
                        if (isNew)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Yangi',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (favoriteController.isFavorite(productId)) {
                              favoriteController.removeFromFavorites(productId);
                            } else {
                              favoriteController.addToFavorites({
                                'id': productId,
                                'name': name,
                                'price': price,
                                'oldPrice': oldPrice,
                                'imageUrl': images.first,
                                'isNew': isNew,
                                'isDiscount': isDiscount,
                              });
                            }
                          },
                          customBorder: const CircleBorder(),
                          child: Obx(() {
                            final isFav = favoriteController.isFavorite(productId);
                            return Icon(
                              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              size: 18,
                              color: isFav ? const Color(0xFFFF0000) : Colors.grey,
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Reviews
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.5',
                              style: theme.textTheme.labelSmall,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(12)',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price Section
                        if (oldPrice != null) ...[
                          Text(
                            oldPrice?.toStringAsFixed(0).formatMoney() ?? '',
                            style: TextStyle(
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  price.toStringAsFixed(0).formatMoney(),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                // Installment
                                Text(
                                  '${(price / 12).ceil().toStringAsFixed(0).formatMoney()} x 12 oy',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.add_shopping_cart_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}