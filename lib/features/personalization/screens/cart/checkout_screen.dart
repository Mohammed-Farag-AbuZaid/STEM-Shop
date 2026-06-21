import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/features/shop/controllers/checkout_controller.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class CheckoutResultsScreen extends StatelessWidget {
  const CheckoutResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Confirm with Sellers',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Obx(() {
        if (controller.results.isEmpty) {
          return const Center(child: Text('No orders were placed.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          itemCount: controller.results.length,
          separatorBuilder: (_, _) =>
              const SizedBox(height: TSizes.spaceBwItems),
          itemBuilder: (_, index) {
            final result = controller.results[index];

            return Obx(() {
              final sent = result.messageSent.value;

              return Container(
                padding: const EdgeInsets.all(TSizes.md),
                decoration: BoxDecoration(
                  border: Border.all(color: sent ? Colors.green : TColors.grey),
                  borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            result.seller.fullName.trim().isNotEmpty
                                ? result.seller.fullName
                                : 'Seller',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (sent)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: TSizes.sm),
                    ...result.order.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '\u2022 ${item.title} \u00d7 ${item.quantity}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.sm),
                    Text(
                      'Total: ${result.order.totalPrice} EGP',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBwItems),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => controller.messageSeller(result),
                        icon: const Icon(Icons.chat, size: 18),
                        label: Text(
                          sent
                              ? 'Message Sent \u2014 Tap to Resend'
                              : 'Message Seller',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
          },
        );
      }),
    );
  }
}
