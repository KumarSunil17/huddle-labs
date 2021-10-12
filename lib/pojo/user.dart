class User {
  String name;
  String phone;
  String gender;
  String email;
  String dpUrl;
  String location;
  String about;

  User(
      {required this.name,
      required this.about,
      required this.dpUrl,
      required this.email,
      required this.gender,
      required this.location,
      required this.phone});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        phone: json['phone'],
        gender: json['gender'],
        email: json['email'],
        dpUrl: json['dp'] ?? '',
        location: json['location'] ?? '',
        about: json['about'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'gender': gender,
        'email': email,
        'dp': dpUrl,
        'location': location,
        'about': about
      };
}
