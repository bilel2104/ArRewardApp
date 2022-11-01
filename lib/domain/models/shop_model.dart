class Shop {
  Shop({
    required this.success,
    required this.data,
  });

  bool success;
  List<Shops> data;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        success: json["success"],
        data: List<Shops>.from(json["data"].map((x) => Shops.fromJson(x))),
      );
}

class Shops {
  Shops(
      {required this.id,
      required this.userId,
      required this.typeId,
      required this.name,
      required this.description,
      required this.address,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.marker,
      this.distance});

  int id;
  int userId;
  dynamic typeId;
  String name;
  String description;
  String address;
  bool status;
  DateTime createdAt;
  DateTime updatedAt;
  Markers marker;
  double? distance;

  factory Shops.fromJson(Map<String, dynamic> json) => Shops(
        id: json["id"],
        userId: json["userId"],
        typeId: json["typeId"],
        name: json["name"],
        description: json["description"],
        address: json["address"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        marker: Markers.fromJson(json["Marker"]),
      );
}

class Markers {
  Markers({
    required this.id,
    required this.shopId,
    required this.info,
    required this.lat,
    required this.lng,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int shopId;
  String info;
  String lat;
  String lng;
  DateTime createdAt;
  DateTime updatedAt;

  factory Markers.fromJson(Map<String, dynamic> json) => Markers(
        id: json["id"],
        shopId: json["shopId"],
        info: json["info"],
        lat: json["lat"],
        lng: json["lng"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}
