import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:stem_shop/features/shop/controllers/products_controler.dart';
import 'package:stem_shop/features/shop/models/category_model.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/features/shop/screens/category/sub_categories.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TSubCategoryShowcase extends StatefulWidget {
  const TSubCategoryShowcase({
    super.key,
    required this.subCategory,
  });

  final CategoryModel subCategory;

  @override
  State<TSubCategoryShowcase> createState() => _TSubCategoryShowcaseState();
}

class _TSubCategoryShowcaseState extends State<TSubCategoryShowcase> {
  late Future<List<ProductModel>> _sampleFuture;

  @override
  void initState() {
    super.initState();
    _sampleFuture = ProductController.instance
        .getSubCategorySample(widget.subCategory.id);
  }

  ImageProvider _resolveThumbnail(String path) {
    if (path.isEmpty) return AssetImage(TImages.shopNow);
    return path.startsWith('http://') || path.startsWith('https://')
        ? NetworkImage(path) as ImageProvider
        : AssetImage(path) as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    return TCircularContianer(
      showBorder: true,
      backgroundColor: Colors.transparent,
      borderColor: TColors.borderPrimary,
      padding: const EdgeInsets.all(TSizes.sm),
      margin: const EdgeInsets.only(bottom: TSizes.spaceBwItems),
      child: Column(
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.subCategory.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: () => Get.to(
                  () => SubCategoriesScreen(subCategory: widget.subCategory),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBwItems),

          // 3 product image samples
          FutureBuilder(
            future: _sampleFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Row(
                  children: List.generate(
                    3,
                    (_) => Expanded(
                      child: TCircularContianer(
                        height: 100,
                        backgroundColor: THelperFunctions.isDarkMode(context)
                            ? TColors.darkerGrey
                            : TColors.light,
                        margin: const EdgeInsets.only(right: TSizes.sm),
                      ),
                    ),
                  ),
                );
              }

              final products = snapshot.data ?? [];

              if (products.isEmpty) {
                return SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      'No products yet',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                );
              }

              return Row(
                children: products.map((product) {
                  return Expanded(
                    child: TCircularContianer(
                      height: 100,
                      backgroundColor: THelperFunctions.isDarkMode(context)
                          ? TColors.darkerGrey
                          : TColors.light,
                      borderColor: TColors.borderPrimary,
                      margin: const EdgeInsets.only(right: TSizes.sm),
                      padding: const EdgeInsets.all(TSizes.md),
                      child: Image(
                        fit: BoxFit.contain,
                        image: _resolveThumbnail(product.thumbnail),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}