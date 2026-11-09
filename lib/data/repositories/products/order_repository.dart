import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:stem_shop/features/shop/models/cart_item_model.dart';
import 'package:stem_shop/features/shop/models/order_model.dart';

class OrderException implements Exception {
  final String message;
  OrderException(this.message);
  @override
  String toString() => message;
}

class OrderRepository {
  static OrderRepository instance = OrderRepository();

  static const String _tfApiBaseUrl = 'https://n8n.tfunions.com/tf-api';
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  OrderModel _fromMap(Map<String, dynamic> data) {
    DateTime createdAt = DateTime.now();
    final rawCreated = data['createdAt'];
    if (rawCreated is String) {
      createdAt = DateTime.tryParse(rawCreated) ?? DateTime.now();
    } else if (rawCreated is Map && rawCreated['_seconds'] is num) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(
        ((rawCreated['_seconds'] as num) * 1000).toInt(),
      );
    }
    return OrderModel(
      id: (data['id'] ?? '').toString(),
      buyerId: (data['buyerId'] ?? '').toString(),
      sellerId: (data['sellerId'] ?? '').toString(),
      schoolId: (data['schoolId'] ?? '').toString(),
      items: ((data['items'] as List<dynamic>?) ?? [])
          .map((e) => OrderLineItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      status: (data['status'] ?? 'pending').toString(),
      messageSent: data['messageSent'] == true,
      createdAt: createdAt,
    );
  }

  Future<List<OrderModel>?> _fetchVpsOrders() async {
    try {
      final res = await http
          .get(Uri.parse('$_tfApiBaseUrl/api/collections/orders'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final items = body['items'] as List<dynamic>? ?? [];
        return items
            .map((e) => _fromMap(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
    } catch (_) {}
    return null;
  }

  Future<OrderModel> placeSellerOrder({
    required String buyerId,
    required String sellerId,
    required String schoolId,
    required List<CartItem> cartItems,
  }) async {
    if (cartItems.isEmpty) {
      throw OrderException('No items to order.');
    }

    final orderRef = _db.collection('orders').doc();
    final productRefs = {
      for (final item in cartItems)
        item.productId: _db.collection('products').doc(item.productId),
    };

    return _db.runTransaction<OrderModel>((transaction) async {
      final snapshots = <String, DocumentSnapshot<Map<String, dynamic>>>{};
      for (final entry in productRefs.entries) {
        snapshots[entry.key] = await transaction.get(entry.value);
      }

      for (final item in cartItems) {
        final snap = snapshots[item.productId]!;
        if (!snap.exists) {
          throw OrderException('"${item.title}" no longer exists.');
        }

        final data = snap.data()!;
        final currentQuantity = (data['quantity'] as num? ?? 0).toInt();
        final currentStatus = data['status'] ?? 'available';

        if (currentStatus != 'available') {
          throw OrderException('"${item.title}" is no longer available.');
        }

        if (item.quantity > currentQuantity) {
          throw OrderException(
            'Only $currentQuantity left of "${item.title}" — someone may have just ordered some.',
          );
        }
      }

      final lineItems = <OrderLineItem>[];
      for (final item in cartItems) {
        final snap = snapshots[item.productId]!;
        final data = snap.data()!;
        final currentQuantity = (data['quantity'] as num? ?? 0).toInt();
        final remaining = currentQuantity - item.quantity;

        transaction.update(productRefs[item.productId]!, {
          'quantity': remaining,
          if (remaining == 0) 'status': 'sold',
        });

        lineItems.add(OrderLineItem(
          productId: item.productId,
          title: item.title,
          price: item.price,
          quantity: item.quantity,
        ));
      }

      final order = OrderModel(
        id: orderRef.id,
        buyerId: buyerId,
        sellerId: sellerId,
        schoolId: schoolId,
        items: lineItems,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      transaction.set(orderRef, order.toJson());
      return order;
    }).then((order) async {
      try {
        await http
            .put(
              Uri.parse('$_tfApiBaseUrl/api/collections/orders/${order.id}'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'buyerId': order.buyerId,
                'sellerId': order.sellerId,
                'schoolId': order.schoolId,
                'items': order.items.map((i) => i.toJson()).toList(),
                'status': order.status,
                'messageSent': order.messageSent,
                'createdAt': order.createdAt.toIso8601String(),
              }),
            )
            .timeout(const Duration(seconds: 6));
      } catch (_) {}
      return order;
    });
  }

  Future<void> markMessageSent(String orderId) async {
    try {
      await http
          .put(
            Uri.parse('$_tfApiBaseUrl/api/collections/orders/$orderId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'messageSent': true}),
          )
          .timeout(const Duration(seconds: 6));
    } catch (_) {}
    await _db.collection('orders').doc(orderId).update({'messageSent': true});
  }

  Future<List<OrderModel>> fetchOrdersByBuyer(String buyerId) async {
    final vps = await _fetchVpsOrders();
    if (vps != null && vps.isNotEmpty) {
      return vps.where((o) => o.buyerId == buyerId).toList();
    }

    final snapshot = await _db
        .collection('orders')
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
  }

  Future<List<OrderModel>> fetchOrdersBySeller(String sellerId) async {
    final vps = await _fetchVpsOrders();
    if (vps != null && vps.isNotEmpty) {
      return vps.where((o) => o.sellerId == sellerId).toList();
    }

    final snapshot = await _db
        .collection('orders')
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
  }

  Future<void> confirmOrder(String orderId) async {
    try {
      await http
          .put(
            Uri.parse('$_tfApiBaseUrl/api/collections/orders/$orderId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'status': 'confirmed'}),
          )
          .timeout(const Duration(seconds: 6));
    } catch (_) {}
    await _db.collection('orders').doc(orderId).update({'status': 'confirmed'});
  }

  Future<void> declineOrder({
    required String orderId,
    required List<OrderLineItem> items,
  }) async {
    try {
      await http
          .put(
            Uri.parse('$_tfApiBaseUrl/api/collections/orders/$orderId'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'status': 'cancelled'}),
          )
          .timeout(const Duration(seconds: 6));
    } catch (_) {}

    await _db.runTransaction((transaction) async {
      final productRefs = {
        for (final item in items)
          item.productId: _db.collection('products').doc(item.productId),
      };

      final snapshots = <String, DocumentSnapshot>{};
      for (final entry in productRefs.entries) {
        snapshots[entry.key] = await transaction.get(entry.value);
      }

      for (final item in items) {
        final snap = snapshots[item.productId]!;
        if (!snap.exists) continue;

        final data = snap.data()! as Map<String, dynamic>;
        final currentQty = (data['quantity'] as num? ?? 0).toInt();
        final restoredQty = currentQty + item.quantity;

        transaction.update(productRefs[item.productId]!, {
          'quantity': restoredQty,
          'status': 'available',
        });
      }

      transaction.update(
        _db.collection('orders').doc(orderId),
        {'status': 'cancelled'},
      );
    });
  }
}
