import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stem_shop/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stem_shop/data/repositories/authentication_repositrories.dart';
import 'package:stem_shop/data/repositories/products/product_repository.dart';
import 'package:stem_shop/data/repositories/requests/request_repository.dart';
import 'package:stem_shop/data/repositories/user/user_repository.dart';
import 'package:stem_shop/data/services/cloudinary_storage_service.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/shop/controllers/order_controller.dart';
import 'package:stem_shop/features/shop/controllers/products_controler.dart';
import 'package:stem_shop/features/shop/controllers/cart_controller.dart';
import 'package:stem_shop/features/shop/controllers/request_controller.dart';
import 'package:stem_shop/features/shop/controllers/seller_order_controller.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) {
    Get.put(AuthenticationRepository());
    Get.put(UserRepository());
    Get.put(UserController());
    Get.put(ProductRepository());
    Get.put(ProductController());
    Get.put(CartController());
    Get.put(OrdersController());
    Get.put(SellerOrdersController());
    Get.put(RequestRepository());
    Get.put(RequestsController());
    Get.put(TCloudinaryService());

  });

  runApp(const App());
}
