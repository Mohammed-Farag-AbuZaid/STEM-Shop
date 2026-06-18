import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:stem_shop/navigation_menu.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({super.key});

  @override
  State<AddRequestScreen> createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  double _finalPrice = 0.0;
  String _schoolScope = 'my_school';

  TextEditingController? get _phoneController => null;

  void _calculateFinalPrice() {
    double price = double.tryParse(_priceController.text) ?? 0.0;
    double discount = double.tryParse(_discountController.text) ?? 0.0;

    setState(() {
      if (discount > 0 && discount <= 100) {
        _finalPrice = price - (price * (discount / 100));
      } else {
        _finalPrice = price;
      }
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: darkMode ? TColors.black : TColors.white,
      appBar: AppBar(
        title: Text(
          'Add New Request',
          style: TextStyle(
            color: darkMode ? TColors.white : TColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: darkMode ? TColors.black : TColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: darkMode ? TColors.white : TColors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  color: darkMode
                      ? TColors.white.withValues(alpha: 0.05)
                      : Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Iconsax.image, size: 40, color: Colors.blue),
                    const SizedBox(height: TSizes.spaceBwItems / 2),
                    Text(
                      'Upload Request Images',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: darkMode ? TColors.white : TColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Select high-quality photos of your item',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBwSections),
              TextFormField(
                style: TextStyle(
                  color: darkMode ? TColors.white : TColors.black,
                ),
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  labelStyle: TextStyle(
                    color: darkMode ? Colors.white54 : Colors.black54,
                  ),
                  prefixIcon: const Icon(Iconsax.box),
                ),
              ),
              const SizedBox(height: TSizes.spaceBwInputFields),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(
                    color: darkMode ? Colors.white54 : Colors.black54,
                  ),
                  prefixIcon: const Icon(Iconsax.category),
                ),
                dropdownColor: darkMode ? TColors.black : TColors.white,
                style: TextStyle(
                  color: darkMode ? TColors.white : TColors.black,
                ),
                items:
                    [
                      'Electronics',
                      'Devices',
                      'Books',
                      'Study Materials',
                      'Capstone',
                      'Equipment',
                      'Room Setup',
                      'Food',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: TSizes.spaceBwInputFields),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateFinalPrice(),
                      style: TextStyle(
                        color: darkMode ? TColors.white : TColors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: TextStyle(
                          color: darkMode ? Colors.white54 : Colors.black54,
                        ),
                        prefixIcon: const Icon(Iconsax.money_3),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBwInputFields),
                  Expanded(
                    child: TextFormField(
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateFinalPrice(),
                      style: TextStyle(
                        color: darkMode ? TColors.white : TColors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Discount (%)',
                        labelStyle: TextStyle(
                          color: darkMode ? Colors.white54 : Colors.black54,
                        ),
                        prefixIcon: const Icon(Icons.percent),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBwInputFields),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: darkMode
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Final Price:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: darkMode ? TColors.white : TColors.black,
                      ),
                    ),
                    Text(
                      '\$${_finalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBwInputFields),
              IntlPhoneField(
                initialCountryCode: 'EG',
                dropdownTextStyle: TextStyle(
                  color: darkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
                style: TextStyle(color: darkMode ? Colors.white : Colors.black),
                pickerDialogStyle: PickerDialogStyle(
                  backgroundColor: darkMode ? TColors.black : TColors.white,
                  countryCodeStyle: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                  countryNameStyle: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
                decoration: InputDecoration(
                  labelText: 'WhatsApp Number',
                  labelStyle: TextStyle(
                    color: darkMode ? Colors.white54 : Colors.black54,
                  ),
                  prefixIcon: const Icon(Iconsax.call),
                ),
              ),
              const SizedBox(height: TSizes.spaceBwInputFields),
              TextFormField(
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  hintText:
                      '• Usage duration\n'
                      '• Current condition\n'
                      '• Reason for selling\n'
                      '• Add any information that benefits the buyer',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    height: 1.6,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Icon(Iconsax.note_text),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBwInputFields),
              Text(
                'Show request to:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: darkMode ? TColors.white : TColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: darkMode
                      ? Colors.white54
                      : Colors.black54,
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: Text(
                        'My School Only',
                        style: TextStyle(
                          color: darkMode ? TColors.white : TColors.black,
                          fontSize: 14,
                        ),
                      ),
                      value: 'my_school',
                      groupValue: _schoolScope,
                      activeColor: Colors.blue,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          _schoolScope = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text(
                        'All STEM Schools',
                        style: TextStyle(
                          color: darkMode ? TColors.white : TColors.black,
                          fontSize: 14,
                        ),
                      ),
                      value: 'all_schools',
                      groupValue: _schoolScope,
                      activeColor: Colors.blue,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          _schoolScope = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBwSections),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Request published successfully!'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Publish Request',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
