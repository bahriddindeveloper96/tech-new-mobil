import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/cart_controller.dart';

class ProductViewModal extends StatefulWidget {
  final String imageUrl;
  final String name;
  final double price;
  final double? oldPrice;
  final String description;
  final Map<String, String> specifications;

  const ProductViewModal({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.description,
    required this.specifications,
  });

  @override
  State<ProductViewModal> createState() => _ProductViewModalState();
}

class _ProductViewModalState extends State<ProductViewModal> {
  int quantity = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.85,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[850]
                            : Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image
                              Hero(
                                tag: widget.imageUrl,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Container(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey[900]
                                        : Colors.white,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.imageUrl,
                                      width: double.infinity,
                                      height: 300,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) => Container(
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey[800]
                                            : Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey[800]
                                            : Colors.grey[200],
                                        child: const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Product Info
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.name,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        height: 1.3,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey[100]
                                            : Colors.grey[900],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    if (widget.oldPrice != null) ...[
                                      Text(
                                        '${widget.oldPrice?.toStringAsFixed(0)} so\'m',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          decoration: TextDecoration.lineThrough,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.grey[400]
                                              : Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                    Text(
                                      '${widget.price.toStringAsFixed(0)} so\'m',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${(widget.price / 12).round()} so\'m/oyiga',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.info_outline,
                                            size: 16,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Close Button
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              onPressed: () => Get.back(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Specifications
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[850]
                          : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xususiyatlari',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[100]
                                  : Colors.grey[900],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...widget.specifications.entries.map((entry) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey[300]
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  entry.value,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    height: 1.5,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey[300]
                                        : Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  // Description
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[850]
                          : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mahsulot haqida',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[100]
                                  : Colors.grey[900],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[300]
                                  : Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
            ),
            // Bottom Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[850]
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                            icon: const Icon(Icons.remove),
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey[700],
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              quantity.toString(),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[100]
                                    : Colors.grey[900],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: const Icon(Icons.add),
                            color: Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final cartController = Get.find<CartController>();
                          cartController.addToCart({
                            'id': widget.name,
                            'name': widget.name,
                            'price': widget.price,
                            'oldPrice': widget.oldPrice,
                            'imageUrl': widget.imageUrl,
                          });
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Savatga qo\'shish',
                          style: TextStyle(
                            fontSize: 16,
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
      ),
    );
  }
}