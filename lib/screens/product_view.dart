import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/cart_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/product_controller.dart';
import 'product_view_modal.dart';
import './cart.dart';

class ProductView extends StatefulWidget {
  final String productId;

  const ProductView({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final ProductController productController = Get.find();
  final CartController cartController = Get.find();
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  int _quantity = 1;
  String? _selectedColor;
  String? _selectedStorage;

  @override
  void initState() {
    super.initState();
    productController.getProduct(widget.productId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.grey[100],
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = productController.productData;
        if (product.isEmpty) {
          return const Center(child: Text('Product not found'));
        }

        final images = productController.getProductImages(product);
        final basePrice = productController.getBasePrice();
        final oldPrice = productController.getOldPrice();

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Images section with dot indicators
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: Colors.white,
                                  child: CachedNetworkImage(
                                    imageUrl: images[index],
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Center(
                                      child: Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 48,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Image indicators
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                (index) => Container(
                                  width: 8,
                                  height: 8,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index
                                        ? theme.colorScheme.primary
                                        : Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Product info
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: theme.textTheme.headlineSmall,
                            ),
                            SizedBox(height: 8),
                            Text(
                              product['description'],
                              style: theme.textTheme.bodyMedium,
                            ),
                            SizedBox(height: 16),
                            
                            // Price section
                            Row(
                              children: [
                                if (oldPrice != null) ...[
                                  Text(
                                    '${oldPrice.toStringAsFixed(0)} so\'m',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                ],
                                Text(
                                  '${basePrice.toStringAsFixed(0)} so\'m',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 24),
                            
                            // Color selection
                            Text(
                              'Color',
                              style: theme.textTheme.titleMedium,
                            ),
                            SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: productController.colors.map((colorOption) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedColor = colorOption['name'];
                                      });
                                      productController.updateSelectedVariant(
                                        color: colorOption['name'],
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 16),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: colorOption['color'],
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: _selectedColor == colorOption['name']
                                                    ? theme.colorScheme.primary
                                                    : Colors.transparent,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            colorOption['name'],
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            
                            SizedBox(height: 24),
                            
                            // Storage selection
                            Text(
                              'Storage',
                              style: theme.textTheme.titleMedium,
                            ),
                            SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: productController.storageOptions.map((storage) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedStorage = storage['size'];
                                      });
                                      productController.updateSelectedVariant(
                                        storage: storage['size'],
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 16),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _selectedStorage == storage['size']
                                            ? theme.colorScheme.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                      child: Text(
                                        storage['size'],
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: _selectedStorage == storage['size']
                                              ? Colors.white
                                              : theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            
                            SizedBox(height: 24),
                            
                            // Reviews section
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Sharhlar',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Navigate to all reviews
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Barchasini ko\'rish',
                                              style: TextStyle(
                                                color: theme.colorScheme.primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              color: theme.colorScheme.primary,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  // Rating summary
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: theme.dividerColor.withOpacity(0.1),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              Text(
                                                product['average_rating']?.toString() ?? '0.0',
                                                style: theme.textTheme.headlineMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: theme.colorScheme.primary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: List.generate(5, (index) {
                                                  final rating = double.tryParse(product['average_rating']?.toString() ?? '0.0') ?? 0.0;
                                                  return Icon(
                                                    index < rating.floor() ? Icons.star : Icons.star_border,
                                                    color: Colors.amber,
                                                    size: 16,
                                                  );
                                                }),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${product['favorite_count'] ?? 0} ta sharh',
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 60,
                                          color: theme.dividerColor.withOpacity(0.1),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 16),
                                            child: Column(
                                              children: [
                                                _buildRatingBar(5, 0.7, theme),
                                                _buildRatingBar(4, 0.2, theme),
                                                _buildRatingBar(3, 0.05, theme),
                                                _buildRatingBar(2, 0.03, theme),
                                                _buildRatingBar(1, 0.02, theme),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  // Review items
                                  ...List.generate(3, (index) {
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: theme.dividerColor.withOpacity(0.1),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 16,
                                                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                                child: Text(
                                                  'A',
                                                  style: TextStyle(
                                                    color: theme.colorScheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Alisher',
                                                    style: theme.textTheme.titleSmall?.copyWith(
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      ...List.generate(5, (starIndex) {
                                                        return Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                          size: 14,
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Text(
                                                '2 kun oldin',
                                                style: theme.textTheme.bodySmall?.copyWith(
                                                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Mahsulot sifati ajoyib, yetkazib berish ham tez. Sotuvchiga rahmat!',
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                          if (index == 0) ...[
                                            const SizedBox(height: 12),
                                            SizedBox(
                                              height: 80,
                                              child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: 3,
                                                itemBuilder: (context, imageIndex) {
                                                  return Container(
                                                    width: 80,
                                                    margin: const EdgeInsets.only(right: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(
                                                        color: theme.dividerColor.withOpacity(0.1),
                                                      ),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(8),
                                                      child: Image.network(
                                                        'http://192.168.1.108:8000/storage/products/${imageIndex + 1}.webp',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ),
            // Back button at top
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 8,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
            ),
            // Bottom cart bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity controls
                    Obx(() {
                      final isInCart = cartController.cartItems
                          .any((item) => item['id'] == productController.productData['id']);
                      
                      return isInCart ? const SizedBox() : Row(
                        children: [
                          IconButton(
                            onPressed: _decrementQuantity,
                            icon: const Icon(Icons.remove, size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.surfaceVariant,
                              padding: const EdgeInsets.all(8),
                              minimumSize: const Size(32, 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              _quantity.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _incrementQuantity,
                            icon: const Icon(Icons.add, size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.surfaceVariant,
                              padding: const EdgeInsets.all(8),
                              minimumSize: const Size(32, 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(width: 8),
                    // Add to cart button
                    Expanded(
                      child: Obx(() {
                        final isInCart = cartController.cartItems
                            .any((item) => item['id'] == productController.productData['id']);

                        return ElevatedButton(
                          onPressed: () {
                            if (isInCart) {
                              Get.to(() => const CartScreen());
                            } else {
                              final product = Map<String, dynamic>.from(productController.productData);
                              product['quantity'] = _quantity;
                              product['price'] = productController.getBasePrice();
                              if (_selectedColor != null) {
                                product['selected_color'] = _selectedColor;
                              }
                              if (_selectedStorage != null) {
                                product['selected_storage'] = _selectedStorage;
                              }
                              cartController.addToCart(product);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            minimumSize: const Size(0, 40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isInCart ? 'Savatga o\'tish' : 'Savatga qo\'shish',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildRatingBar(int rating, double percentage, ThemeData theme) {
    return Row(
      children: [
        Text(
          '$rating',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: theme.dividerColor.withOpacity(0.1),
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(percentage * 100).toStringAsFixed(0)}%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}