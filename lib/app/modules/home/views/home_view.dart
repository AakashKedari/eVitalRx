import 'dart:developer';
import 'dart:ui';
import 'package:evital/app/data/models/user_model.dart';
import 'package:evital/app/modules/home/controllers/home_controller.dart';
import 'package:evital/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeView extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  final ScrollController _scrollController = ScrollController();

  /// Debouncer to avoid multiple loadMoreUsers function calls
  /// if the user scrolls to the max extent
  final debouncer = Debouncer(delay: const Duration(seconds: 1));

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue.shade300,
          centerTitle: true,
          title: const Text('User StockPrice'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
              child: TextField(
                controller: homeController.searchController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        homeController.searchController.clear();
                        homeController
                            .filterUsers(homeController.searchController.text);
                        FocusScope.of(context).unfocus();
                      },
                      icon: const Icon(Icons.clear)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search by name/phone/city',
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  homeController.filterUsers(value.toLowerCase());
                },
              ),
            ),
          )),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(
              child: SizedBox(
                  height: 50,
                  child: LoadingIndicator(
                      indicatorType: Indicator.ballClipRotate)));
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!homeController.isLoading.value &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                homeController.filteredUsers.length != 43 &&
                homeController.searchController.text.isEmpty) {
              homeController.isMoreUserLoadingFlag.value = true;
              debouncer.call(homeController.loadMoreUsers);
              Future.delayed(const Duration(seconds: 2), () {
                homeController.isMoreUserLoadingFlag.value = false;

                /// After loading more users, we are scrolling a bit down
                /// to let user know that more users have been loaded
                _scrollController.animateTo(
                  _scrollController.offset + 80,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              });
            }
            return true;
          },
          child: Column(
            children: [
              Expanded(
                child: homeController.filteredUsers.isNotEmpty
                    ? ListView.builder(
                        controller: _scrollController,
                        itemCount: homeController.filteredUsers.length,
                        itemBuilder: (context, index) {
                          UserModel user = homeController.filteredUsers[index];
                          return Card(
                            child: ListTile(
                              onTap: () => _showEditDialog(context, user),
                              leading: const CircleAvatar(
                                backgroundImage:
                                    AssetImage(AssetsPath.profilePic),
                              ),
                              title: Text(user.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.phone),
                                      const Gap(5),
                                      Text(user.phoneNumber),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_city),
                                      const Gap(5),
                                      Text(user.city),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Column(
                                children: [
                                  Text(
                                    '₹ ${user.rupeeStock}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: user.rupeeStock > 50
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  Text(
                                    ' (${user.rupeeStock > 50 ? 'High' : 'Low'})',
                                    style: TextStyle(
                                        color: user.rupeeStock > 50
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: 'No Records Found'.text.make(),
                      ),
              ),

              /// To show user that more data is loading
              if (homeController.isMoreUserLoadingFlag.value)
                const SizedBox(
                    height: 50,
                    child: Center(
                        child: LoadingIndicator(
                            indicatorType: Indicator.ballClipRotateMultiple)))
            ],
          ),
        );
      }),
    );
  }

  void _showEditDialog(BuildContext context, UserModel user) async {
    final _audioPlayer = AudioPlayer();
    Future<void> playErrorSound() async {
      try {
        await _audioPlayer.setAsset(AssetsPath.errorSound);
        _audioPlayer.play();
      } catch (e) {
        log("Error loading audio source: $e");
      }
    }

    playSuccessSound() async {
      try {
        await _audioPlayer.setAsset(AssetsPath.successSound);
        _audioPlayer.play();
      } catch (e) {
        log("Error loading audio source: $e");
      }
    }

    int? newRupee = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int currentRupee = user.rupeeStock;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Change Rupees for',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      user.name.toString(),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      '₹ ${user.rupeeStock.toString()}',
                      style: TextStyle(
                          color:
                              user.rupeeStock > 50 ? Colors.green : Colors.red),
                    )
                  ],
                )
              ],
            ),
            content: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.currency_rupee),
                  hintText: 'New Rupees',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none),
              onChanged: (value) {
                currentRupee = int.tryParse(value) ?? currentRupee;
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop(currentRupee);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // User pressed cancel or dismissed the dialog
    if (newRupee == null || newRupee == user.rupeeStock) {
      Utils.showSnackBar('No Amount Updated');
    } else if (newRupee <= 100 && newRupee >= 1) {
      playSuccessSound();
      user.rupeeStock = newRupee;

      // Update the user's rupee stock in Hive
      user.save();
      var box = await Hive.openBox<UserModel>('userBox');
      homeController.filteredUsers.value = box.values.toList();
      Get.snackbar('Updated', 'Price for the User ${user.name}',
          snackPosition: SnackPosition.BOTTOM);
    }

    /// In case the amount exceeds Rs. 100
    else {
      playErrorSound();
      Utils.showSnackBar('Error : Price entered out of Range');
    }

    Future.delayed(const Duration(seconds: 2), () => _audioPlayer.dispose());
  }
}
