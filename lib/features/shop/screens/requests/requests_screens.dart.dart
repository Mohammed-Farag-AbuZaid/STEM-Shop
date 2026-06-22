import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/common/widgets/requests/request_card.dart';
import 'package:stem_shop/features/shop/controllers/request_controller.dart';
import 'package:stem_shop/features/shop/screens/requests/add_request_screen.dart';
import 'package:stem_shop/features/shop/screens/requests/request_card_skeleton.dart';
import 'package:stem_shop/features/shop/screens/requests/request_detail_screen.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  void _showScopeMenu(BuildContext context, Offset tapPosition) async {
    final controller = RequestsController.instance;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx,
        tapPosition.dy,
      ),
      items: [
        PopupMenuItem(
          value: 'school',
          child: Obx(() => Row(
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 18,
                    color: controller.scopeFilter.value == 'school'
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'My School Only',
                    style: TextStyle(
                      color: controller.scopeFilter.value == 'school'
                          ? Colors.blue
                          : null,
                      fontWeight: controller.scopeFilter.value == 'school'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              )),
        ),
        PopupMenuItem(
          value: 'all',
          child: Obx(() => Row(
                children: [
                  Icon(
                    Icons.public_outlined,
                    size: 18,
                    color: controller.scopeFilter.value == 'all'
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'All Schools',
                    style: TextStyle(
                      color: controller.scopeFilter.value == 'all'
                          ? Colors.blue
                          : null,
                      fontWeight: controller.scopeFilter.value == 'all'
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              )),
        ),
      ],
    );

    if (selected != null) {
      controller.applyScopeFilter(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = RequestsController.instance;

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Requests',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          GestureDetector(
            onTapUp: (details) =>
                _showScopeMenu(context, details.globalPosition),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Obx(() => Icon(
                    Icons.filter_list_sharp,
                    color: controller.scopeFilter.value != 'all'
                        ? Colors.blue
                        : null,
                  )),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.requests.isEmpty) {
          return ListView.separated(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            itemCount: 5,
            separatorBuilder: (_, __) =>
                const SizedBox(height: TSizes.spaceBwItems),
            itemBuilder: (_, __) => const RequestCardSkeleton(),
          );
        }

        if (controller.requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.message_question,
                    size: 64, color: Colors.grey.withValues(alpha: 0.5)),
                const SizedBox(height: TSizes.spaceBwItems),
                Text(
                  'No requests yet',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchRequests,
          child: ListView.separated(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            itemCount: controller.requests.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: TSizes.spaceBwItems),
            itemBuilder: (context, index) {
              final request = controller.requests[index];
              return RequestCard(
                request: request,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RequestDetailScreen(request: request),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddRequestScreen()),
        ),
        backgroundColor: Colors.blue,
        child: const Icon(Iconsax.add_square, color: Colors.white),
      ),
    );
  }
}