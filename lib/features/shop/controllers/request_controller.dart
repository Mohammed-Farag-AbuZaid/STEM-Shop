import 'package:get/get.dart';
import 'package:stem_shop/data/repositories/requests/request_repository.dart';
import 'package:stem_shop/data/repositories/user/user_model.dart';
import 'package:stem_shop/features/personalization/controllers/user_controller.dart';
import 'package:stem_shop/features/shop/models/request_model.dart';
import 'package:stem_shop/utils/popups/loaders.dart';

class RequestsController extends GetxController {
  static RequestsController get instance => Get.find();

  final _repository = Get.find<RequestRepository>();

  final requests = <RequestModel>[].obs;
  final isLoading = false.obs;

  final scopeFilter = 'all'.obs;

  final Map<String, UserModel> _userCache = {};

  String get _schoolId => UserController.instance.user.value.stemSchool;

  @override
  void onInit() {
    super.onInit();
    final user = UserController.instance.user;
    if (user.value.stemSchool.isNotEmpty) {
      fetchRequests();
    } else {
      ever(user, (u) {
        if (u.stemSchool.isNotEmpty && requests.isEmpty) {
          fetchRequests();
        }
      });
    }
  }

  Future<void> fetchRequests() async {
    try {
      isLoading.value = true;
      final result = await _repository.fetchVisibleRequests(
        schoolId: _schoolId,
        scopeFilter: scopeFilter.value,
      );
      requests.assignAll(result);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void applyScopeFilter(String scope) {
    scopeFilter.value = scope;
    fetchRequests();
  }

  Future<UserModel> fetchRequesterInfo(String requesterId) async {
    if (_userCache.containsKey(requesterId)) {
      return _userCache[requesterId]!;
    }
    final user =
        await UserController.instance.userRepository.fetchUserById(requesterId);
    _userCache[requesterId] = user;
    return user;
  }

  Future<void> addRequest(RequestModel request) async {
    await _repository.addRequest(request);
    await fetchRequests();
  }

  Future<void> deleteRequest(String requestId) async {
    await _repository.deleteRequest(requestId);
    await fetchRequests();
  }
}