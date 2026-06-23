import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stem_shop/data/repositories/products/product_repository.dart';
import 'package:stem_shop/data/services/cloudinary_storage_service.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/shop/controllers/categories_controller.dart';
import 'package:stem_shop/features/shop/models/category_model.dart';
import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/navigation_menu.dart';
import 'package:stem_shop/utils/constants/colors.dart';
import 'package:stem_shop/utils/constants/sizes.dart';
import 'package:stem_shop/utils/helpers/helper_functions.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, this.existingProduct});

  final ProductModel? existingProduct;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _onlineLinkController = TextEditingController();

  double _finalPrice = 0.0;
  String _selectedCondition = 'used';

  CategoryModel? _selectedCategory;
  CategoryModel? _selectedSubCategory;
  List<CategoryModel> _subCategories = [];
  bool _loadingSubCategories = false;

  final List<XFile> _pickedImages = [];
  final List<Uint8List> _pickedImageBytes = [];
  List<String> _existingImageUrls = [];
  bool _isSubmitting = false;
  bool _isPrefillLoading = false;

  static const int _maxImages = 3;
  static const int _maxImageSizeBytes = 3 * 1024 * 1024;

  final _categoriesController = CategoriesController.instance;

  bool get _isEditMode => widget.existingProduct != null;

  @override
  void initState() {
    super.initState();
    if (widget.existingProduct != null) {
      _isPrefillLoading = true;
      _prefillFromExistingProduct();
    }
  }

  CategoryModel? _findById(List<CategoryModel> list, String id) {
    for (final item in list) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<void> _prefillFromExistingProduct() async {
    final product = widget.existingProduct;
    if (product == null) return;

    _titleController.text = product.title;
    _descriptionController.text = product.description;
    _quantityController.text = product.quantity.toString();
    _onlineLinkController.text = product.onlineLink ?? '';
    _priceController.text = product.marketPrice.toStringAsFixed(0);

    final hasDiscount =
        product.marketPrice > product.price && product.marketPrice > 0;
    if (hasDiscount) {
      final discountPercent =
          (((product.marketPrice - product.price) / product.marketPrice) * 100)
              .round();
      _discountController.text = discountPercent.toString();
    }

    final categories = _categoriesController.featuredCategories;
    final matchedCategory = _findById(categories, product.categoryId);

    List<CategoryModel> subCategories = [];
    CategoryModel? matchedSubCategory;

    if (matchedCategory != null) {
      subCategories = await _categoriesController.getSubCategories(
        matchedCategory.id,
      );
      matchedSubCategory = _findById(subCategories, product.subCategoryId);
    }

    if (!mounted) return;

    setState(() {
      _selectedCondition = product.condition;
      _existingImageUrls = List<String>.from(product.images);
      _finalPrice = product.price;
      _selectedCategory = matchedCategory;
      _subCategories = subCategories;
      _selectedSubCategory = matchedSubCategory;
      _isPrefillLoading = false;
    });
  }

  void _calculateFinalPrice() {
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final discount = double.tryParse(_discountController.text) ?? 0.0;
    setState(() {
      _finalPrice = (discount > 0 && discount <= 100)
          ? price - (price * (discount / 100))
          : price;
    });
  }

  Future<void> _onCategoryChanged(CategoryModel? category) async {
    setState(() {
      _selectedCategory = category;
      _selectedSubCategory = null;
      _subCategories = [];
      _loadingSubCategories = category != null;
    });

    if (category == null) return;

    final subCategories = await _categoriesController.getSubCategories(
      category.id,
    );

    if (!mounted) return;
    setState(() {
      _subCategories = subCategories;
      _loadingSubCategories = false;
    });
  }

  Future<void> _pickImages() async {
    final currentTotal = _existingImageUrls.length + _pickedImages.length;
    final remaining = _maxImages - currentTotal;
    if (remaining <= 0) {
      TLoaders.warningSnackBar(
        title: 'Image Limit Reached',
        message: 'You can only have up to $_maxImages images total.',
      );
      return;
    }

    final picker = ImagePicker();
    final images = await picker.pickMultiImage(imageQuality: 80);
    if (images.isEmpty) return;

    final allowed = images.take(remaining).toList();
    final rejectedCount = images.length - allowed.length;

    final bytesList = await Future.wait(
      allowed.map((img) => img.readAsBytes()),
    );

    final oversized = <String>[];
    final validImages = <XFile>[];
    final validBytes = <Uint8List>[];

    for (int i = 0; i < allowed.length; i++) {
      if (bytesList[i].length > _maxImageSizeBytes) {
        oversized.add(allowed[i].name);
      } else {
        validImages.add(allowed[i]);
        validBytes.add(bytesList[i]);
      }
    }

    setState(() {
      _pickedImages.addAll(validImages);
      _pickedImageBytes.addAll(validBytes);
    });

    if (oversized.isNotEmpty) {
      TLoaders.warningSnackBar(
        title: 'Images Too Large',
        message:
            '${oversized.length} image(s) exceeded the 3MB limit and were not added.',
      );
    }

    if (rejectedCount > 0) {
      TLoaders.warningSnackBar(
        title: 'Limit Reached',
        message:
            '$rejectedCount image(s) were not added. Maximum is $_maxImages images total.',
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _pickedImages.removeAt(index);
      _pickedImageBytes.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() => _existingImageUrls.removeAt(index));
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null || _selectedSubCategory == null) {
      TLoaders.warningSnackBar(
        title: 'Missing Info',
        message: 'Please select a category and subcategory.',
      );
      return;
    }

    if (_existingImageUrls.isEmpty && _pickedImageBytes.isEmpty) {
      TLoaders.warningSnackBar(
        title: 'Missing Images',
        message: 'Please add at least one product image.',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Upload only newly picked images — existing URLs are already on Cloudinary.
      final newImageUrls = <String>[];
      for (final bytes in _pickedImageBytes) {
        final url = await TCloudinaryService.instance.uploadImageData(bytes);
        newImageUrls.add(url);
      }

      final allImageUrls = [..._existingImageUrls, ...newImageUrls];

      final price = _finalPrice > 0
          ? _finalPrice
          : (double.tryParse(_priceController.text) ?? 0.0);
      final marketPrice = double.tryParse(_priceController.text) ?? 0.0;
      final quantity = int.tryParse(_quantityController.text) ?? 1;
      final onlineLink = _onlineLinkController.text.trim().isEmpty
          ? null
          : _onlineLinkController.text.trim();
      final title = _titleController.text.trim();

      if (_isEditMode) {
        final updated = widget.existingProduct!.copyWith(
          title: title,
          description: _descriptionController.text.trim(),
          price: price,
          marketPrice: marketPrice,
          quantity: quantity,
          images: allImageUrls,
          categoryId: _selectedCategory!.id,
          subCategoryId: _selectedSubCategory!.id,
          condition: _selectedCondition,
          onlineLink: onlineLink,
        );

        await ProductRepository.instance.updateProduct(updated);

        if (!mounted) return;
        Get.back();
        TLoaders.successSnackBar(
          title: 'Saved',
          message: 'Your changes have been saved.',
        );
      } else {
        final user = UserController.instance.user.value;

        final product = ProductModel.create(
          id: '',
          sellerId: user.id,
          schoolId: user.stemSchool,
          title: title,
          description: _descriptionController.text.trim(),
          price: price,
          marketPrice: marketPrice,
          quantity: quantity,
          images: allImageUrls,
          categoryId: _selectedCategory!.id,
          subCategoryId: _selectedSubCategory!.id,
          condition: _selectedCondition,
          status: 'available',
          createdAt: DateTime.now(),
          onlineLink: onlineLink,
        );

        await ProductRepository.instance.addProduct(product);

        if (!mounted) return;

        final NavigationController navigationController = Get.find();
        navigationController.selectedIndex.value = 0;

        Get.back();
        TLoaders.successSnackBar(
          title: 'Success',
          message: 'Your product has been uploaded successfully!',
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _quantityController.dispose();
    _onlineLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunctions.isDarkMode(context);
    final categories = _categoriesController.featuredCategories;
    final totalImages = _existingImageUrls.length + _pickedImages.length;

    return Scaffold(
      backgroundColor: darkMode ? TColors.black : TColors.white,
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Listing' : 'Upload New Item',
          style: TextStyle(
            color: darkMode ? TColors.white : TColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: darkMode ? TColors.black : TColors.white,
        elevation: 0,
      ),
      body: _isPrefillLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image picker
                      GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            color: darkMode
                                ? TColors.white.withValues(alpha: 0.05)
                                : Colors.blue.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Iconsax.image,
                                size: 40,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: TSizes.spaceBwItems / 2),
                              const Text(
                                'Upload Product Images',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                totalImages == 0
                                    ? 'Up to $_maxImages images • Max 3MB each'
                                    : '$totalImages/$_maxImages image(s) selected',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (_existingImageUrls.isNotEmpty ||
                          _pickedImageBytes.isNotEmpty) ...[
                        const SizedBox(height: TSizes.spaceBwItems),
                        SizedBox(
                          height: 70,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                _existingImageUrls.length +
                                _pickedImageBytes.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: TSizes.sm),
                            itemBuilder: (context, index) {
                              if (index < _existingImageUrls.length) {
                                final url = _existingImageUrls[index];
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        url,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () =>
                                            _removeExistingImage(index),
                                        child: const CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.red,
                                          child: Icon(
                                            Icons.close,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              final newIndex =
                                  index - _existingImageUrls.length;
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      _pickedImageBytes[newIndex],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(newIndex),
                                      child: const CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.red,
                                        child: Icon(
                                          Icons.close,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: TSizes.spaceBwSections),

                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          prefixIcon: Icon(Iconsax.box),
                        ),
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Product name is required'
                            : null,
                      ),
                      const SizedBox(height: TSizes.spaceBwInputFields),

                      DropdownButtonFormField<CategoryModel>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          prefixIcon: Icon(Iconsax.category),
                        ),
                        dropdownColor: darkMode ? TColors.black : TColors.white,
                        items: categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name),
                              ),
                            )
                            .toList(),
                        onChanged: _onCategoryChanged,
                        validator: (value) =>
                            value == null ? 'Please select a category' : null,
                      ),
                      const SizedBox(height: TSizes.spaceBwInputFields),

                      DropdownButtonFormField<CategoryModel>(
                        initialValue: _selectedSubCategory,
                        decoration: InputDecoration(
                          labelText: _loadingSubCategories
                              ? 'Loading subcategories...'
                              : 'Subcategory',
                          prefixIcon: const Icon(Icons.layers_outlined),
                        ),
                        dropdownColor: darkMode ? TColors.black : TColors.white,
                        items: _subCategories
                            .map(
                              (sub) => DropdownMenuItem(
                                value: sub,
                                child: Text(sub.name),
                              ),
                            )
                            .toList(),
                        onChanged:
                            (_selectedCategory == null || _loadingSubCategories)
                            ? null
                            : (value) =>
                                  setState(() => _selectedSubCategory = value),
                        validator: (value) => value == null
                            ? 'Please select a subcategory'
                            : null,
                      ),
                      const SizedBox(height: TSizes.spaceBwInputFields),

                      DropdownButtonFormField<String>(
                        initialValue: _selectedCondition,
                        decoration: const InputDecoration(
                          labelText: 'Condition',
                          prefixIcon: Icon(Icons.sell_outlined),
                        ),
                        dropdownColor: darkMode ? TColors.black : TColors.white,
                        items: const [
                          DropdownMenuItem(value: 'new', child: Text('New')),
                          DropdownMenuItem(
                            value: 'like_new',
                            child: Text('Like New'),
                          ),
                          DropdownMenuItem(value: 'used', child: Text('Used')),
                        ],
                        onChanged: (value) => setState(
                          () => _selectedCondition = value ?? 'used',
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBwInputFields),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (_) => _calculateFinalPrice(),
                              decoration: const InputDecoration(
                                labelText: 'Market Price',
                                prefixIcon: Icon(Iconsax.money_3),
                              ),
                              validator: (value) {
                                final price = double.tryParse(value ?? '');
                                if (price == null || price <= 0) {
                                  return 'Enter a valid market price';
                                }
                                return null;
                              },
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

                      TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity Available',
                          prefixIcon: Icon(Icons.inventory_2_outlined),
                        ),
                        validator: (value) {
                          final qty = int.tryParse(value ?? '');
                          if (qty == null || qty < 0) {
                            return 'Enter a valid quantity';
                          }
                          return null;
                        },
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
                          border: Border.all(
                            color: Colors.blue.withValues(alpha: 0.2),
                          ),
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
                              'EGP ${_finalPrice.toStringAsFixed(2)}',
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

                      TextFormField(
                        controller: _onlineLinkController,
                        decoration: const InputDecoration(
                          labelText: 'Online Link (optional)',
                          hintText: 'e.g. link to a similar product on Amazon',
                          prefixIcon: Icon(Icons.link),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBwInputFields),

                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 6,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Description is required'
                            : null,
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
                          onPressed: _isSubmitting ? null : _submitProduct,
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _isEditMode ? 'Save Changes' : 'Add Item',
                                  style: const TextStyle(
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
            ),
    );
  }
}
