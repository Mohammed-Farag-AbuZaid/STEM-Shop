import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:stem_shop/features/shop/models/request_model.dart';
import 'package:stem_shop/utils/exceptions/firebase_exceptions.dart';

class RequestRepository extends GetxService {
  static RequestRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> addRequest(RequestModel request) async {
    try {
      final docRef = _db.collection('requests').doc();
      final newRequest = request.copyWith(id: docRef.id);
      await docRef.set(newRequest.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }

  Future<List<RequestModel>> fetchVisibleRequests({
    required String schoolId,
    String scopeFilter = 'all',
  }) async {
    try {
      List<RequestModel> requests = [];

      if (scopeFilter == 'school') {
        final snapshot = await _db
            .collection('requests')
            .where('schoolId', isEqualTo: schoolId)
            .where('scope', isEqualTo: 'my_school')
            .where('status', isEqualTo: 'open')
            .orderBy('createdAt', descending: true)
            .get();

        requests =
            snapshot.docs.map((d) => RequestModel.fromQuerySnapshot(d)).toList();
      } else {
        final mySchoolQuery = _db
            .collection('requests')
            .where('schoolId', isEqualTo: schoolId)
            .where('scope', isEqualTo: 'my_school')
            .where('status', isEqualTo: 'open')
            .orderBy('createdAt', descending: true)
            .get();

        final allSchoolsQuery = _db
            .collection('requests')
            .where('scope', isEqualTo: 'all_schools')
            .where('status', isEqualTo: 'open')
            .orderBy('createdAt', descending: true)
            .get();

        final results = await Future.wait([mySchoolQuery, allSchoolsQuery]);

        requests = [
          ...results[0].docs.map((d) => RequestModel.fromQuerySnapshot(d)),
          ...results[1].docs.map((d) => RequestModel.fromQuerySnapshot(d)),
        ];

        requests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }

      return requests;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }

  Future<void> deleteRequest(String requestId) async {
    try {
      await _db.collection('requests').doc(requestId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }
}