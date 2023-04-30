import 'dart:io';

class User {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;
  String? email;
  String? password;

  User({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.password,
  });
  // to store to the firebase as documents change this object to json
  Map<String, dynamic> tojson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "address": address,
      "email": email,
      "password": password,
    };
  }

  User.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        phoneNumber = json['phoneNumber'],
        address = json['address'],
        email = json['email'],
        password = json['password'];
}
