class Users {
  String email;
  String name;
  String phone;
  String city;
  String country;
  String meds;
  String birth;
  String first_dose;
  String second_dose;
  String third_dose;

  Users({
    required this.email,
    required this.name,
    required this.phone,
    required this.city,
    required this.country,
    required this.meds,
    required this.birth,
    required this.first_dose,
    required this.second_dose,
    required this.third_dose,
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
      'first_dose': first_dose,
      'second_dose': second_dose,
      'third_dose': third_dose,
    };
  }
}