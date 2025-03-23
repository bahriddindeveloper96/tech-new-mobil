import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/product_card.dart';
import 'product_view.dart';

class CategoryView extends StatefulWidget {
  final String title;
  final String id;

  const CategoryView({
    Key? key,
    required this.title,
    required this.id,
  }) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final categoryController = Get.put(CategoryController());
  int selectedFilter = 0;
  RangeValues _priceRange = const RangeValues(0, 30000000);
  bool _onlyDiscount = false;
  List<String> selectedColors = [];
  List<String> selectedBrands = [];
  
  final List<Map<String, dynamic>> colors = [
    {'name': 'black'.tr, 'color': Colors.black},
    {'name': 'white'.tr, 'color': Colors.white},
    {'name': 'grey'.tr, 'color': Colors.grey},
    {'name': 'blue'.tr, 'color': Colors.blue},
    {'name': 'red'.tr, 'color': Colors.red},
    {'name': 'gold'.tr, 'color': Colors.amber},
  ];
  
  final List<String> brands = [
    'Apple',
    'Samsung',
    'Xiaomi',
    'Huawei',
    'Vivo',
    'OPPO',
    'OnePlus',
    'Nothing',
  ];
  
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final theme = Theme.of(context);
          
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'filter'.tr,
                        style: theme.textTheme.titleLarge,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _priceRange = const RangeValues(0, 30000000);
                            _onlyDiscount = false;
                            selectedColors = [];
                            selectedBrands = [];
                          });
                        },
                        child: Text('reset'.tr),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                
                // Filter Content
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      // Price Range
                      Text(
                        'price_range'.tr,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 30000000,
                        divisions: 100,
                        labels: RangeLabels(
                          _priceRange.start.toStringAsFixed(0),
                          _priceRange.end.toStringAsFixed(0),
                        ),
                        onChanged: (values) {
                          setState(() {
                            _priceRange = values;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_priceRange.start.toStringAsFixed(0)} ${'sum'.tr}',
                            style: theme.textTheme.labelSmall,
                          ),
                          Text(
                            '${_priceRange.end.toStringAsFixed(0)} ${'sum'.tr}',
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Only Discount
                      Row(
                        children: [
                          Text(
                            'only_discount'.tr,
                            style: theme.textTheme.titleSmall,
                          ),
                          const Spacer(),
                          Switch(
                            value: _onlyDiscount,
                            onChanged: (value) {
                              setState(() {
                                _onlyDiscount = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Colors
                      Text(
                        'colors'.tr,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: colors.map((color) {
                          final isSelected = selectedColors.contains(color['name']);
                          
                          return FilterChip(
                            label: Text(color['name']),
                            selected: isSelected,
                            onSelected: (value) {
                              setState(() {
                                if (value) {
                                  selectedColors.add(color['name']);
                                } else {
                                  selectedColors.remove(color['name']);
                                }
                              });
                            },
                            avatar: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: color['color'],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      
                      // Brands
                      Text(
                        'brands'.tr,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: brands.map((brand) {
                          final isSelected = selectedBrands.contains(brand);
                          
                          return FilterChip(
                            label: Text(brand),
                            selected: isSelected,
                            onSelected: (value) {
                              setState(() {
                                if (value) {
                                  selectedBrands.add(brand);
                                } else {
                                  selectedBrands.remove(brand);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                
                // Apply Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Apply filter logic here
                    },
                    child: Text('apply'.tr),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    categoryController.fetchCategoryProducts(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppHeader(title: widget.title),
      bottomNavigationBar: const BottomNavBar(),
      body: Column(     
        children: [
          // Breadcrumbs
          Obx(() {
            final breadcrumbs = categoryController.breadcrumbs;
            if (breadcrumbs.isEmpty) return const SizedBox();
            
            return Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                  ),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Get.back(),
                      child: Text(
                        'home'.tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    ...List.generate(breadcrumbs.length, (index) {
                      final item = breadcrumbs[index];
                      final isLast = index == breadcrumbs.length - 1;
                      
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.chevron_right,
                              size: 16,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          if (!isLast)
                            InkWell(
                              onTap: () {
                                Get.to(() => CategoryView(
                                  title: item['name'],
                                  id: item['id'].toString(),
                                ));
                              },
                              child: Text(
                                item['name'],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            )
                          else
                            Text(
                              item['name'],
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            );
          }),
          
          // Sort Bar
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: _showFilterDialog,
                  icon: const Icon(Icons.filter_list, size: 16),
                  label: Text(
                    'filter'.tr,
                    style: theme.textTheme.bodySmall,
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
          
          // Products Grid
          Expanded(
            child: Obx(() {
              if (categoryController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (categoryController.error.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        categoryController.error.value,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final products = categoryController.products;
              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_products_in_category'.tr,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      if (widget.title.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: 0.65,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final variants = List<Map<String, dynamic>>.from(product['variants'] ?? []);
                  if (variants.isEmpty) return const SizedBox();
                  
                  final firstVariant = variants.first;
                  final variantImages = List<String>.from(firstVariant['images'] ?? []);
                  final price = firstVariant['price'];
                  final oldPrice = product['old_price'];
                  
                  return ProductCard(
                    images: variantImages,
                    name: categoryController.getLocalizedName(product, Get.locale?.languageCode ?? 'en'),
                    price: double.tryParse(price.toString()) ?? 0.0,
                    oldPrice: oldPrice != null ? double.tryParse(oldPrice.toString()) : null,
                    isNew: product['is_new'] == true,
                    isDiscount: oldPrice != null,
                    productId: product['id'].toString(),
                    onTap: () {
                      Get.to(() => ProductView(
                        productId: product['id'].toString(),
                      ));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
