import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/features/shop/controllers/products_controler.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/features/shop/screens/product_details/screens/seller_info_dialog.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductMetaData extends StatelessWidget {
  const ProductMetaData({super.key, required this.product});

  final ProductModel product;

  Future<void> _launchOnlineLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = product.status == 'available'
        ? Colors.green
        : (product.status == 'sold' ? Colors.red : Colors.grey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TSizes.spaceBwItems),
        Text(product.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: TSizes.spaceBwItems),
        if (product.status == 'available') ...[
          const SizedBox(height: TSizes.xs),
          Text(
            product.quantity > 0
                ? '${product.quantity} available'
                : 'Out of stock',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: product.quantity > 0 ? Colors.green : Colors.orange,
            ),
          ),
        ],
        const SizedBox(height: TSizes.spaceBwItems ),
        InkWell(
          onTap: () async {
            final controller = ProductController.instance;
            await controller.loadSeller(product.sellerId);
            if (controller.seller.value != null) {
              // ignore: use_build_context_synchronously
              SellerInfoDialog.show(context, controller.seller.value!);
            }
          },
          child: Row(
            children: [
              const Icon(Iconsax.user, size: 18),
              const SizedBox(width: TSizes.sm),
              Obx(() {
                final c = ProductController.instance;
                return Text(
                  c.sellerLoading.value
                      ? 'Loading seller...'
                      : 'View Seller Info',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                );
              }),
            ],
          ),
        ),
        if (product.hasOnlineLink) ...[
          const SizedBox(height: TSizes.spaceBwItems),
          GestureDetector(
            onTap: () => _launchOnlineLink(product.onlineLink!),
            child: Row(
              children: [
                const Icon(Icons.open_in_new, size: 16, color: Colors.blue),
                const SizedBox(width: TSizes.xs),
                Text(
                  'View similar online',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
