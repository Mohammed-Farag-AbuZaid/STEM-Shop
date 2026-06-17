import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:stem_shop/features/shop/models/category_model.dart';
import 'package:stem_shop/utils/exceptions/firebase_exceptions.dart';

class CategoryRepository extends GetxController {
static CategoryRepository get instance => Get.find();

/// Variables
final _db = FirebaseFirestore.instance;

/// Get all categories
Future<List<CategoryModel>> getAllCategories() async {
try{
final snapshot = await _db.collection('Categories').get();
final list = snapshot.docs.map((document) => CategoryModel.fromSnapshot(document)).toList();
return list;
} on FirebaseException catch (e) {
throw TFirebaseException(e.code).message;
}catch (e) {
throw 'Something went wrong. Please try again';

/// Get Sub Categories

/// Upload Categories to the Cloud Firebase

}
}
}