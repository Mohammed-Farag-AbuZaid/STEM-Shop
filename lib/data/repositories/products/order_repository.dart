import 'package:cloud_firestore/cloud_firestore.dart';
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

  FirebaseFirestore get _db => FirebaseFirestore.instance;

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
            'Only $currentQuantity left of "${item.title}" \u2014 someone may have just ordered some.',
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
        await orderRef.get(const GetOptions(source: Source.server));
      } catch (e) {
        throw OrderException(
          'Order could not be confirmed with the server. Please check your connection and try again.',
        );
      }
      return order;
    });
  }

  Future<void> markMessageSent(String orderId) async {
    await _db.collection('orders').doc(orderId).update({'messageSent': true});
  }

  Future<List<OrderModel>> fetchOrdersByBuyer(String buyerId) async {
    final snapshot = await _db
        .collection('orders')
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
  }

  /// Fetches all orders where this user is the seller, pending confirmation.
Future<List<OrderModel>> fetchOrdersBySeller(String sellerId) async {
  final snapshot = await _db
      .collection('orders')
      .where('sellerId', isEqualTo: sellerId)
      .orderBy('createdAt', descending: true)
      .get();

  return snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
}

Future<void> confirmOrder(String orderId) async {
  await _db.collection('orders').doc(orderId).update({'status': 'confirmed'});
}

Future<void> declineOrder({
  required String orderId,
  required List<OrderLineItem> items,
}) async {
  await _db.runTransaction((transaction) async {
    // Read all product docs first
    final productRefs = {
      for (final item in items)
        item.productId: _db.collection('products').doc(item.productId),
    };

    final snapshots = <String, DocumentSnapshot>{};
    for (final entry in productRefs.entries) {
      snapshots[entry.key] = await transaction.get(entry.value);
    }

    // Restore quantity and status for each product
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

    // Mark order as cancelled
    transaction.update(
      _db.collection('orders').doc(orderId),
      {'status': 'cancelled'},
    );
  });
}
}