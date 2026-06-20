import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/data/repositories/products/product_repository.dart';
import 'package:stem_shop/utils/popups/loaders.dart';
import 'package:stem_shop/data/repositories/user/user_model.dart';
import 'package:stem_shop/data/repositories/user/user_repository.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final _repository = Get.find<ProductRepository>();
  final _userRepository = UserRepository.instance;

  final homeProducts = <ProductModel>[].obs;
  final homeLoading = false.obs;

  final subcategorySampleCache = <String, List<ProductModel>>{}.obs;

  // seller info cache + state
  final sellerCache = <String, UserModel>{};
  final seller = Rx<UserModel?>(null);
  final sellerLoading = false.obs;

  final paginatedProducts = <ProductModel>[].obs;
  final paginationLoading = false.obs;
  final hasMoreProducts = true.obs;
  DocumentSnapshot? _lastDocument;
  String? _activePaginationSubCategoryId;

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
}
