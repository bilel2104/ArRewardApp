import 'dart:convert';

class Rewards {
  Rewards({
    required this.success,
    required this.data,
  });

  bool success;
  List<Reward> data;

  factory Rewards.fromJson(Map<String, dynamic> json) => Rewards(
        success: json["success"],
        data: List<Reward>.from(json["data"].map((x) => Reward.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Reward {
  Reward({
    required this.id,
    required this.shopId,
    required this.typeId,
    required this.name,
    required this.description,
    required this.image,
    required this.count,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int shopId;
  int typeId;
  String name;
  String description;
  String image;
  int count;
  DateTime createdAt;
  DateTime updatedAt;

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        id: json["id"],
        shopId: json["shopId"],
        typeId: json["typeId"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        count: json["count"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shopId": shopId,
        "typeId": typeId,
        "name": name,
        "description": description,
        "image": image,
        "count": count,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
