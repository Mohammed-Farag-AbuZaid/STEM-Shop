import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key, required this.request});

  final Map<String, dynamic> request;

  @override
  Widget build(BuildContext context) {
    final imageUrl = request['userImage'] as String? ?? '';

    return Scaffold(
      appBar: TAppBar(
        title: const Text('Request Details'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // user row
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: imageUrl.isEmpty
                      ? Icon(Iconsax.user, size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant)
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  request['userName'] as String,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBwSections),

            // title
            Text(
              request['title'] as String,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBwItems),

            // category chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                request['category'] as String,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            const SizedBox(height: TSizes.spaceBwSections),

            // description
            Text(
              'Description',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              request['desc'] as String,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.6),
            ),
            const SizedBox(height: TSizes.spaceBwSections),

            // budget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'up to ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${(request['budget'] as double).toStringAsFixed(0)} EGP',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBwSections * 2),

            // whatsapp button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // wire TWhatsAppLauncher here
                },
                icon: const Icon(Iconsax.message, color: Colors.white),
                label: const Text(
                  'Sell it to me',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusMd),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}