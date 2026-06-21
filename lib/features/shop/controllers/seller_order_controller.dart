
import 'package:get/get.dart';
import 'package:stem_shop/data/repositories/products/order_repository.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/shop/models/order_model.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class SellerOrdersController extends GetxController {
  static SellerOrdersController get instance => Get.find();

  final _repository = OrderRepository.instance;

  final orders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final processingOrderIds = <String>{}.obs;

  String get _sellerId => UserController.instance.user.value.id;

  Future<void> fetchSellerOrders() async {
    if (_sellerId.isEmpty) return;
    try {
      isLoading.value = true;
      final result = await _repository.fetchOrdersBySeller(_sellerId);
      // Only show pending orders in the action list
      orders.assignAll(result.where((o) => o.status == 'pending').toList());
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmOrder(OrderModel order) async {
    if (processingOrderIds.contains(order.id)) return;
    try {
      processingOrderIds.add(order.id);
      await _repository.confirmOrder(order.id);
      orders.removeWhere((o) => o.id == order.id);
      TLoaders.successSnackBar(
        title: 'Confirmed',
        message: 'Order #${order.id.substring(0, 6)} confirmed.',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      processingOrderIds.remove(order.id);
    }
  }

  Future<void> declineOrder(OrderModel order) async {
    if (processingOrderIds.contains(order.id)) return;
    try {
      processingOrderIds.add(order.id);
      await _repository.declineOrder(orderId: order.id, items: order.items);
      orders.removeWhere((o) => o.id == order.id);
      TLoaders.successSnackBar(
        title: 'Declined',
        message: 'Order #${order.id.substring(0, 6)} declined. Stock restored.',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      processingOrderIds.remove(order.id);
    }
  }
}