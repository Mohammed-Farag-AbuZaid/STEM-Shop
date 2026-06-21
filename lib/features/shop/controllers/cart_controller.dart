import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stem_shop/features/shop/models/cart_item_model.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  static const _storageKey = 'cart_items';

  final _storage = GetStorage();
  final items = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  int get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  Map<String, List<CartItem>> get groupedBySeller {
    final map = <String, List<CartItem>>{};
    for (final item in items) {
      map.putIfAbsent(item.sellerId, () => []).add(item);
    }
    return map;
  }

  void addProduct(ProductModel product, {int quantity = 1}) {
    final existingIndex =
        items.indexWhere((item) => item.productId == product.id);

    if (existingIndex != -1) {
      final existing = items[existingIndex];
      final newQuantity = existing.quantity + quantity;
      if (newQuantity > product.quantity) {
        TLoaders.warningSnackBar(
          title: 'Limited Stock',
          message: 'Only ${product.quantity} of this item available.',
        );
        return;
      }
      existing.quantity = newQuantity;
      items[existingIndex] = existing;
    } else {
      if (quantity > product.quantity) {
        TLoaders.warningSnackBar(
          title: 'Limited Stock',
          message: 'Only ${product.quantity} of this item available.',
        );
        return;
      }
      items.add(CartItem.fromProduct(product, quantity: quantity));
    }

    _saveToStorage();

    TLoaders.successSnackBar(
      title: 'Added to Cart',
      message: '${product.title} \u00d7 $quantity',
    );
  }

  void updateQuantity(String productId, int quantity) {
    final index = items.indexWhere((item) => item.productId == productId);
    if (index == -1) return;

    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final item = items[index];
    if (quantity > item.maxQuantity) {
      TLoaders.warningSnackBar(
        title: 'Limited Stock',
        message: 'Only ${item.maxQuantity} available.',
      );
      return;
    }

    item.quantity = quantity;
    items[index] = item;
    _saveToStorage();
  }

  void removeItem(String productId) {
    items.removeWhere((item) => item.productId == productId);
    _saveToStorage();
  }

  void clearCart() {
    items.clear();
    _saveToStorage();
  }

  void _saveToStorage() {
    final jsonList = items.map((item) => item.toJson()).toList();
    _storage.write(_storageKey, jsonList);
  }

  void _loadFromStorage() {
    final stored = _storage.read<List<dynamic>>(_storageKey);
    if (stored == null) return;

    try {
      items.assignAll(
        stored.map((json) => CartItem.fromJson(Map<String, dynamic>.from(json))),
      );
    } catch (_) {
      // corrupted cache — start fresh rather than crash
      items.clear();
    }
  }

}