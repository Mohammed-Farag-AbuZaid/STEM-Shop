import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stem_shop/common/widgets/appbar/appbar.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/shop/controllers/request_controller.dart';
import 'package:stem_shop/features/shop/models/request_model.dart';
import 'package:stem_shop/features/shop/screens/requests/request_category.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

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
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _budgetController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) return;

    setState(() => _isSubmitting = true);

    try {
      final user = UserController.instance.user.value;
      final request = RequestModel(
        id: '',
        requesterId: user.id,
        schoolId: user.stemSchool,
        scope: _schoolScope,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory!,
        budget: double.tryParse(_budgetController.text) ?? 0.0,
        status: 'open',
        createdAt: DateTime.now(),
      );

      await RequestsController.instance.addRequest(request);

      if (!mounted) return;
      Navigator.pop(context);
      TLoaders.successSnackBar(
        title: 'Published',
        message: 'Your request is now live.',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: const TAppBar(title: Text('New Request'), showBackArrow: true),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Iconsax.category),
                ),
                dropdownColor: darkMode ? TColors.black : TColors.white,
                items: kRequestCategories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                validator: (v) => v == null ? 'Pick a category' : null,
              ),
              const SizedBox(height: TSizes.spaceBwInputFields),

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

              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  hintText:
                      'Condition, urgency, any details that help sellers',
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

              Text('Show to', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              RadioListTile<String>(
                title: const Text('My school only',
                    style: TextStyle(fontSize: 14)),
                value: 'my_school',
                // ignore: deprecated_member_use
                groupValue: _schoolScope,
                activeColor: Colors.blue,
                contentPadding: EdgeInsets.zero,
                // ignore: deprecated_member_use
                onChanged: (v) => setState(() => _schoolScope = v!),
              ),
              RadioListTile<String>(
                title: const Text('All STEM schools',
                    style: TextStyle(fontSize: 14)),
                value: 'all_schools',
                // ignore: deprecated_member_use
                groupValue: _schoolScope,
                activeColor: Colors.blue,
                contentPadding: EdgeInsets.zero,
                // ignore: deprecated_member_use
                onChanged: (v) => setState(() => _schoolScope = v!),
              ),
              const SizedBox(height: TSizes.spaceBwSections),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(TSizes.cardRadiusMd),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Publish Request',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
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