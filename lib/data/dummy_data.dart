import 'package:stem_shop/features/shop/models/category_model.dart';
class DummyData {
  
static final List<CategoryModel> categories = [
  /// Main Categories
  CategoryModel(
    id: '1',
    image: 'assets/images/categories/electronics.png',
    name: 'Electronics',
    isFeatured: true,
  ),
  CategoryModel(
    id: '2',
    image: 'assets/images/categories/book.png',
    name: 'Books',
    isFeatured: true,
  ),
  CategoryModel(
    id: '3',
    image: 'assets/images/categories/study.png',
    name: 'Study Supplies',
    isFeatured: true,
  ),
  CategoryModel(
    id: '4',
    image: 'assets/images/categories/cap.png',
    name: 'Capstone',
    isFeatured: true,
  ),
  CategoryModel(
    id: '5',
    image: 'assets/images/categories/equipment.png',
    name: 'Equipment',
    isFeatured: true,
  ),
  CategoryModel(
    id: '6',
    image: 'assets/images/categories/room.png',
    name: 'Room Setup',
    isFeatured: true,
  ),
  CategoryModel(
    id: '7',
    image: 'assets/images/categories/food.png',
    name: 'Food',
    isFeatured: true,
  ),
  CategoryModel(
    id: '8',
    image: 'assets/images/categories/accesories.png',
    name: 'Accessories',
    isFeatured: true,
  ),
  CategoryModel(
    id: '9',
    image: 'assets/images/categories/other.png',
    name: 'Other',
    isFeatured: true,
  ),
  CategoryModel(
    id: '10',
    image: 'assets/images/categories/electronics.png',
    name: 'Devices',
    isFeatured: true,
  ),

  /// Electronics (Parent: 1)
  CategoryModel(id: '11', image: '', name: 'MCUs', parentId: '1', isFeatured: false),
  CategoryModel(id: '12', image: '', name: 'Sensors', parentId: '1', isFeatured: false),
  CategoryModel(id: '13', image: '', name: 'Actuators', parentId: '1', isFeatured: false),
  CategoryModel(id: '14', image: '', name: 'Tiny Components', parentId: '1', isFeatured: false),
  CategoryModel(id: '15', image: '', name: 'Kits', parentId: '1', isFeatured: false),
  CategoryModel(id: '16', image: '', name: 'Wiring & Connectors', parentId: '1', isFeatured: false),
  CategoryModel(id: '17', image: '', name: 'Power Supplies', parentId: '1', isFeatured: false),
  CategoryModel(id: '18', image: '', name: 'Tools & Soldering', parentId: '1', isFeatured: false),
  CategoryModel(id: '19', image: '', name: 'Other', parentId: '1', isFeatured: false),

  /// Books (Parent: 2)
  CategoryModel(id: '21', image: '', name: 'Textbooks', parentId: '2', isFeatured: false),
  CategoryModel(id: '22', image: '', name: 'Novels', parentId: '2', isFeatured: false),
  CategoryModel(id: '23', image: '', name: 'Scientific Books', parentId: '2', isFeatured: false),
  CategoryModel(id: '24', image: '', name: 'Exam Prep Books', parentId: '2', isFeatured: false),
  CategoryModel(id: '25', image: '', name: 'Book Bundles', parentId: '2', isFeatured: false),
  CategoryModel(id: '26', image: '', name: 'Other', parentId: '2', isFeatured: false),

  /// Study Supplies (Parent: 3)
  CategoryModel(id: '31', image: '', name: 'Notebooks', parentId: '3', isFeatured: false),
  CategoryModel(id: '32', image: '', name: 'Pens & Pencils', parentId: '3', isFeatured: false),
  CategoryModel(id: '33', image: '', name: 'Calculators', parentId: '3', isFeatured: false),
  CategoryModel(id: '34', image: '', name: 'Lab Coats', parentId: '3', isFeatured: false),
  CategoryModel(id: '35', image: '', name: 'Other', parentId: '3', isFeatured: false),

  /// Capstone (Parent: 4)
  CategoryModel(id: '41', image: '', name: '3D Printed Parts', parentId: '4', isFeatured: false),
  CategoryModel(id: '42', image: '', name: 'Project Materials', parentId: '4', isFeatured: false),
  CategoryModel(id: '43', image: '', name: 'Tools', parentId: '4', isFeatured: false),
  CategoryModel(id: '44', image: '', name: 'Lab Equipment', parentId: '4', isFeatured: false),
  CategoryModel(id: '45', image: '', name: 'Other', parentId: '4', isFeatured: false),

  /// Equipment (Parent: 5)
  CategoryModel(id: '51', image: '', name: 'Electrical Equipment', parentId: '5', isFeatured: false),
  CategoryModel(id: '52', image: '', name: 'Electronics Equipment', parentId: '5', isFeatured: false),
  CategoryModel(id: '53', image: '', name: 'Carpentry Equipment', parentId: '5', isFeatured: false),
  CategoryModel(id: '54', image: '', name: 'Tools', parentId: '5', isFeatured: false),
  CategoryModel(id: '55', image: '', name: 'Other', parentId: '5', isFeatured: false),

  /// Room Setup (Parent: 6)
  CategoryModel(id: '61', image: '', name: 'Lighting', parentId: '6', isFeatured: false),
  CategoryModel(id: '62', image: '', name: 'Furniture', parentId: '6', isFeatured: false),
  CategoryModel(id: '63', image: '', name: 'Decorations', parentId: '6', isFeatured: false),
  CategoryModel(id: '64', image: '', name: 'Study Desk Items', parentId: '6', isFeatured: false),
  CategoryModel(id: '65', image: '', name: 'Cleaning Supplies', parentId: '6', isFeatured: false),
  CategoryModel(id: '66', image: '', name: 'Other', parentId: '6', isFeatured: false),

  /// Food (Parent: 7)
  CategoryModel(id: '71', image: '', name: 'Snacks', parentId: '7', isFeatured: false),
  CategoryModel(id: '72', image: '', name: 'Drinks', parentId: '7', isFeatured: false),
  CategoryModel(id: '73', image: '', name: 'Instant Meals', parentId: '7', isFeatured: false),
  CategoryModel(id: '74', image: '', name: 'Coffee & Tea', parentId: '7', isFeatured: false),
  CategoryModel(id: '75', image: '', name: 'Other', parentId: '7', isFeatured: false),

  /// Accessories (Parent: 8)
  CategoryModel(id: '81', image: '', name: 'Watches', parentId: '8', isFeatured: false),
  CategoryModel(id: '82', image: '', name: 'Phone Accessories', parentId: '8', isFeatured: false),
  CategoryModel(id: '83', image: '', name: 'Laptop Accessories', parentId: '8', isFeatured: false),
  CategoryModel(id: '84', image: '', name: 'Bags', parentId: '8', isFeatured: false),
  CategoryModel(id: '85', image: '', name: 'Headphones', parentId: '8', isFeatured: false),
  CategoryModel(id: '86', image: '', name: 'Keychains', parentId: '8', isFeatured: false),
  CategoryModel(id: '87', image: '', name: 'Other', parentId: '8', isFeatured: false),

  /// Other (Parent: 9)
  CategoryModel(id: '91', image: '', name: 'Services', parentId: '9', isFeatured: false),
  CategoryModel(id: '92', image: '', name: 'Tickets', parentId: '9', isFeatured: false),
  CategoryModel(id: '93', image: '', name: 'Clothing', parentId: '9', isFeatured: false),
  CategoryModel(id: '94', image: '', name: 'Collectibles', parentId: '9', isFeatured: false),
  CategoryModel(id: '95', image: '', name: 'Games', parentId: '9', isFeatured: false),
  CategoryModel(id: '96', image: '', name: 'Arts & Crafts', parentId: '9', isFeatured: false),
  CategoryModel(id: '97', image: '', name: 'Personal Care', parentId: '9', isFeatured: false),
  CategoryModel(id: '98', image: '', name: 'Miscellaneous', parentId: '9', isFeatured: false),
  CategoryModel(id: '99', image: '', name: 'Other', parentId: '9', isFeatured: false),

  /// Devices (Parent: 10)
  CategoryModel(id: '101', image: '', name: 'Laptops', parentId: '10', isFeatured: false),
  CategoryModel(id: '102', image: '', name: 'Tablets', parentId: '10', isFeatured: false),
  CategoryModel(id: '103', image: '', name: 'Phones', parentId: '10', isFeatured: false),
  CategoryModel(id: '104', image: '', name: 'Monitors', parentId: '10', isFeatured: false),
  CategoryModel(id: '105', image: '', name: 'Printers', parentId: '10', isFeatured: false),
  CategoryModel(id: '106', image: '', name: 'Scientific Calculators', parentId: '10', isFeatured: false),
  CategoryModel(id: '107', image: '', name: 'Storage Devices', parentId: '10', isFeatured: false),
  CategoryModel(id: '108', image: '', name: 'Networking Devices', parentId: '10', isFeatured: false),
  CategoryModel(id: '109', image: '', name: 'Other', parentId: '10', isFeatured: false),
];
}