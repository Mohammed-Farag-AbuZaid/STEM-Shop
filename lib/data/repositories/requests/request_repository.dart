import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stem_shop/features/shop/models/request_model.dart';
import 'package:stem_shop/utils/exceptions/firebase_exceptions.dart';

class RequestRepository extends GetxService {
  static RequestRepository get instance => Get.find();

  static const String _tfApiBaseUrl = 'https://n8n.tfunions.com/tf-api';
  final _db = FirebaseFirestore.instance;

  Future<String> addRequest(RequestModel request) async {
    try {
      final docRef = _db.collection('requests').doc();
      final newRequest = request.copyWith(id: docRef.id);
      try {
        await http
            .put(
              Uri.parse('$_tfApiBaseUrl/api/collections/requests/${docRef.id}'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                ...newRequest.toJson(),
                'createdAt': newRequest.createdAt.toIso8601String(),
              }),
            )
            .timeout(const Duration(seconds: 6));
      } catch (_) {}
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
      final res = await http
          .get(Uri.parse('$_tfApiBaseUrl/api/collections/requests'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final items = body['items'] as List<dynamic>? ?? [];
        if (items.isNotEmpty) {
          final parsed = <RequestModel>[];
          for (final raw in items) {
            final d = Map<String, dynamic>.from(raw as Map);
            DateTime createdAt = DateTime.now();
            final rawCreated = d['createdAt'];
            if (rawCreated is String) {
              createdAt = DateTime.tryParse(rawCreated) ?? DateTime.now();
            } else if (rawCreated is Map && rawCreated['_seconds'] is num) {
              createdAt = DateTime.fromMillisecondsSinceEpoch(
                ((rawCreated['_seconds'] as num) * 1000).toInt(),
              );
            }
            final req = RequestModel(
              id: (d['id'] ?? '').toString(),
              requesterId: (d['requesterId'] ?? '').toString(),
              schoolId: (d['schoolId'] ?? '').toString(),
              title: (d['title'] ?? '').toString(),
              description: (d['description'] ?? '').toString(),
              categoryId: (d['categoryId'] ?? '').toString(),
              subCategoryId: (d['subCategoryId'] ?? '').toString(),
              maxBudget: (d['maxBudget'] as num?)?.toDouble(),
              scope: (d['scope'] ?? 'my_school').toString(),
              status: (d['status'] ?? 'open').toString(),
              createdAt: createdAt,
            );
            if (req.status == 'open') {
              if (scopeFilter == 'school' &&
                  req.schoolId == schoolId &&
                  req.scope == 'my_school') {
                parsed.add(req);
              } else if (scopeFilter != 'school' &&
                  ((req.schoolId == schoolId && req.scope == 'my_school') ||
                      req.scope == 'all_schools')) {
                parsed.add(req);
              }
            }
          }
          parsed.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return parsed;
        }
      }
    } catch (_) {}

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
      await http
          .delete(Uri.parse('$_tfApiBaseUrl/api/collections/requests/$requestId'))
          .timeout(const Duration(seconds: 6));
    } catch (_) {}
    try {
      await _db.collection('requests').doc(requestId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }
}
