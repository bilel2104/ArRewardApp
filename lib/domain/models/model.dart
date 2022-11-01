class DeviceInfo {
  String name;
  String identifier;
  String version;
  DeviceInfo(this.identifier, this.name, this.version);
}

class UserModel {
  int? id;
  String? role;
  String? email;
  String? accessToken;

  UserModel({this.id, this.role, this.email, this.accessToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    email = json['email'];
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role'] = role;
    data['email'] = email;
    data['accessToken'] = accessToken;
    return data;
  }
}
