import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/data/repositories/user/user_model.dart';
import 'package:stem_shop/features/shop/controllers/request_controller.dart';
import 'package:stem_shop/features/shop/models/request_model.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class RequestCard extends StatefulWidget {
  const RequestCard({super.key, required this.request, required this.onTap});

  final RequestModel request;
  final VoidCallback onTap;

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  late Future<UserModel> _requesterFuture;

  @override
  void initState() {
    super.initState();
    _requesterFuture = RequestsController.instance
        .fetchRequesterInfo(widget.request.requesterId);
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: TColors.primary.withValues(alpha: 0.03),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FutureBuilder<UserModel>(
                  future: _requesterFuture,
                  builder: (context, snapshot) {
                    final requester = snapshot.data;
                    final imageUrl =
                        (requester != null && requester.id.isNotEmpty)
                            ? requester.profilePicture
                            : '';
                    return CircleAvatar(
                      radius: 14,
                      backgroundImage:
                          imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      child: imageUrl.isEmpty
                          ? Icon(Iconsax.user,
                              size: 14,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)
                          : null,
                    );
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FutureBuilder<UserModel>(
                    future: _requesterFuture,
                    builder: (context, snapshot) {
                      final requester = snapshot.data;
                      final name =
                          snapshot.connectionState == ConnectionState.waiting
                              ? '...'
                              : (requester != null && requester.id.isNotEmpty
                                  ? requester.fullName
                                  : 'Unknown User');
                      return Text(
                        name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      );
                    },
                  ),
                ),
                Text(
                  _timeAgo(request.createdAt),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(request.title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              request.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request.category,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    children: [
                      const TextSpan(text: 'up to '),
                      TextSpan(
                        text: '${request.budget.toStringAsFixed(0)} EGP',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}