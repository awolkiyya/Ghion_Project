class User {
  String? email;
  String? password;
  User({required this.email, required this.password});
  // to store to the firebase as documents change this object to json
  Map<String, dynamic> tojson() {
    return {
      "email": email,
      "password": password,
    };
  }
}
