import 'package:cloud_firestore/cloud_firestore.dart';

class OrderLineItem {
  final String productId;
  final String title;
  final double price;
  final int quantity;

  OrderLineItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'title': title,
        'price': price,
        'quantity': quantity,
      };

  factory OrderLineItem.fromJson(Map<String, dynamic> json) => OrderLineItem(
        productId: json['productId'] ?? '',
        title: json['title'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        quantity: (json['quantity'] as num? ?? 0).toInt(),
      );
}

class OrderModel {
  final String id;
  final String buyerId;
  final String sellerId;
  final String schoolId;
  final List<OrderLineItem> items;
  final String status; // pending / confirmed / cancelled / completed
  final bool messageSent; // whether buyer has opened WhatsApp for this order
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.schoolId,
    required this.items,
    required this.status,
    required this.createdAt,
    this.messageSent = false,
  });

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  int get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toJson() => {
        'buyerId': buyerId,
        'sellerId': sellerId,
        'schoolId': schoolId,
        'items': items.map((i) => i.toJson()).toList(),
        'status': status,
        'messageSent': messageSent,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory OrderModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return OrderModel(
      id: doc.id,
      buyerId: data['buyerId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      schoolId: data['schoolId'] ?? '',
      items: ((data['items'] as List<dynamic>?) ?? [])
          .map((e) => OrderLineItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      status: data['status'] ?? 'pending',
      messageSent: data['messageSent'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}