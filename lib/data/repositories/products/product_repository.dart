import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/utils/exceptions/firebase_exceptions.dart';

class ProductRepository extends GetxService {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> uploadDummyData(List<ProductModel> products) async {
    try {
      for (var product in products) {
        await _db
            .collection('products')
            .doc(product.id)
            .set(product.toJson());
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
}