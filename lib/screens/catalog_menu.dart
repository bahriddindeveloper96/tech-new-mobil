import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import 'category_view.dart';

class CatalogMenu extends StatefulWidget {
  const CatalogMenu({super.key});

  @override
  State<CatalogMenu> createState() => _CatalogMenuState();
}

class _CatalogMenuState extends State<CatalogMenu> {
  late final CategoryController categoryController;
  final Set<int> expandedCategories = {};

  @override
  void initState() {
    super.initState();
    categoryController = Get.put(CategoryController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryController.fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F6),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          'categories'.tr,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GetBuilder<CategoryController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.error.value,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => controller.fetchCategories(),
                    icon: const Icon(Icons.refresh),
                    label: Text('retry'.tr),
                  ),
                ],
              ),
            );
          }

          if (controller.categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'no_categories'.tr,
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Container(
            color: const Color(0xFFF4F5F6),
            margin: EdgeInsets.symmetric(
              horizontal: isTablet ? screenWidth * 0.1 : 8,
              vertical: 8,
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: controller.categories.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return _buildCategoryTile(category, 0);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryTile(Map<String, dynamic> category, int depth) {
    final children = category['children'] as List<dynamic>?;
    final hasChildren = children != null && children.isNotEmpty;
    final isExpanded = expandedCategories.contains(category['id']);
    final imageUrl = categoryController.getImageUrl(category);
    final name = categoryController.getLocalizedName(category, Get.locale?.languageCode ?? 'en');
    final description = categoryController.getLocalizedDescription(category, Get.locale?.languageCode ?? 'en');

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (hasChildren) {
              setState(() {
                if (isExpanded) {
                  expandedCategories.remove(category['id']);
                } else {
                  expandedCategories.add(category['id']);
                }
              });
            } else {
              Get.to(() => CategoryView(
                title: name,
                id: category['id'].toString(),
              ));
            }
          },
          child: Container(
            padding: EdgeInsets.only(
              left: depth == 0 ? 16.0 : depth * 20.0 + 16.0,
              right: 16,
              top: 12,
              bottom: 12,
            ),
            color: isExpanded ? Colors.grey[50] : const Color(0xFFF4F5F6),
            child: Row(
              children: [
                if (imageUrl != null) ...[
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[100],
                              child: Icon(
                                Icons.category_outlined,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: depth == 0 ? 15 : 14,
                          fontWeight: depth == 0 ? FontWeight.w600 : FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      if (description.isNotEmpty && depth == 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (hasChildren)
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (hasChildren && isExpanded)
          Column(
            children: children.map<Widget>((child) {
              return _buildCategoryTile(
                Map<String, dynamic>.from(child),
                depth + 1,
              );
            }).toList(),
          ),
      ],
    );
  }
}