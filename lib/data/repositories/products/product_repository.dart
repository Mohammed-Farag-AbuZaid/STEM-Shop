import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/utils/exceptions/firebase_exceptions.dart';

class ProductRepository extends GetxService {
  static ProductRepository get instance => Get.find();

  static const String _tfApiBaseUrl = 'https://n8n.tfunions.com/tf-api';
  final _db = FirebaseFirestore.instance;

  ProductModel _fromMap(Map<String, dynamic> data) {
    final title = (data['title'] ?? '').toString();
    DateTime createdAt = DateTime.now();
    final rawCreated = data['createdAt'];
    if (rawCreated is String) {
      createdAt = DateTime.tryParse(rawCreated) ?? DateTime.now();
    } else if (rawCreated is Map && rawCreated['_seconds'] is num) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(
        ((rawCreated['_seconds'] as num) * 1000).toInt(),
      );
    }
    return ProductModel(
      id: (data['id'] ?? '').toString(),
      sellerId: (data['sellerId'] ?? '').toString(),
      schoolId: (data['schoolId'] ?? '').toString(),
      title: title,
      titleLowercase:
          (data['titleLowercase'] ?? title.toLowerCase()).toString(),
      description: (data['description'] ?? '').toString(),
      price: (data['price'] as num? ?? 0).toDouble(),
      marketPrice: (data['marketPrice'] as num? ?? 0).toDouble(),
      quantity: (data['quantity'] as num? ?? 0).toInt(),
      images: List<String>.from(data['images'] ?? []),
      categoryId: (data['categoryId'] ?? '').toString(),
      subCategoryId: (data['subCategoryId'] ?? '').toString(),
      condition: (data['condition'] ?? 'used').toString(),
      status: (data['status'] ?? 'available').toString(),
      createdAt: createdAt,
      onlineLink: data['onlineLink']?.toString(),
    );
  }

  Future<List<ProductModel>?> _fetchVpsProducts() async {
    try {
      final res = await http
          .get(Uri.parse('$_tfApiBaseUrl/api/collections/products'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final items = body['items'] as List<dynamic>? ?? [];
        return items
            .map((e) => _fromMap(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (_) {}
    return null;
  }

  Future<void> uploadDummyData(List<ProductModel> products) async {
    try {
      for (var product in products) {
        await _db.collection('products').doc(product.id).set(product.toJson());
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }

  Future<(List<ProductModel>, DocumentSnapshot?)> fetchProductsBySchool({
    required String schoolId,
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    final vps = await _fetchVpsProducts();
    if (vps != null && vps.isNotEmpty) {
      final filtered = vps
          .where((p) => p.schoolId == schoolId && p.status == 'available')
          .take(limit)
          .toList();
      return (filtered, null);
    }

    try {
      var query = _db
          .collection('products')
          .where('schoolId', isEqualTo: schoolId)
          .where('status', isEqualTo: 'available')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) query = query.startAfterDocument(lastDocument);

      final snapshot = await query.get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();

      final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      return (products, lastDoc);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }

  Future<(List<ProductModel>, DocumentSnapshot?)> fetchProductsBySubCategory({
    required String schoolId,
    required String subCategoryId,
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    final vps = await _fetchVpsProducts();
    if (vps != null && vps.isNotEmpty) {
      final filtered = vps
          .where((p) =>
              p.schoolId == schoolId &&
              p.subCategoryId == subCategoryId &&
              p.status == 'available')
          .take(limit)
          .toList();
      return (filtered, null);
    }

    try {
      var query = _db
          .collection('products')
          .where('schoolId', isEqualTo: schoolId)
          .where('subCategoryId', isEqualTo: subCategoryId)
          .where('status', isEqualTo: 'available')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) query = query.startAfterDocument(lastDocument);

      final snapshot = await query.get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();

      final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      return (products, lastDoc);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }

  Future<List<ProductModel>> fetchSubCategorySample({
    required String schoolId,
    required String subCategoryId,
  }) async {
    final vps = await _fetchVpsProducts();
    if (vps != null && vps.isNotEmpty) {
      return vps
          .where((p) =>
              p.schoolId == schoolId &&
              p.subCategoryId == subCategoryId &&
              p.status == 'available')
          .take(3)
          .toList();
    }

    try {
      final snapshot = await _db
          .collection('products')
          .where('schoolId', isEqualTo: schoolId)
          .where('subCategoryId', isEqualTo: subCategoryId)
          .where('status', isEqualTo: 'available')
          .limit(3)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }

  Future<String> addProduct(ProductModel product) async {
    try {
      final docRef = _db.collection('products').doc();
      final newProduct = product.copyWith(id: docRef.id);
      try {
        await http
            .put(
              Uri.parse('$_tfApiBaseUrl/api/collections/products/${docRef.id}'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                ...newProduct.toJson(),
                'createdAt': newProduct.createdAt.toIso8601String(),
              }),
            )
            .timeout(const Duration(seconds: 6));
      } catch (_) {}
      await docRef.set(newProduct.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }

  Future<List<ProductModel>> fetchUserProducts({
    required String sellerId,
  }) async {
    final vps = await _fetchVpsProducts();
    if (vps != null && vps.isNotEmpty) {
      return vps.where((p) => p.sellerId == sellerId).toList();
    }

    try {
      final snapshot = await _db
          .collection('products')
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }

  Future<void> updateProductField(
    String productId,
    Map<String, dynamic> fields,
  ) async {
    try {
      await http
          .put(
            Uri.parse('$_tfApiBaseUrl/api/collections/products/$productId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(fields),
          )
          .timeout(const Duration(seconds: 6));
    } catch (_) {}
    try {
      await _db.collection('products').doc(productId).update(fields);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await http
          .delete(Uri.parse('$_tfApiBaseUrl/api/collections/products/$productId'))
          .timeout(const Duration(seconds: 6));
    } catch (_) {}
    try {
      await _db.collection('products').doc(productId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await http
          .put(
            Uri.parse('$_tfApiBaseUrl/api/collections/products/${product.id}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              ...product.toJson(),
              'createdAt': product.createdAt.toIso8601String(),
            }),
          )
          .timeout(const Duration(seconds: 6));
    } catch (_) {}
    try {
      await _db.collection('products').doc(product.id).set(product.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }

  Future<ProductModel> fetchProductById(String productId) async {
    try {
      final res = await http
          .get(Uri.parse('$_tfApiBaseUrl/api/collections/products/$productId'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final data = (body['data'] as Map<String, dynamic>?) ?? body;
        return _fromMap({'id': productId, ...data});
      }
    } catch (_) {}

    final doc = await _db.collection('products').doc(productId).get();
    if (!doc.exists) return ProductModel.empty();
    return ProductModel.fromSnapshot(doc);
  }

  Future<List<ProductModel>> searchProducts({
    required String schoolId,
    required String query,
    int limit = 20,
  }) async {
    if (query.trim().isEmpty) return [];
    final normalized = query.trim().toLowerCase();

    final vps = await _fetchVpsProducts();
    if (vps != null && vps.isNotEmpty) {
      return vps
          .where((p) =>
              p.schoolId == schoolId &&
              p.status == 'available' &&
              p.titleLowercase.contains(normalized))
          .take(limit)
          .toList();
    }

    try {
      final snapshot = await _db
          .collection('products')
          .where('schoolId', isEqualTo: schoolId)
          .where('status', isEqualTo: 'available')
          .where('titleLowercase', isGreaterThanOrEqualTo: normalized)
          .where('titleLowercase', isLessThan: '$normalized\uf8ff')
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }
}
