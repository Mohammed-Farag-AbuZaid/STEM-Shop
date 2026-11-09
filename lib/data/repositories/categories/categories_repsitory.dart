import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stem_shop/data/services/cloudinary_storage_service.dart';
import 'package:stem_shop/features/shop/models/category_model.dart';
import 'package:stem_shop/utils/exceptions/firebase_exceptions.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  static const String _tfApiBaseUrl = 'https://n8n.tfunions.com/tf-api';
  final _db = FirebaseFirestore.instance;

  /// Get all categories (VPS API primary, Firestore fallback)
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final res = await http
          .get(Uri.parse('$_tfApiBaseUrl/api/collections/Categories'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final items = body['items'] as List<dynamic>? ?? [];
        if (items.isNotEmpty) {
          return items.map((item) {
            final d = Map<String, dynamic>.from(item as Map);
            return CategoryModel(
              id: (d['id'] ?? '').toString(),
              name: (d['name'] ?? '').toString(),
              image: (d['image'] ?? '').toString(),
              parentId: (d['parentId'] ?? '').toString(),
              isFeatured: d['isFeatured'] == true,
            );
          }).toList();
        }
      }
    } catch (_) {}

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
    final all = await getAllCategories();
    return all.where((c) => c.parentId == categoryId).toList();
  }

  /// Upload dummy data
  Future<void> uploadDummyData(List<CategoryModel> categories) async {
    try {
      final cloudinary = Get.put(TCloudinaryService());

      for (var category in categories) {
        if (category.image.isNotEmpty) {
          final byteData = await rootBundle.load(category.image);
          final imageBytes = byteData.buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          );
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
