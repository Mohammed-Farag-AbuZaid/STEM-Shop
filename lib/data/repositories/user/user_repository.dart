import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stem_shop/data/repositories/user/user_model.dart';

class UserRepository extends GetxController {
static UserRepository get instance => Get.find();

final FirebaseFirestore _db = FirebaseFirestore.instance;

/// Function to save user data to Firestore.
Future<void> saveUserRecord(UserModel user) async {
try {
await _db.collection("Users").doc(user.id).set(user.toJson());
} on FirebaseException catch (e) {
throw 'Firebase error: ${e.code}';
} on FormatException catch (_) {
throw 'Invalid data format.';
} on PlatformException catch (e) {
throw 'Platform error: ${e.code}';
} catch (e) {
throw 'Something went wrong. Please try again';
}
}
}