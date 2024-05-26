import 'package:evital/app/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
// import 'package:your_project/models/user_model.dart';

class HomeController extends GetxController {
  var users = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  final int itemsPerPage = 20;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  void loadUsers() async {
    isLoading.value = true;
    var box = await Hive.openBox<UserModel>('userBox');
    var allUsers = box.values.toList();
    users.value = allUsers;
    filteredUsers.value = users.take(itemsPerPage).toList();
    isLoading.value = false;
  }

  void loadMoreUsers() {
    if ((currentPage.value * itemsPerPage) < users.length) {
      currentPage.value++;
      var nextUsers = users.take(currentPage.value * itemsPerPage).toList();
      filteredUsers.value = nextUsers;
    }
  }

  void filterUsers(String query) {
    var lowerQuery = query.toLowerCase();
    filteredUsers.value = users
        .where((user) {
          return user.name.toLowerCase().contains(lowerQuery) ||
              user.phoneNumber.contains(lowerQuery) ||
              user.city.toLowerCase().contains(lowerQuery);
        })
        .take(currentPage.value * itemsPerPage)
        .toList();
  }
}
