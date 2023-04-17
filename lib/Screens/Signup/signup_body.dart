import 'package:covid_app/Screens/Login/login_field_text.dart';
import 'package:covid_app/Screens/Login/login_page.dart';
import 'package:covid_app/Screens/verification/verification.dart';
import 'package:covid_app/assets/assets.dart';
import 'package:covid_app/assets/field_text.dart';
import 'package:covid_app/assets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UserBodySignup extends StatefulWidget {
  const UserBodySignup({Key? key}) : super(key: key);

  @override
  _UserBodySignupState createState() => _UserBodySignupState();
}

class _UserBodySignupState extends State<UserBodySignup> {
  bool wrongPassword = false;
  bool wrongUsername = false;
  bool wrongEmail = false;

  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }
    return user;
  }

  DateTime _selectedDate = DateTime.now();

  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  final TextEditingController _phoneNumberController = TextEditingController();
  final MaskTextInputFormatter _phoneNumberFormatter = MaskTextInputFormatter(
    mask: '+961 ## ######',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _idController = TextEditingController();
    TextEditingController _cityController = TextEditingController();
    TextEditingController _countryController = TextEditingController();
    TextEditingController _medController = TextEditingController();
    Size size = MediaQuery.of(context).size;

    final DatabaseReference database = FirebaseDatabase.instance.reference();

    DatabaseReference user1Ref = database.child('users').child('user${_idController.text}');

    void addUser() {
      Map<String, dynamic> children = {
        'email': _emailController.text,
        'phone': _phoneNumberController.text,
        'name' : _nameController.text,
        'date' : _selectedDate.toString(),
        'city' : _cityController.text,
        'country' : _countryController.text,
        'medical_conditions': _medController.text,
      };
      user1Ref.update(children)
          .then((value) {
        print('Data updated successfully');
      })
          .catchError((error) {
        print('Failed to update data: $error');
      });
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 80),
          Text(
            "Welcome to Covaccine",
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Image.asset(
            "assets/icon.jpg",
            height: size.height * 0.2,
            // width: size.width*0.45,
          ),
          SizedBox(
            height: 50,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                child: Text(
                  "Full Name:",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                ),
              ),
              if (!wrongUsername)
                Fieldtext(
                    controllers: _nameController,
                    visibility: true,
                    label: "e.g. Abey Joe",
                    hint: "Enter Your Full Name",
                    cap: TextCapitalization.words),
              if (wrongUsername)
                ErrorFieldtext(
                    errorMessage: "Invalid Username",
                    controllers: _nameController,
                    visibility: true,
                    label: "e.g. Abey Joe",
                    hint: "Enter your full name",
                    cap: TextCapitalization.words),
              Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                child: Text(
                  "Email Adress:",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                ),
              ),
              if (!wrongEmail)
                Fieldtext(
                  controllers: _emailController,
                  visibility: true,
                  label: "e.g. example@email.com",
                  hint: "Enter your email",
                  cap: TextCapitalization.none,
                ),
              if (wrongEmail)
                ErrorFieldtext(
                  errorMessage: "Invalid email",
                  controllers: _emailController,
                  visibility: true,
                  label: "e.g. example@email.com",
                  hint: "Enter your email",
                  cap: TextCapitalization.none,
                ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                child: Text(
                  "Password:",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                ),
              ),
              if (!wrongPassword)
                Fieldtext(
                    controllers: _passwordController,
                    visibility: false,
                    label: "e.g. ******",
                    hint: "Enter you password",
                    cap: TextCapitalization.none),
              if (wrongPassword)
                ErrorFieldtext(
                    errorMessage: "Invalid Password",
                    controllers: _passwordController,
                    visibility: false,
                    label: "e.g. ******",
                    hint: "Enter you password",
                    cap: TextCapitalization.none),

              Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                child: Text(
                  "ID Card Number:",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0, right: 10.0),
                child: TextField(
                  controller: _idController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.primaryColor,
                    labelText: "e.g 0000XXXXXXXX",
                    hintText: "ID Card Number",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                child: Text(
                  "Phone Number:",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 5.0),
                child: TextField(
                  controller: _phoneNumberController,
                  inputFormatters: [_phoneNumberFormatter],
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.primaryColor,
                    labelText: "e.g +961 XX XXXXXX",
                    hintText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                child: Text(
                  "City:",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Fieldtext(
                  controllers: _cityController,
                  visibility: true,
                  label: "e.g. Beirut",
                  hint: "Enter you city",
                  cap: TextCapitalization.none),
              Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                child: Text(
                  "Country:",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Fieldtext(
                  controllers: _countryController,
                  visibility: true,
                  label: "e.g. Lebanon",
                  hint: "Enter you country",
                  cap: TextCapitalization.none),
              Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                child: Text(
                  "Medical Conditions:",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Fieldtext(
                  controllers: _medController,
                  visibility: true,
                  label: "e.g. Diabetes",
                  hint: "Enter you medical conditions",
                  cap: TextCapitalization.none),
              Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
                child: Text(
                  "Date of Birth:",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Center(
                child: RoundedButton(
                  text:
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  press: _showDatePicker,
                ),
              ),

              // Padding(
              //   padding: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
              //   child: Text(
              //     "Phone Number:",
              //     style: TextStyle(
              //       fontWeight: FontWeight.w300,
              //       fontSize: 18.0,
              //     ),
              //   ),
              // ),
              // // Fieldtext(visibility: true, label: "e.g. +0 123 456", hint: "Enter your Phone Number"),
              // Container(
              //   margin: EdgeInsets.only(left: 10.0, right: 10.0),
              //   child: DecoratedBox(
              //     decoration: BoxDecoration(
              //       color: kPrimaryLightColor,
              //       borderRadius: BorderRadius.circular(29),
              //       border: Border.all(color: Colors.grey),
              //     ),
              //     child: Container(
              //       margin: EdgeInsets.only(left: 5.0, right: 30.0),
              //       padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              //       child: InternationalPhoneNumberInput(
              //         onInputChanged: (value) {},
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You already have an account?"),
                  InkWell(
                    child: Text(
                      'Signin',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                ],
              ),
              Center(
                child: RoundedButton(
                  color: AppColors.primaryColor,
                  press: () async {
                    addUser();
                    //let's test the app
                    User? user = await registerUsingEmailPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                      name: _nameController.text,
                    );
                    print(user);

                    RegExp emailRegExp = RegExp(
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                    setState(() {
                      wrongUsername = false;
                      wrongPassword = false;
                      wrongEmail = false;
                    });
                    if (user != null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Verification(user: user)));
                    }
                    FirebaseAuth auth = FirebaseAuth.instance;

                    try {
                      UserCredential test =
                          await auth.createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        setState(() {
                          wrongPassword = true;
                        });
                      } else if (e.code == 'email-already-in-use') {
                        setState(() {
                          wrongEmail = true;
                        });
                      } else if (e.code == 'invalid-email') {
                        setState(() {
                          wrongEmail = true;
                        });
                      } else if (e.code == 'unknown' &&
                          _nameController.text.isEmpty &&
                          _passwordController.text.isEmpty &&
                          _emailController.text.isEmpty) {
                        setState(() {
                          wrongPassword = true;
                          wrongEmail = true;
                          wrongUsername = true;
                        });
                      } else if (e.code == 'unknown' &&
                          _nameController.text.isEmpty &&
                          !_passwordController.text.isEmpty &&
                          !_emailController.text.isEmpty) {
                        setState(() {
                          wrongPassword = true;
                          wrongEmail = true;
                          wrongUsername = false;
                        });
                      } else if (e.code == 'unknown' &&
                          _passwordController.text.isEmpty &&
                          !_emailController.text.isEmpty &&
                          !_nameController.text.isEmpty) {
                        setState(() {
                          wrongPassword = false;
                          wrongEmail = true;
                          wrongUsername = true;
                        });
                      } else if (e.code == 'unknown' &&
                          !_passwordController.text.isEmpty &&
                          _emailController.text.isEmpty &&
                          !_nameController.text.isEmpty) {
                        setState(() {
                          wrongPassword = true;
                          wrongEmail = false;
                          wrongUsername = true;
                        });
                      } else if (e.code == 'unknown' &&
                          _passwordController.text.isEmpty &&
                          _emailController.text.isEmpty &&
                          !_nameController.text.isEmpty) {
                        setState(() {
                          wrongPassword = true;
                          wrongEmail = true;
                          wrongUsername = false;
                        });
                      } else if (e.code == 'unknown' &&
                          !_passwordController.text.isEmpty &&
                          _emailController.text.isEmpty &&
                          _nameController.text.isEmpty) {
                        setState(() {
                          wrongPassword = false;
                          wrongEmail = true;
                          wrongUsername = true;
                        });
                      } else if (e.code == 'unknown' &&
                          _passwordController.text.isEmpty &&
                          !_emailController.text.isEmpty &&
                          _nameController.text.isEmpty) {
                        setState(() {
                          wrongPassword = true;
                          wrongEmail = false;
                          wrongUsername = true;
                        });
                      }
                      print(e.code);
                    }
                  },
                  text: "Register",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
