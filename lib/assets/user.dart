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
  String first_appointment;
  String second_appointment;
  String uid;

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
    required this.first_appointment,
    required this.second_appointment,
    required this.uid
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
      'first_appointment': first_appointment,
      'second_appointment': second_appointment,
      'uid': uid,
    };
  }
}