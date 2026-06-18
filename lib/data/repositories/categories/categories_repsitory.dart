import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stem_shop/data/services/cloudinary_storage_service.dart';
import 'package:stem_shop/features/shop/models/category_model.dart';
import 'package:stem_shop/utils/exceptions/firebase_exceptions.dart';

// Top-level function required by compute() — must be outside the class
Future<Uint8List> _loadAssetBytes(String path) async {
  final byteData = await rootBundle.load(path);
  return byteData.buffer.asUint8List(
    byteData.offsetInBytes,
    byteData.lengthInBytes,
  );
}

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// Get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection('Categories').get();
      return snapshot.docs
          .map((doc) => CategoryModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get subcategories for a given parent category
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final snapshot = await _db
          .collection('Categories')
          .where('parentId', isEqualTo: categoryId)
          .get();
      return snapshot.docs
          .map((doc) => CategoryModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Upload dummy data — run once from the settings screen
  Future<void> uploadDummyData(List<CategoryModel> categories) async {
  try {
    final cloudinary = Get.put(TCloudinaryService());

    for (var category in categories) {
      if (category.image.isNotEmpty) {
        // Load bytes on main thread (fast — local file read)
        final byteData = await rootBundle.load(category.image);
        final imageBytes = byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        );

        // Upload is async HTTP — doesn't block the UI
        final url = await cloudinary.uploadImageData(imageBytes);

        category.image = url;

        await Future.delayed(const Duration(milliseconds: 300));
      }

      await _db
          .collection('Categories')
          .doc(category.id)
          .set(category.toJson());
    }
  } on FirebaseException catch (e) {
    throw TFirebaseException(e.code).message;
  } catch (e) {
    throw 'Something went wrong. Please try again: $e';
  }
}
}