import 'package:get/get.dart';
import 'package:stem_shop/data/repositories/products/order_repository.dart';

import 'package:stem_shop/data/repositories/user/user_model.dart';
import 'package:stem_shop/data/repositories/user/user_repository.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/shop/controllers/cart_controller.dart';
import 'package:stem_shop/features/shop/models/order_model.dart';
import 'package:stem_shop/utils/helpers/whatsapp_luncher.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class CheckoutGroupResult {
  final OrderModel order;
  final UserModel seller;
  final RxBool messageSent;

  CheckoutGroupResult({
    required this.order,
    required this.seller,
    bool messageSent = false,
  }) : messageSent = RxBool(messageSent);
}

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  final _orderRepository = OrderRepository.instance;
  final _userRepository = UserRepository.instance;

  final results = <CheckoutGroupResult>[].obs;
  final isProcessing = false.obs;

  Future<bool> checkoutCart() async {
    final cart = CartController.instance;
    final grouped = cart.groupedBySeller;

    if (grouped.isEmpty) {
      TLoaders.warningSnackBar(
        title: 'Cart Empty',
        message: 'Add items first.',
      );
      return false;
    }

    isProcessing.value = true;
    results.clear();

    final buyerId = UserController.instance.user.value.id;
    final succeededProductIds = <String>[];

    for (final entry in grouped.entries) {
      final sellerId = entry.key;
      final sellerItems = entry.value;
      final schoolId = sellerItems.first.schoolId;

      try {
        final order = await _orderRepository.placeSellerOrder(
          buyerId: buyerId,
          sellerId: sellerId,
          schoolId: schoolId,
          cartItems: sellerItems,
        );

        final seller = await _userRepository.fetchUserById(sellerId);

        results.add(CheckoutGroupResult(order: order, seller: seller));
        succeededProductIds.addAll(sellerItems.map((i) => i.productId));
      } catch (e) {
        TLoaders.errorSnackBar(title: 'Order Failed', message: e.toString());
      }
    }

    for (final productId in succeededProductIds) {
      cart.removeItem(productId);
    }

    isProcessing.value = false;
    return results.isNotEmpty;
  }

  Future<void> messageSeller(CheckoutGroupResult result) async {
    final order = result.order;
    final seller = result.seller;

    if (seller.phone.isEmpty) {
      TLoaders.errorSnackBar(
        title: 'No Phone Number',
        message: 'This seller has no phone number on file.',
      );
      return;
    }

    final itemLines = order.items
        .map(
          (i) => '\u2022 ${i.title} \u00d7 ${i.quantity} = ${i.totalPrice} EGP',
        )
        .join('\n');

    final message =
        'Hi! I\'d like to confirm this order (#${order.id.substring(0, 6)}):\n'
        '$itemLines\n'
        'Total: ${order.totalPrice} EGP\n'
        'Can you confirm these are still available?';

    final opened = await TWhatsAppLauncher.openChat(
      phone: seller.phone,
      message: message,
    );

    if (opened) {
      result.messageSent.value = true;
      await _orderRepository.markMessageSent(order.id);
    } else {
      TLoaders.warningSnackBar(
        title: 'WhatsApp not found',
        message: 'Could not open WhatsApp on this device.',
      );
    }
  }

  void reset() {
    results.clear();
  }
}
