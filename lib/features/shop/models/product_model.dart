import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String sellerId;
  final String schoolId;
  final String title;
  final String titleLowercase;
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
    this.titleLowercase = '',
    this.quantity = 0,
    this.onlineLink,
  });

  static ProductModel empty() => ProductModel(
        id: '',
        sellerId: '',
        schoolId: '',
        title: '',
        titleLowercase: '',
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

  /// Use this factory everywhere instead of the raw constructor when
  /// creating a new product — it auto-computes [titleLowercase] so
  /// the Firestore search query always has the right field to query.
  factory ProductModel.create({
    required String id,
    required String sellerId,
    required String schoolId,
    required String title,
    required String description,
    required double price,
    required double marketPrice,
    required int quantity,
    required List<String> images,
    required String categoryId,
    required String subCategoryId,
    required String condition,
    required String status,
    required DateTime createdAt,
    String? onlineLink,
  }) {
    return ProductModel(
      id: id,
      sellerId: sellerId,
      schoolId: schoolId,
      title: title,
      titleLowercase: title.toLowerCase(),
      description: description,
      price: price,
      marketPrice: marketPrice,
      quantity: quantity,
      images: images,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      condition: condition,
      status: status,
      createdAt: createdAt,
      onlineLink: onlineLink,
    );
  }

  String get thumbnail => images.isNotEmpty ? images.first : '';

  bool get hasOnlineLink => onlineLink != null && onlineLink!.isNotEmpty;

  ProductModel copyWith({
    String? id,
    String? sellerId,
    String? schoolId,
    String? title,
    String? titleLowercase,
    String? description,
    double? price,
    double? marketPrice,
    int? quantity,
    List<String>? images,
    String? categoryId,
    String? subCategoryId,
    String? condition,
    String? status,
    DateTime? createdAt,
    String? onlineLink,
  }) {
    final newTitle = title ?? this.title;
    return ProductModel(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      schoolId: schoolId ?? this.schoolId,
      title: newTitle,
      titleLowercase: titleLowercase ?? (title != null
          ? newTitle.toLowerCase()
          : this.titleLowercase),
      description: description ?? this.description,
      price: price ?? this.price,
      marketPrice: marketPrice ?? this.marketPrice,
      quantity: quantity ?? this.quantity,
      images: images ?? this.images,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      condition: condition ?? this.condition,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      onlineLink: onlineLink ?? this.onlineLink,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sellerId': sellerId,
        'schoolId': schoolId,
        'title': title,
        'titleLowercase': titleLowercase,
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
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    if (doc.data() == null) return ProductModel.empty();
    final data = doc.data()!;
    final title = data['title'] as String? ?? '';
    return ProductModel(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      schoolId: data['schoolId'] ?? '',
      title: title,
      titleLowercase: data['titleLowercase'] as String? ?? title.toLowerCase(),
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
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return ProductModel.fromSnapshot(doc);
  }
}