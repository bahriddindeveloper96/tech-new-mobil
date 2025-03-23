import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/product_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/banner_carousel.dart';
import '../controllers/home_controller.dart';
import 'product_view.dart';
import 'category_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final HomeController _homeController = Get.put(HomeController());
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  List<dynamic> _getAllProducts() {
    final allProducts = [
      ..._homeController.featuredProducts,
      ..._homeController.newProducts,
      ..._homeController.popularProducts,
    ];
    return allProducts;
  }

  Widget _buildHorizontalProductList(String title, List<dynamic> products) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            _buildSectionTitle(title),
            const SizedBox(height: 6),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                itemBuilder: (context, index) {
                  final product = products[index];
                  final variant = product.variants.isNotEmpty
                      ? product.variants.first
                      : null;
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 4),
                    child: ProductCard(
                      images: product.variants.isNotEmpty 
                          ? List<String>.from(product.variants.first.images)
                          : [''],
                      name: product.name,
                      price: variant != null ? double.parse(variant.price) : 0,
                      oldPrice: null,
                      isNew: title == 'new_products'.tr,
                      isDiscount: false,
                      productId: product.id.toString(),
                      onTap: () {
                        Get.to(
                          () => ProductView(
                            productId: product.id.toString(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const AppHeader(),
      body: Obx(() {
        if (_homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final allProducts = _getAllProducts();
        
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Banner Carousel
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: BannerCarousel(
                  height: 200,
                  bannerImages: _homeController.banners
                      .map((banner) => 'http://192.168.1.108:8000\${banner.image}')
                      .toList(),
                ),
              ),
            ),
            
            // Categories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    _buildSectionTitle('categories'.tr),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _homeController.categories.length,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        itemBuilder: (context, index) {
                          final category = _homeController.categories[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => CategoryView(
                                    title: category.name,
                                    id: category.id.toString(),
                                  ));
                            },
                            child: Container(
                              width: 80,
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: 'http://192.168.1.108:8000\${category.image}',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.1),
                                          child: Icon(
                                            Icons.category,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.1),
                                          child: Icon(
                                            Icons.category,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    category.name,
                                    style: theme.textTheme.labelSmall,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Popular Products Slider
            _buildHorizontalProductList('popular_products'.tr, _homeController.popularProducts),

            // New Products Slider
            _buildHorizontalProductList('new_products'.tr, _homeController.newProducts),

            // Featured Products Slider
            _buildHorizontalProductList('featured_products'.tr, _homeController.featuredProducts),

            // All Products Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: _buildSectionTitle('all_products'.tr),
              ),
            ),

            // All Products Grid
            SliverPadding(
              padding: const EdgeInsets.all(6),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6, // Made more vertical
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  mainAxisExtent: size.width * 0.75, // Set fixed height based on screen width
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = allProducts[index];
                    final variant = product.variants.isNotEmpty
                        ? product.variants.first
                        : null;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: ProductCard(
                        images: product.variants.isNotEmpty 
                            ? List<String>.from(product.variants.first.images)
                            : [''],
                        name: product.name,
                        price: variant != null ? double.parse(variant.price) : 0,
                        oldPrice: null,
                        isNew: false,
                        isDiscount: false,
                        productId: product.id.toString(),
                        onTap: () {
                          Get.to(
                            () => ProductView(
                              productId: product.id.toString(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: allProducts.length,
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        TextButton(
          onPressed: () {},
          child: Text('view_all'.tr),
        ),
      ],
    );
  }
}