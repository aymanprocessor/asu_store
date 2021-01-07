import 'dart:convert';

class RegistrationModel {
  String name;
  String phone;
  String email;
  String password;

  RegistrationModel({
    this.name,
    this.phone,
    this.email,
    this.password,
  });

  RegistrationModel copyWith({
    String name,
    String phone,
    String email,
    String password,
  }) {
    return RegistrationModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }

  factory RegistrationModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RegistrationModel(
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RegistrationModel.fromJson(String source) =>
      RegistrationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RegistrationModel(name: $name, phone: $phone, email: $email, password: $password)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is RegistrationModel &&
        o.name == name &&
        o.phone == phone &&
        o.email == email &&
        o.password == password;
  }

  @override
  int get hashCode {
    return name.hashCode ^ phone.hashCode ^ email.hashCode ^ password.hashCode;
  }
}
