import 'package:flutter/material.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
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
    final statusLabel = product.status == 'available'
        ? 'Available'
        : (product.status == 'sold' ? 'Sold' : 'Hidden');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TSizes.spaceBwItems),
        Text(product.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: TSizes.spaceBwItems),
        Text(
          statusLabel,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: statusColor),
        ),
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
        const SizedBox(height: TSizes.spaceBwItems),
        Text(
          'Seller ID: ${product.sellerId}',
          style: Theme.of(context).textTheme.titleMedium,
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}