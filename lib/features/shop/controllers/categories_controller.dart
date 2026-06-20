
import 'package:get/get.dart';
import 'package:stem_shop/data/repositories/categories/categories_repsitory.dart';
import 'package:stem_shop/features/shop/models/category_model.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class CategoriesController extends GetxController {
  static CategoriesController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  /// load the data
  Future<void> fetchCategories() async {
    try {
      /// Show Loader
      isLoading.value = true;

      /// Fetch Data
      final categories = await _categoryRepository.getAllCategories();

      /// Update the UI
      allCategories.assignAll(categories);

      /// Filter Featured Categories
      featuredCategories.assignAll(
        allCategories
            .where(
              (category) => category.isFeatured && category.parentId.isEmpty,
            )
            .take(8)
            .toList(),
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  final subcategoryCache = <String, List<CategoryModel>>{}.obs;

  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    if (subcategoryCache.containsKey(categoryId)) {
      return subcategoryCache[categoryId]!;
    }

    try {
      final subs = await _categoryRepository.getSubCategories(categoryId);
      subcategoryCache[categoryId] = subs;
      return subs;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
      return [];
    }
  }
}
