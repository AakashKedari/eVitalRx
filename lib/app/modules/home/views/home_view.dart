import 'package:evital/app/data/models/user_model.dart';
import 'package:evital/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:hive/hive.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HomeView extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

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
            padding: const EdgeInsets.only(bottom: 5,left: 8,right: 8),
            child: TextField(
              controller: homeController.searchController,
              decoration:  InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
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
        )

      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!homeController.isLoading.value &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                homeController.filteredUsers.length != 43 && homeController.searchController.text.isEmpty) {
              homeController.isMoreUserLoadingFlag.value = true;
              debouncer.call(homeController.loadMoreUsers);
              Future.delayed(const Duration(seconds: 2),() =>  homeController.isMoreUserLoadingFlag.value = false);
            }
            return true;
          },
          child: Column(
            children: [

              Expanded(
                child: ListView.builder(

                  itemCount: homeController.filteredUsers.length,
                  itemBuilder: (context, index) {
                    UserModel user = homeController.filteredUsers[index];
                    return ListTile(
                      onTap: () => _showEditDialog(context, user),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.imageUrl),
                      ),
                      title: Text(user.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone: ${user.phoneNumber}'),
                          Text('City: ${user.city}'),
                          Text(
                            'Rupee: ${user.rupeeStock} (${user.rupeeStock > 50 ? 'High' : 'Low'})',
                            style: TextStyle(
                              color: user.rupeeStock > 50
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),


              if (homeController.isMoreUserLoadingFlag.value)
                SizedBox(
                    height: 50,
                    child: Center(child: LoadingIndicator(indicatorType: Indicator.ballClipRotateMultiple )))

            ],
          ),
        );
      }),
    );
  }

  void _showEditDialog(BuildContext context, UserModel user) async {
    int? newRupee = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int currentRupee = user.rupeeStock;
        return AlertDialog(
          title: const Text('Change Rupee'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'New Rupee'),
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
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (newRupee != null && newRupee <=100 && newRupee>=0) {

      user.rupeeStock = newRupee;

      // Update the user's rupee stock in Hive
      user.save();

      var box = await Hive.openBox<UserModel>('userBox');
      homeController.filteredUsers.value = box.values.toList();
    }
    else{
      Get.snackbar('Error', 'Stock Rupee Out of Range',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
