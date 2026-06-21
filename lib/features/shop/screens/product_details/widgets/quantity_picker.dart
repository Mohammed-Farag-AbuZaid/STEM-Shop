import 'package:flutter/material.dart';
import 'package:stem_shop/utils/constants/sizes.dart';

class QuantityPickerDialog extends StatefulWidget {
  const QuantityPickerDialog({super.key, required this.maxQuantity});

  final int maxQuantity;

  static Future<int?> show(BuildContext context, int maxQuantity) {
    return showDialog<int>(
      context: context,
      builder: (_) => QuantityPickerDialog(maxQuantity: maxQuantity),
    );
  }

  @override
  State<QuantityPickerDialog> createState() => _QuantityPickerDialogState();
}

class _QuantityPickerDialogState extends State<QuantityPickerDialog> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: TSizes.spaceBwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$_quantity', style: const TextStyle(fontSize: 20)),
                IconButton(
                  onPressed: _quantity < widget.maxQuantity
                      ? () => setState(() => _quantity++)
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            Text(
              '${widget.maxQuantity} available',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: TSizes.spaceBwItems),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: TSizes.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(_quantity),
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}