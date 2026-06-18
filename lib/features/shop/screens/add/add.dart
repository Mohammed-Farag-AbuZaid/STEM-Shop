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

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  double _finalPrice = 0.0;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: darkMode ? TColors.black : TColors.white,
      appBar: AppBar(
        title: Text(
          'Upload New Item',
          style: TextStyle(
            color: darkMode ? TColors.white : TColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: darkMode ? TColors.black : TColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.image, size: 40, color: Colors.blue),
                    SizedBox(height: TSizes.spaceBwItems / 2),
                    Text(
                      'Upload Product Images',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Select high-quality photos of your item',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBwSections),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: Icon(Iconsax.box),
                ),
              ),
              const SizedBox(height: TSizes.spaceBwInputFields),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Iconsax.category),
                ),
                dropdownColor: darkMode ? TColors.black : TColors.white,
                items:
                    [
                      'Electronics',
                      'Equipment',
                      'Books',
                      'Study Stuff',
                      'Materials',
                      'Food',
                      'Sports',
                      'Routers',
                      'Others'
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
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixIcon: Icon(Iconsax.money_3),
                      ),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBwInputFields),
                  Expanded(
                    child: TextFormField(
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => _calculateFinalPrice(),
                      decoration: const InputDecoration(
                        labelText: 'Discount (%)',
                        prefixIcon: Icon(Icons.percent),
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
                dropdownTextStyle: TextStyle(color: darkMode ? Colors.white : Colors.black, fontSize: 16),
                style: TextStyle(color: darkMode ? Colors.white : Colors.black),
                pickerDialogStyle: PickerDialogStyle(
                  backgroundColor: darkMode ? TColors.black : TColors.white,
                  countryCodeStyle: TextStyle(color: darkMode ? Colors.white : Colors.black),
                  countryNameStyle: TextStyle(color: darkMode ? Colors.white : Colors.black),
                ),
                decoration: const InputDecoration(
                  labelText: 'WhatsApp Number',
                  prefixIcon: Icon(Iconsax.call),
                ),
                onChanged: (phone) {},
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
              const SizedBox(height: TSizes.spaceBwSections * 1.5),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final NavigationController navigationController =
                        Get.find();
                    navigationController.selectedIndex.value = 0;

                    Get.snackbar(
                      'Success',
                      'Your product has been uploaded successfully!',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.green,
                      colorText: TColors.white,
                      margin: const EdgeInsets.all(10),
                      borderRadius: 8,
                      duration: const Duration(seconds: 3),
                    );
                  },
                  child: const Text(
                    'Add Item',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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

