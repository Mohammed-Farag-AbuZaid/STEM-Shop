import 'package:stem_shop/features/shop/models/product_model.dart';
import 'package:stem_shop/utils/constants/image_strings.dart';
class DummyData {
  
static final List<ProductModel> products = [


  ProductModel(
    id: 'p1', sellerId: 'user_test_1', schoolId: '6th of October STEM School for Boys',
    title: 'Arduino Uno R3', description: 'Used Arduino Uno in good condition, comes with USB cable.',
    price: 150, marketPrice: 200, images: [TImages.shopNow],
    categoryId: '1', subCategoryId: '11', condition: 'used', status: 'available',
    createdAt: DateTime.now(),
  ),
  ProductModel(
    id: 'p2', sellerId: 'user_test_1', schoolId: '6th of October STEM School for Boys',
    title: 'HC-SR04 Ultrasonic Sensor', description: 'Brand new ultrasonic sensor, never used.',
    price: 45, marketPrice: 60, images: [TImages.shopNow],
    categoryId: '1', subCategoryId: '12', condition: 'new', status: 'available',
    createdAt: DateTime.now(),
  ),
  ProductModel(
    id: 'p3', sellerId: 'user_test_2', schoolId: '6th of October STEM School for Boys',
    title: 'Physics Textbook Grade 11', description: 'Slightly used, all pages intact.',
    price: 80, marketPrice: 100, images: [TImages.shopNow],
    categoryId: '2', subCategoryId: '21', condition: 'used', status: 'available',
    createdAt: DateTime.now(),
  ),
  ProductModel(
    id: 'p4', sellerId: 'user_test_2', schoolId: '6th of October STEM School for Boys',
    title: 'Scientific Calculator FX-991', description: 'Like new, used for one semester.',
    price: 200, marketPrice: 250, images: [TImages.shopNow],
    categoryId: '10', subCategoryId: '106', condition: 'like_new', status: 'available',
    createdAt: DateTime.now(),
  ),
  ProductModel(
    id: 'p5', sellerId: 'user_test_1', schoolId: '6th of October STEM School for Boys',
    title: 'Jumper Wire Bundle', description: '40 male-to-male jumper wires.',
    price: 25, marketPrice: 35, images: [TImages.shopNow],
    categoryId: '1', subCategoryId: '16', condition: 'new', status: 'available',
    createdAt: DateTime.now(),
  ),
  ProductModel(
    id: 'p6', sellerId: 'user_test_3', schoolId: '6th of October STEM School for Boys',
    title: 'Lab Coat Size M', description: 'White lab coat, worn twice.',
    price: 60, marketPrice: 80, images: [TImages.shopNow],
    categoryId: '3', subCategoryId: '34', condition: 'like_new', status: 'available',
    createdAt: DateTime.now(),
  ),


  ProductModel(
    id: 'p7', sellerId: 'user_test_4', schoolId: 'New Cairo STEM School',
    title: 'Raspberry Pi 4', description: 'Raspberry Pi 4 4GB RAM with case.',
    price: 900, marketPrice: 1000, images: [TImages.shopNow],
    categoryId: '1', subCategoryId: '11', condition: 'used', status: 'available',
    createdAt: DateTime.now(),
  ),
  ProductModel(
    id: 'p8', sellerId: 'user_test_4', schoolId: 'New Cairo STEM School',
    title: 'Chemistry Textbook', description: 'Grade 12 chemistry book.',
    price: 70, marketPrice: 90, images: [TImages.shopNow],
    categoryId: '2', subCategoryId: '21', condition: 'used', status: 'available',
    createdAt: DateTime.now(),
  ),

  // ── School 3 ──

  ProductModel(
    id: 'p9', sellerId: 'user_test_5', schoolId: 'STEM School Alexandria',
    title: 'Soldering Iron Kit', description: 'Complete soldering kit with stand.',
    price: 180, marketPrice: 200, images: [TImages.shopNow],
    categoryId: '1', subCategoryId: '18', condition: 'new', status: 'available',
    createdAt: DateTime.now(),
  ),
  ProductModel(
    id: 'p10', sellerId: 'user_test_5', schoolId: 'STEM School Alexandria',
    title: 'Laptop Stand Adjustable', description: 'Aluminium laptop stand.',
    price: 120, marketPrice: 150, images: [TImages.shopNow],
    categoryId: '8', subCategoryId: '83', condition: 'new', status: 'available',
    createdAt: DateTime.now(),
  ),
];
}