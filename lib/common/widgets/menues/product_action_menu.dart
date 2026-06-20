import 'package:flutter/material.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';

enum TProductAction { edit, sold, delete }

class TProductActionsMenu extends StatelessWidget {
  const TProductActionsMenu({
    super.key,
    required this.product,
    required this.onAction,
  });

  final ProductModel product;
  final void Function(TProductAction action) onAction;

  @override
  Widget build(BuildContext context) {
    final canMarkSold = product.status == 'available' && product.quantity > 0;

    return PopupMenuButton<TProductAction>(
      icon: const Icon(Icons.more_vert, color: Colors.grey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: onAction,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: TProductAction.edit,
          child: Row(
            children: [
              Icon(Icons.edit_outlined, color: Colors.blue, size: 18),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        if (canMarkSold)
          const PopupMenuItem(
            value: TProductAction.sold,
            child: Row(
              children: [
                Icon(Icons.sell_outlined, color: Colors.orange, size: 18),
                SizedBox(width: 8),
                Text('Mark as Sold'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: TProductAction.delete,
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red, size: 18),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }
}