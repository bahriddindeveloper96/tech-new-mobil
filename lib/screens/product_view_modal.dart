import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/cart_controller.dart';

class ProductViewModal extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String name;
  final double price;
  final double? oldPrice;
  final bool isNew;
  final bool isDiscount;
  final String description;
  final List<String> images;
  final Map<String, List<String>> specifications;

  const ProductViewModal({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.oldPrice,
    this.isNew = false,
    this.isDiscount = false,
    required this.description,
    required this.images,
    required this.specifications,
  }) : super(key: key);

  static Future<void> showModal({
    required BuildContext context,
    required String id,
    required String imageUrl,
    required String name,
    required double price,
    double? oldPrice,
    bool isNew = false,
    bool isDiscount = false,
    required String description,
    required List<String> images,
    required Map<String, List<String>> specifications,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductViewModal(
        id: id,
        imageUrl: imageUrl,
        name: name,
        price: price,
        oldPrice: oldPrice,
        isNew: isNew,
        isDiscount: isDiscount,
        description: description,
        images: images,
        specifications: specifications,
      ),
    );
  }

  @override
  _ProductViewModalState createState() => _ProductViewModalState();
}

class _ProductViewModalState extends State<ProductViewModal> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String _formatPrice(double price) {
    return price.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favoriteController = Get.find<FavoriteController>();
    final cartController = Get.find<CartController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final modalHeight = screenHeight * 0.85;

    return Container(
      height: modalHeight,
      constraints: BoxConstraints(
        maxHeight: screenHeight - MediaQuery.of(context).padding.top,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 8, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Content
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Images
                SliverToBoxAdapter(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        // Image gallery
                        PageView.builder(
                          controller: _pageController,
                          itemCount: widget.images.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Hero(
                              tag: 'product_${widget.id}_$index',
                              child: CachedNetworkImage(
                                imageUrl: widget.images[index],
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[100],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[100],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.grey[400],
                                        size: 48,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Rasm yuklanmadi',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        // Close and favorite buttons
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            children: [
                              Container(
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
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Get.back(),
                                  color: Colors.black87,
                                  iconSize: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
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
                                child: Obx(() {
                                  final isFavorite = favoriteController.isFavorite(widget.id);
                                  return IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : Colors.black87,
                                    ),
                                    onPressed: () {
                                      if (isFavorite) {
                                        favoriteController.removeFromFavorites(widget.id);
                                      } else {
                                        favoriteController.addToFavorites({
                                          'id': widget.id,
                                          'name': widget.name,
                                          'price': widget.price,
                                          'oldPrice': widget.oldPrice,
                                          'imageUrl': widget.imageUrl,
                                          'isNew': widget.isNew,
                                          'isDiscount': widget.isDiscount,
                                        });
                                      }
                                    },
                                    iconSize: 20,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        // Page indicator
                        if (widget.images.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                widget.images.length,
                                (index) => Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentPage == index
                                        ? theme.primaryColor
                                        : Colors.grey[300],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // Discount badge
                        if (widget.isDiscount && widget.oldPrice != null)
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '-${(((widget.oldPrice! - widget.price) / widget.oldPrice!) * 100).round()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Product info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${_formatPrice(widget.price)} so\'m',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            if (widget.oldPrice != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '${_formatPrice(widget.oldPrice!)} so\'m',
                                style: TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Name
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Description
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Specifications
                        ...widget.specifications.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...entry.value.map((spec) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    bottom: 8,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        width: 4,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[400],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          spec,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 16),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom bar
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        cartController.addToCart({
                          'id': widget.id,
                          'name': widget.name,
                          'price': widget.price,
                          'oldPrice': widget.oldPrice,
                          'imageUrl': widget.imageUrl,
                          'quantity': 1,
                        });
                        Get.back();
                        Get.snackbar(
                          'Muvaffaqiyatli',
                          'Mahsulot savatga qo\'shildi',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          duration: const Duration(seconds: 2),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Savatga qo\'shish',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
