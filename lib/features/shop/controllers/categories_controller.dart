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

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      final categories = await _categoryRepository.getAllCategories();

      allCategories.assignAll(categories);

      featuredCategories.assignAll(
        allCategories
            .where(
              (category) => category.isFeatured && category.parentId.isEmpty,
            )
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
