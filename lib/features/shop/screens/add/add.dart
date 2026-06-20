import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/menues/product_action_menu.dart';
import 'package:stem_shop/common/widgets/product/user_product_skelaton.dart';
import 'package:stem_shop/common/widgets/product/user_products_card.dart';
import 'package:stem_shop/data/repositories/products/product_repository.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/features/shop/screens/add/add_product_screen.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  List<ProductModel> _userProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProducts();
  }

  Future<void> _loadUserProducts() async {
    try {
      final sellerId = UserController.instance.user.value.id;
      final products = await ProductRepository.instance.fetchUserProducts(
        sellerId: sellerId,
      );
      if (mounted) {
        setState(() {
          _userProducts = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _handleProductAction(
    TProductAction action,
    ProductModel product,
  ) async {
    switch (action) {
      case TProductAction.edit:
        // NOTE: AddProductScreen doesn't yet support pre-filling from an
        // existing product — that's the next thing we're building.
        Get.snackbar(
          'Coming Soon',
          'Editing listings isn\'t wired up yet.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        break;

      case TProductAction.sold:
        try {
          await ProductRepository.instance.updateProductField(
            product.id,
            {'status': 'sold', 'quantity': 0},
          );
          await _loadUserProducts();
          Get.snackbar(
            'Done',
            'Product marked as sold.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } catch (e) {
          Get.snackbar(
            'Error',
            e.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        break;

      case TProductAction.delete:
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete Product'),
            content: const Text(
              'Are you sure you want to permanently delete this listing? This cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        if (confirm != true) return;
        try {
          await ProductRepository.instance.deleteProduct(product.id);
          await _loadUserProducts();
          Get.snackbar(
            'Deleted',
            'Listing permanently removed.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } catch (e) {
          Get.snackbar(
            'Error',
            e.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text('Your Listings'),
        showBackArrow: false,
      ),
      body: _isLoading
          ? ListView.separated(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              itemCount: 4,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: TSizes.spaceBwItems),
              itemBuilder: (_, _) => const TMyListingSkeleton(),
            )
          : _userProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.box,
                    size: 64,
                    color: Colors.grey.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: TSizes.spaceBwItems),
                  Text(
                    'No listings yet',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: TSizes.spaceBwItems / 2),
                  Text(
                    'Tap + to add your first product',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadUserProducts,
              child: ListView.separated(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                itemCount: _userProducts.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: TSizes.spaceBwItems),
                itemBuilder: (context, index) {
                  final product = _userProducts[index];
                  return TMyListingCard(
                    product: product,
                    onAction: (action) =>
                        _handleProductAction(action, product),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
          _loadUserProducts();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Iconsax.add_square, color: Colors.white),
      ),
    );
  }
}