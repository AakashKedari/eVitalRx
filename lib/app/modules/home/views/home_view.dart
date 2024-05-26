import 'package:evital/app/data/models/user_model.dart';
import 'package:evital/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: UserSearch(homeController));
            },
          )
        ],
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!homeController.isLoading.value &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              homeController.loadMoreUsers();
            }
            return true;
          },
          child: ListView.builder(
            itemCount: homeController.filteredUsers.length,
            itemBuilder: (context, index) {
              UserModel user = homeController.filteredUsers[index];
              return ListTile(
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
                        color: user.rupeeStock > 50 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class UserSearch extends SearchDelegate<UserModel> {
  final HomeController homeController;

  UserSearch(this.homeController);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // close(context, result);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    homeController.filterUsers(query);
    return Obx(() {
      return ListView.builder(
        itemCount: homeController.filteredUsers.length,
        itemBuilder: (context, index) {
          UserModel user = homeController.filteredUsers[index];
          return ListTile(
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
                    color: user.rupeeStock > 50 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
