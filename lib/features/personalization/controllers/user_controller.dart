import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:stem_shop/data/repositories/user/user_model.dart';
import 'package:stem_shop/data/repositories/user/user_repository.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());
  @override
  onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
      profileLoading.value = false;
    } catch (e) {
      user(UserModel.empty());
     }finally {
      profileLoading.value = false;
    }
  }

  /// Save user Record from any Registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      if (userCredentials != null) {
        // Convert Name to First and Last Name
        final nameParts = UserModel.nameParts(
          userCredentials.user!.displayName ?? '',
        );

        // Map Data
        final user = UserModel(
          id: userCredentials.user!.uid,
          firstName: nameParts[0],
          lastName: nameParts[1],
          username: userCredentials.user!.displayName ?? '',
          email: userCredentials.user!.email ?? '',
          profilePicture: userCredentials.user!.photoURL ?? '',
          phone: userCredentials.user!.phoneNumber ?? '',
          academicLevel: '',
          grade: '',
          stemSchool: '',
        );
        await userRepository.saveUserRecord(user);
      }
    } catch (e) {
      TLoaders.warningSnackBar(
        title: 'Data not saved',
        message:
            'Something went wrong while saving your information. You can re-save your data in your Profile.',
      );
    }
  }
}
