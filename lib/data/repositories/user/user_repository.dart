import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stem_shop/data/repositories/user/user_model.dart';

class UserRepository extends GetxService {
  static UserRepository get instance => Get.find();

  FirebaseFirestore get _db => FirebaseFirestore.instance;

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
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return UserModel.empty();

      final documentSnapshot = await _db.collection("Users").doc(uid).get();

      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      }
      return UserModel.empty();
    } on FirebaseException catch (e) {
      throw 'Firebase error: ${e.code}';
    } on FormatException catch (_) {
      throw 'Invalid data format.';
    } on PlatformException catch (e) {
      throw 'Platform error: ${e.code}';
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> updateUserFields(
    String id,
    Map<String, dynamic> updatedFields,
  ) async {
    try {
      await _db.collection("Users").doc(id).update(updatedFields);
    } on FirebaseException catch (e) {
      throw 'Firebase error: ${e.code}';
    } on FormatException catch (_) {
      throw 'Invalid data format.';
    } on PlatformException catch (e) {
      throw 'Platform error: ${e.code}';
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}
