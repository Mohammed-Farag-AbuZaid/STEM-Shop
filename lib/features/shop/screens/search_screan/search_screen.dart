import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/layouts/grid_layout.dart';
import 'package:stem_shop/common/widgets/product/product_card_skeleton.dart';
import 'package:stem_shop/common/widgets/product/product_card_vertical.dart';
import 'package:stem_shop/features/shop/controllers/products_controler.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = ProductController.instance;
  final _textController = TextEditingController();
  final _debounce = _Debouncer(delay: const Duration(milliseconds: 400));

  bool get _isEmpty => _textController.text.isEmpty;

  @override
  void dispose() {
    _textController.dispose();
    _debounce.dispose();
    _controller.clearSearch();
    super.dispose();
  }

  void _onTextChanged(String value) {
    setState(() {});
    _debounce.run(() => _controller.searchProducts(value));
  }

  void _clearSearch() {
    _textController.clear();
    _controller.clearSearch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            prefixIcon: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            suffixIcon: _isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
          ),
          onChanged: _onTextChanged,
        ),
      ),
      body: _isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.search_normal, size: 48, color: Colors.grey),
                  SizedBox(height: TSizes.spaceBwItems),
                  Text(
                    'Type to search products',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : Obx(() {
              if (_controller.searchLoading.value) {
                return GridView.builder(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: TSizes.gridViewSpacing,
                    mainAxisSpacing: TSizes.gridViewSpacing,
                    mainAxisExtent: 288,
                  ),
                  itemCount: 4,
                  itemBuilder: (_, _) => const TProductCardSkeleton(),
                );
              }

              if (_controller.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Iconsax.search_status,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: TSizes.spaceBwItems),
                      Text(
                        'No results for "${_textController.text}"',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: TSizes.spaceBwItems / 2),
                      const Text(
                        'Try a different search term',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }

              return TGridLayout(
                itemCount: _controller.searchResults.length,
                mainAxisExtent: 288,
                itemBuilder: (_, index) => TProductCardVertical(
                  product: _controller.searchResults[index],
                ),
              );
            }),
    );
  }
}

class _Debouncer {
  final Duration delay;
  Timer? _timer;

  _Debouncer({required this.delay});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}