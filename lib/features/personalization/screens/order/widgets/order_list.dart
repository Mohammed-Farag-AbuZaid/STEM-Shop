import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:stem_shop/features/shop/controllers/order_controller.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return TColors.primary;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pending Confirmation';
      case 'confirmed':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = OrdersController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Obx(() {
      if (controller.ordersLoading.value) {
        return const Center(child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: CircularProgressIndicator(),
        ));
      }

      if (controller.orders.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),
            child: Text('You haven\'t placed any orders yet.'),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        itemCount: controller.orders.length,
        separatorBuilder: (_, _) => const SizedBox(height: TSizes.spaceBwItems),
        itemBuilder: (_, index) {
          final order = controller.orders[index];

          return TRoundedContainer(
            showBorder: true,
            padding: const EdgeInsets.all(TSizes.md),
            backgroundColor: dark ? TColors.dark : TColors.light,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// -- Row 1: status & date
                Row(
                  children: [
                    Icon(
                      order.messageSent ? Iconsax.message_question : Iconsax.message,
                      color: _statusColor(order.status),
                    ),
                    const SizedBox(width: TSizes.spaceBwItems / 2),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _statusLabel(order.status),
                            style: Theme.of(context).textTheme.bodyLarge!.apply(
                                  color: _statusColor(order.status),
                                  fontWeightDelta: 1,
                                ),
                          ),
                          Text(
                            _formatDate(order.createdAt),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBwItems),

                /// -- Row 2: order id & total
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Iconsax.tag),
                          const SizedBox(width: TSizes.spaceBwItems / 2),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Order', style: Theme.of(context).textTheme.labelMedium),
                                Text(
                                  '#${order.id.substring(0, 6)}',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Iconsax.wallet_3),
                          const SizedBox(width: TSizes.spaceBwItems / 2),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total', style: Theme.of(context).textTheme.labelMedium),
                                Text(
                                  '${order.totalPrice.toStringAsFixed(0)} EGP',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBwItems),

                /// -- Items list
                ...order.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      '\u2022 ${item.title} \u00d7 ${item.quantity}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}