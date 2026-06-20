import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String sellerId;
  final String schoolId;
  final String title;
  final String description;
  final double price;
  final double marketPrice;
  final int quantity;
  final List<String> images;
  final String categoryId;
  final String subCategoryId;
  final String condition;
  final String status;
  final DateTime createdAt;
  final String? onlineLink;

  ProductModel({
    required this.id,
    required this.sellerId,
    required this.schoolId,
    required this.title,
    required this.description,
    required this.price,
    required this.marketPrice,
    required this.images,
    required this.categoryId,
    required this.subCategoryId,
    required this.condition,
    required this.status,
    required this.createdAt,
    this.quantity = 0,
    this.onlineLink,
  });

  static ProductModel empty() => ProductModel(
        id: '',
        sellerId: '',
        schoolId: '',
        title: '',
        description: '',
        price: 0.0,
        marketPrice: 0.0,
        quantity: 0,
        images: [],
        categoryId: '',
        subCategoryId: '',
        condition: 'used',
        status: 'available',
        createdAt: DateTime.now(),
        onlineLink: null,
      );

  String get thumbnail => images.isNotEmpty ? images.first : '';

  bool get hasOnlineLink => onlineLink != null && onlineLink!.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'id': id,
        'sellerId': sellerId,
        'schoolId': schoolId,
        'title': title,
        'description': description,
        'price': price,
        'marketPrice': marketPrice,
        'quantity': quantity,
        'images': images,
        'categoryId': categoryId,
        'subCategoryId': subCategoryId,
        'condition': condition,
        'status': status,
        'createdAt': Timestamp.fromDate(createdAt),
        'onlineLink': onlineLink,
      };

  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc.data() == null) return ProductModel.empty();
    final data = doc.data()!;
    return ProductModel(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      schoolId: data['schoolId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      marketPrice: (data['marketPrice'] ?? 0).toDouble(),
      quantity: (data['quantity'] as num? ?? 0).toInt(),
      images: List<String>.from(data['images'] ?? []),
      categoryId: data['categoryId'] ?? '',
      subCategoryId: data['subCategoryId'] ?? '',
      condition: data['condition'] ?? 'used',
      status: data['status'] ?? 'available',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      onlineLink: data['onlineLink'] as String?,
    );
  }

  factory ProductModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return ProductModel.fromSnapshot(doc);
  }
}