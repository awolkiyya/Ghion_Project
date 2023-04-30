import 'dart:io';

class User {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;
  String? email;
  String? profileUrl;

  User({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.profileUrl,
  });
  // to store to the firebase as documents change this object to json
  Map<String, dynamic> tojson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "address": address,
      "email": email,
      "profileUrl": profileUrl,
    };
  }

  User.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'],
        lastName = json['last_name'],
        phoneNumber = json['phone_number'],
        address = json['address'],
        email = json['email'],
        profileUrl = json['profile'];
}
