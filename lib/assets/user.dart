class Users {
  String email;
  String name;
  String phone;
  String city;
  String country;
  String meds;
  String birth;

  Users({
    required this.email,
    required this.name,
    required this.phone,
    required this.city,
    required this.country,
    required this.meds,
    required this.birth,
  });

  // Convert User object to Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'city': city,
      'country': country,
      'meds': meds,
      'birth': birth,
    };
  }
}