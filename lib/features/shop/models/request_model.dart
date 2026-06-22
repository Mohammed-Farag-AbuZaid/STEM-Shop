import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String id;
  final String requesterId;
  final String schoolId;
  final String scope; 
  final String title;
  final String description;
  final String category;
  final double budget;
  final String status;
  final DateTime createdAt;

  RequestModel({
    required this.id,
    required this.requesterId,
    required this.schoolId,
    required this.scope,
    required this.title,
    required this.description,
    required this.category,
    required this.budget,
    required this.status,
    required this.createdAt,
  });

  static RequestModel empty() => RequestModel(
        id: '',
        requesterId: '',
        schoolId: '',
        scope: 'my_school',
        title: '',
        description: '',
        category: '',
        budget: 0.0,
        status: 'open',
        createdAt: DateTime.now(),
      );

  RequestModel copyWith({
    String? id,
    String? requesterId,
    String? schoolId,
    String? scope,
    String? title,
    String? description,
    String? category,
    double? budget,
    String? status,
    DateTime? createdAt,
  }) {
    return RequestModel(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      schoolId: schoolId ?? this.schoolId,
      scope: scope ?? this.scope,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      budget: budget ?? this.budget,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'requesterId': requesterId,
        'schoolId': schoolId,
        'scope': scope,
        'title': title,
        'description': description,
        'category': category,
        'budget': budget,
        'status': status,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory RequestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.data() == null) return RequestModel.empty();
    final data = doc.data()!;
    return RequestModel(
      id: doc.id,
      requesterId: data['requesterId'] ?? '',
      schoolId: data['schoolId'] ?? '',
      scope: data['scope'] ?? 'my_school',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      budget: (data['budget'] ?? 0).toDouble(),
      status: data['status'] ?? 'open',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory RequestModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return RequestModel.fromSnapshot(doc);
  }
}