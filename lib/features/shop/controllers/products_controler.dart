import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stem_shop/data/repositories/products/order_repository.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/shop/controllers/order_controller.dart';
import 'package:stem_shop/features/shop/models/cart_item_model.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/data/repositories/products/product_repository.dart';
import 'package:stem_shop/data/repositories/user/user_model.dart';
import 'package:stem_shop/data/repositories/user/user_repository.dart';

import 'package:stem_shop/utils/helpers/whatsapp_luncher.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final _repository = Get.find<ProductRepository>();
  final _userRepository = UserRepository.instance;
  final _orderRepository = OrderRepository.instance;

  final homeProducts = <ProductModel>[].obs;
  final homeLoading = false.obs;

  final subcategorySampleCache = <String, List<ProductModel>>{}.obs;

  final paginatedProducts = <ProductModel>[].obs;
  final paginationLoading = false.obs;
  final hasMoreProducts = true.obs;
  DocumentSnapshot? _lastDocument;
  String? _activePaginationSubCategoryId;

  final sellerCache = <String, UserModel>{};
  final seller = Rx<UserModel?>(null);
  final sellerLoading = false.obs;

  final activeProduct = Rx<ProductModel?>(null);

  final placingOrder = false.obs;

  final searchResults = <ProductModel>[].obs;
  final searchLoading = false.obs;

  String get _schoolId => UserController.instance.user.value.stemSchool;

  @override
  void onInit() {
    super.onInit();
    final user = UserController.instance.user;

    if (user.value.stemSchool.isNotEmpty) {
      fetchHomeProducts();
    } else {
      ever(user, (u) {
        if (u.stemSchool.isNotEmpty && homeProducts.isEmpty) {
          fetchHomeProducts();
        }
      });
    }
  }

  Future<void> fetchHomeProducts() async {
    try {
      homeLoading.value = true;
      final (products, _) = await _repository.fetchProductsBySchool(
        schoolId: _schoolId,
        limit: 10,
      );
      homeProducts.assignAll(products);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      homeLoading.value = false;
    }
  }

  Future<List<ProductModel>> getSubCategorySample(String subCategoryId) async {
    if (subcategorySampleCache.containsKey(subCategoryId)) {
      return subcategorySampleCache[subCategoryId]!;
    }

    try {
      final products = await _repository.fetchSubCategorySample(
        schoolId: _schoolId,
        subCategoryId: subCategoryId,
      );
      subcategorySampleCache[subCategoryId] = products;
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
      return [];
    }
  }

  Future<void> startPagination({String? subCategoryId}) async {
    if (_activePaginationSubCategoryId == subCategoryId &&
        paginatedProducts.isNotEmpty) {
      return;
    }

    _activePaginationSubCategoryId = subCategoryId;
    _lastDocument = null;
    hasMoreProducts.value = true;
    paginatedProducts.clear();

    await _fetchNextPage(subCategoryId: subCategoryId);
  }

  Future<void> loadMoreProducts() async {
    if (!hasMoreProducts.value || paginationLoading.value) return;
    await _fetchNextPage(subCategoryId: _activePaginationSubCategoryId);
  }

  Future<void> _fetchNextPage({String? subCategoryId}) async {
    try {
      paginationLoading.value = true;

      final (products, lastDoc) = subCategoryId != null
          ? await _repository.fetchProductsBySubCategory(
              schoolId: _schoolId,
              subCategoryId: subCategoryId,
              lastDocument: _lastDocument,
            )
          : await _repository.fetchProductsBySchool(
              schoolId: _schoolId,
              lastDocument: _lastDocument,
            );

      if (products.length < 10) hasMoreProducts.value = false;
      if (products.isNotEmpty) {
        _lastDocument = lastDoc;
        paginatedProducts.addAll(products);
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      paginationLoading.value = false;
    }
  }

  Future<void> refreshAll() async {
    subcategorySampleCache.clear();
    homeProducts.clear();
    paginatedProducts.clear();
    _lastDocument = null;
    await fetchHomeProducts();
  }

  Future<void> loadSeller(String sellerId) async {
    if (sellerId.isEmpty) {
      seller.value = null;
      return;
    }

    if (sellerCache.containsKey(sellerId)) {
      seller.value = sellerCache[sellerId];
      return;
    }

    try {
      sellerLoading.value = true;
      final user = await _userRepository.fetchUserById(sellerId);
      sellerCache[sellerId] = user;
      seller.value = user;
    } catch (e) {
      seller.value = UserModel.empty();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      sellerLoading.value = false;
    }
  }

  void setActiveProduct(ProductModel product) {
    if (activeProduct.value?.id == product.id && activeProduct.value != null) {
      return;
    }
    activeProduct.value = product;
  }

  Future<void> refreshActiveProduct(String productId) async {
    try {
      final updated = await _repository.fetchProductById(productId);
      activeProduct.value = updated;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }


  Future<bool> placeOrder(ProductModel product, int quantity) async {
    try {
      placingOrder.value = true;

      await loadSeller(product.sellerId);
      final sellerUser = seller.value;
      if (sellerUser == null || sellerUser.phone.isEmpty) {
        TLoaders.errorSnackBar(
          title: 'Error',
          message: 'Seller phone number is not available.',
        );
        return false;
      }

      final order = await _orderRepository.placeSellerOrder(
        buyerId: UserController.instance.user.value.id,
        sellerId: product.sellerId,
        schoolId: product.schoolId,
        cartItems: [
          CartItem.fromProduct(product, quantity: quantity),
        ],
      );

      await refreshActiveProduct(product.id);

      final message =
          'Hi! I\'d like to confirm this order (#${order.id.substring(0, 6)}):\n'
          '\u2022 ${product.title} \u00d7 $quantity = ${order.totalPrice} EGP\n'
          'Can you confirm it\'s still available?';

      final opened = await TWhatsAppLauncher.openChat(
        phone: sellerUser.phone,
        message: message,
      );

      if (!opened) {
        TLoaders.warningSnackBar(
          title: 'WhatsApp not found',
          message: 'Order was placed, but WhatsApp could not be opened.',
        );
      } else {
        await _orderRepository.markMessageSent(order.id);
        OrdersController.instance.fetchMyOrders();
      }

      return true;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Order Failed', message: e.toString());
      return false;
    } finally {
      placingOrder.value = false;
    }
  }

  Future<void> searchProducts(String query) async {
  if (query.trim().isEmpty) {
    searchResults.clear();
    return;
  }
  try {
    searchLoading.value = true;
    final results = await _repository.searchProducts(
      schoolId: _schoolId,
      query: query,
    );
    searchResults.assignAll(results);
  } catch (e) {
    TLoaders.errorSnackBar(title: 'Search Error', message: e.toString());
  } finally {
    searchLoading.value = false;
  }
}

void clearSearch() => searchResults.clear();
}
