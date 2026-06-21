import 'package:get/get.dart';
import 'package:stem_shop/data/repositories/products/order_repository.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/shop/models/order_model.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class OrdersController extends GetxController {
  static OrdersController get instance => Get.find();

  final _repository = OrderRepository.instance;

  final orders = <OrderModel>[].obs;
  final ordersLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyOrders();
  }


Future<void> fetchMyOrders() async {
  final buyerId = UserController.instance.user.value.id;
  if (buyerId.isEmpty) return; 

  try {
    ordersLoading.value = true;
    final result = await _repository.fetchOrdersByBuyer(buyerId);
    orders.assignAll(result);
  } catch (e) {
    TLoaders.errorSnackBar(title: 'Error', message: e.toString());
  } finally {
    ordersLoading.value = false;
  }
}
}
