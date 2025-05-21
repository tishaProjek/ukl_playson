class User {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String image;
  final String accessToken;

  User({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      image: json['image'],
      accessToken: json['accessToken'],
    );
  }
}
