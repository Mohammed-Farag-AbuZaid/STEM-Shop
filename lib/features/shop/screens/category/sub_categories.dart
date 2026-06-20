import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/layouts/grid_layout.dart';
import 'package:stem_shop/common/widgets/product/product_card_vertical.dart';
import 'package:stem_shop/features/shop/controllers/products_controler.dart';
import 'package:stem_shop/features/shop/models/category_model.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/common/widgets/product/product_card_skeleton.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({super.key, required this.subCategory});

  final CategoryModel subCategory;

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final _scrollController = ScrollController();
  final _controller = ProductController.instance;
  String _selectedSort = 'Newest';

  List<ProductModel> _getSortedProducts() {
    final products = List<ProductModel>.from(_controller.paginatedProducts);
    switch (_selectedSort) {
      case 'Higher Price':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Lower Price':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Newest':
      default:
        products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    return products;
  }

  @override
  @override
  void initState() {
    super.initState();
    // Clear previous pagination data immediately
    _controller.paginatedProducts.clear();
    _controller.hasMoreProducts.value = true;
    _controller.startPagination(subCategoryId: widget.subCategory.id);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _controller.loadMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(widget.subCategory.name),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Sort Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSort,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.sort),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedSort = value);
                  }
                },
                items: ['Newest', 'Higher Price', 'Lower Price']
                    .map(
                      (option) =>
                          DropdownMenuItem(value: option, child: Text(option)),
                    )
                    .toList(),
              ),
              const SizedBox(height: TSizes.spaceBwSections),

              /// Products Grid
              Obx(() {
                final products = _getSortedProducts();

                if (products.isEmpty && _controller.paginationLoading.value) {
                  return TGridLayout(
                    itemCount: 6,
                    itemBuilder: (_, __) => const TProductCardSkeleton(),
                  );
                }

                if (products.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(TSizes.defaultSpace),
                      child: Text('No products in this subcategory yet.'),
                    ),
                  );
                }

                return TGridLayout(
                  itemCount: products.length,
                  itemBuilder: (_, index) =>
                      TProductCardVertical(product: products[index]),
                );
              }),

              /// Load More Indicator
              Obx(() {
                if (!_controller.paginationLoading.value) {
                  return const SizedBox.shrink();
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: TSizes.defaultSpace),
                  child: Center(child: CircularProgressIndicator()),
                );
              }),

              /// End of List
              Obx(() {
                if (_controller.hasMoreProducts.value ||
                    _controller.paginatedProducts.isEmpty) {
                  return const SizedBox.shrink();
                }
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: TSizes.defaultSpace),
                  child: Center(
                    child: Text(
                      'You\'ve seen all products',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }),

              const SizedBox(height: TSizes.defaultSpace),
            ],
          ),
        ),
      ),
    );
  }
}
