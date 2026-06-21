// lib/common/widgets/product/seller_order_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/features/shop/controllers/seller_order_controller.dart';
import 'package:stem_shop/features/shop/models/order_model.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class SellerOrderCard extends StatelessWidget {
  const SellerOrderCard({super.key, required this.order});

  final OrderModel order;

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = SellerOrdersController.instance;

    return Obx(() {
      final isProcessing = controller.processingOrderIds.contains(order.id);

      return Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          border: Border.all(color: TColors.grey.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
          color: TColors.primary.withValues(alpha: 0.05),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: order id + date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${order.id.substring(0, 6)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  _formatDate(order.createdAt),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.sm),

            // Items list
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  '\u2022 ${item.title} \u00d7 ${item.quantity}  —  ${item.totalPrice.toStringAsFixed(0)} EGP',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            const SizedBox(height: TSizes.sm),

            Text(
              'Total: ${order.totalPrice.toStringAsFixed(0)} EGP',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: TSizes.spaceBwItems),

            // Action buttons
            if (isProcessing)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => controller.declineOrder(order),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBwItems),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.confirmOrder(order),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Confirm'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }
}