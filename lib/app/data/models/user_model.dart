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

  UserModel({
    required this.name,
    required this.phoneNumber,
    required this.city,
    required this.imageUrl,
    required this.rupeeStock,
  });
}

@HiveType(typeId: 0)
class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel(
      name: reader.readString(),
      phoneNumber: reader.readString(),
      city: reader.readString(),
      imageUrl: reader.readString(),
      rupeeStock: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.phoneNumber);
    writer.writeString(obj.city);
    writer.writeString(obj.imageUrl);
    writer.writeInt(obj.rupeeStock);
  }
}
