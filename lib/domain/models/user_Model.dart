class User {
  int? _id;
  int? _roleId;
  String? _email;
  String? _password;
  String? _phone;
  String? _birthday;
  String? _name;
  String? _address;
  bool? _status;
  String? _createdAt;
  String? _updatedAt;

  User(
      {int? id,
      int? roleId,
      String? email,
      String? password,
      String? phone,
      String? birthday,
      String? name,
      String? address,
      bool? status,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (roleId != null) {
      this._roleId = roleId;
    }
    if (email != null) {
      this._email = email;
    }
    if (password != null) {
      this._password = password;
    }
    if (phone != null) {
      this._phone = phone;
    }
    if (birthday != null) {
      this._birthday = birthday;
    }
    if (name != null) {
      this._name = name;
    }
    if (address != null) {
      this._address = address;
    }
    if (status != null) {
      this._status = status;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  int? get roleId => _roleId;
  set roleId(int? roleId) => _roleId = roleId;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get password => _password;
  set password(String? password) => _password = password;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  String? get birthday => _birthday;
  set birthday(String? birthday) => _birthday = birthday;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get address => _address;
  set address(String? address) => _address = address;
  bool? get status => _status;
  set status(bool? status) => _status = status;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  User.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _roleId = json['roleId'];
    _email = json['email'];
    _password = json['password'];
    _phone = json['phone'];
    _birthday = json['birthday'];
    _name = json['name'];
    _address = json['address'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['roleId'] = this._roleId;
    data['email'] = this._email;
    data['password'] = this._password;
    data['phone'] = this._phone;
    data['birthday'] = this._birthday;
    data['name'] = this._name;
    data['address'] = this._address;
    data['status'] = this._status;
    data['createdAt'] = this._createdAt;
    data['updatedAt'] = this._updatedAt;
    return data;
  }
}
