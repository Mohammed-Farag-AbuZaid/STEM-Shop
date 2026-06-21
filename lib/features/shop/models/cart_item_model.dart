import 'package:stem_shop/features/shop/models/product_model.dart';

class CartItem {
  final String productId;
  final String sellerId;
  final String schoolId;
  final String title;
  final String image;
  final double price;
  final int maxQuantity; // stock available at the time it was added
  int quantity;

  CartItem({
    required this.productId,
    required this.sellerId,
    required this.schoolId,
    required this.title,
    required this.image,
    required this.price,
    required this.maxQuantity,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  factory CartItem.fromProduct(ProductModel product, {int quantity = 1}) {
    return CartItem(
      productId: product.id,
      sellerId: product.sellerId,
      schoolId: product.schoolId,
      title: product.title,
      image: product.thumbnail,
      price: product.price,
      maxQuantity: product.quantity,
      quantity: quantity,
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'sellerId': sellerId,
        'schoolId': schoolId,
        'title': title,
        'image': image,
        'price': price,
        'maxQuantity': maxQuantity,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'] ?? '',
        sellerId: json['sellerId'] ?? '',
        schoolId: json['schoolId'] ?? '',
        title: json['title'] ?? '',
        image: json['image'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        maxQuantity: (json['maxQuantity'] as num? ?? 0).toInt(),
        quantity: (json['quantity'] as num? ?? 1).toInt(),
      );
}