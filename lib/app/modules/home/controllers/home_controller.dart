import 'dart:math';
import 'package:evital/app/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../data/consts.dart';

class HomeController extends GetxController {
  var users = <UserModel>[].obs;
  var filteredUsers = <UserModel>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  final int itemsPerPage = 20;
  var isMoreUserLoadingFlag = false.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }

  void loadUsers() async {
    isLoading.value = true;

    /// Just to depict that the data is coming from server,
    /// we delay fetching by 2 seconds

    Future.delayed(const Duration(seconds: 2)).then((value) async {
      var box = await Hive.openBox<UserModel>('userBox');
      if (box.isEmpty) {
        generateDummyData(box);
      } else {
        // Load existing data
        var allUsers = box.values.toList();
        users.value = allUsers;
        filteredUsers.value = users.take(itemsPerPage).toList();
      }
      isLoading.value = false;
    });
  }

  void generateDummyData(Box<UserModel> box) {
    List<UserModel> dummyUsers = List.generate(43, (index) {
      /// Here we assign random price to the items to the maximunm of 100
      Random random = Random();
      int price = random.nextInt(100);
      String randomCity = cities[random.nextInt(cities.length)];
      String username = Names[random.nextInt(20)];

      return UserModel(
        name: username,
        phoneNumber: '1234567890',
        city: randomCity,
        imageUrl: 'https://via.placeholder.com/150',
        rupeeStock: price,
      );
    });
    box.addAll(dummyUsers);
    /// Now we fill the first 20 values in list
    var allUsers = box.values.toList();
    users.value = allUsers;
    filteredUsers.value = users.take(itemsPerPage).toList();
  }

  void loadMoreUsers() {
    Future.delayed(const Duration(seconds: 1), () {
      if ((currentPage.value * itemsPerPage) < users.length) {
        currentPage.value++;
        var nextUsers = users.take(currentPage.value * itemsPerPage).toList();
        filteredUsers.value = nextUsers;
      }
    });
  }

  Future<void> filterUsers(String query) async {
    var box = await Hive.openBox<UserModel>('userBox');
    if (query.isEmpty) {
      filteredUsers.value = box.values.toList();
      return;
    }
    filteredUsers.value = box.values.where((user) {
      return user.name.toLowerCase().contains(query) ||
          user.phoneNumber.contains(query) ||
          user.city.toLowerCase().contains(query);
    }).toList();
  }
}
