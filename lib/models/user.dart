class User {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String phoneNumber;
  final String password;
  final String role;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.role,
  });

  toJson() {
    return {
      "FirstName": firstname,
      "LastName": lastname,
      "Email": email,
      "PhoneNumber": phoneNumber,
      "Password": password,
      "Role": role,
    };
  }
}
