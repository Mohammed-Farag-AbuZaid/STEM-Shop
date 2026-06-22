import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/data/repositories/user/user_model.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/shop/controllers/request_controller.dart';
import 'package:stem_shop/features/shop/models/request_model.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({super.key, required this.request});

  final RequestModel request;

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  late Future<UserModel> _requesterFuture;

  @override
  void initState() {
    super.initState();
    _requesterFuture = RequestsController.instance
        .fetchRequesterInfo(widget.request.requesterId);
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final isOwnRequest =
        request.requesterId == UserController.instance.user.value.id;

    return Scaffold(
      appBar: TAppBar(title: const Text('Request Details'), showBackArrow: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: FutureBuilder<UserModel>(
          future: _requesterFuture,
          builder: (context, snapshot) {
            final requester = snapshot.data;
            final hasRequester = requester != null && requester.id.isNotEmpty;
            final imageUrl = hasRequester ? requester.profilePicture : '';
            final name = snapshot.connectionState == ConnectionState.waiting
                ? 'Loading...'
                : (hasRequester ? requester.fullName : 'Unknown User');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage:
                          imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      child: imageUrl.isEmpty
                          ? Icon(Iconsax.user,
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Text(name, style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBwSections),
                Text(request.title,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: TSizes.spaceBwItems),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(request.category,
                      style: Theme.of(context).textTheme.labelSmall),
                ),
                const SizedBox(height: TSizes.spaceBwSections),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  request.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(height: 1.6),
                ),
                const SizedBox(height: TSizes.spaceBwSections),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Budget',
                      style:
                          Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: 'up to ',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          TextSpan(
                            text: '${request.budget.toStringAsFixed(0)} EGP',
                            style:
                                const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBwSections * 2),

                if (!isOwnRequest)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: !hasRequester
                          ? null
                          : () {
                             /// I will add the logic here when publihing the app becasue I need an application link
                            },
                      icon: const Icon(Iconsax.message, color: Colors.white),
                      label: const Text(
                        'Sell it to me',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(TSizes.cardRadiusMd),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}