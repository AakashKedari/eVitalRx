import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String phoneNumber;

  @HiveField(2)
  String city;

  @HiveField(3)
  String imageUrl;

  @HiveField(4)
  int rupeeStock;

  UserModel(
      {required this.name,
      required this.phoneNumber,
      required this.city,
      required this.imageUrl,
      required this.rupeeStock});
}
