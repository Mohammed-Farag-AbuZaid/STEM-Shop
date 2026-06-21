import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({super.key});

  @override
  State<AddRequestScreen> createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _budgetController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  String _schoolScope = 'my_school';
  String _fullPhone = '';

  static const _categories = [
    'Electronics', 'Devices', 'Books',
    'Study Materials', 'Capstone', 'Equipment',
    'Room Setup', 'Food', 'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _budgetController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request published successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Request'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // product name
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'What are you looking for?',
                  prefixIcon: Icon(Iconsax.box),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: TSizes.spaceBwInputFields),

              // category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Iconsax.category),
                ),
                dropdownColor: darkMode ? TColors.black : TColors.white,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                validator: (v) => v == null ? 'Pick a category' : null,
              ),
              const SizedBox(height: TSizes.spaceBwInputFields),

              // budget
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Max budget (EGP)',
                  prefixIcon: Icon(Iconsax.money_3),
                ),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Enter a valid budget';
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBwInputFields),
              
              // description
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  hintText: 'Condition, urgency, any details that help sellers',
                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 64),
                    child: Icon(Iconsax.note_text),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: TSizes.spaceBwSections),

              // scope
              Text(
                'Show to',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              RadioListTile<String>(
                title: const Text('My school only', style: TextStyle(fontSize: 14)),
                value: 'my_school',
                groupValue: _schoolScope,
                activeColor: Colors.blue,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => _schoolScope = v!),
              ),
              RadioListTile<String>(
                title: const Text('All STEM schools', style: TextStyle(fontSize: 14)),
                value: 'all_schools',
                groupValue: _schoolScope,
                activeColor: Colors.blue,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => _schoolScope = v!),
              ),
              const SizedBox(height: TSizes.spaceBwSections),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(TSizes.cardRadiusMd),
                    ),
                  ),
                  child: const Text(
                    'Publish Request',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
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