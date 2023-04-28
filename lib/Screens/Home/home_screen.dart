import 'package:covid_app/Screens/Welcome/welcome.dart';
import 'package:covid_app/assets/assets.dart';
import 'package:covid_app/assets/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email = "";
  String name = "";
  String birth = "";
  String phone = "";
  String city = "";
  String country = "";
  String meds = "";
  String first = "";
  String second = "";
  String third = "";

  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;
    String uid = user?.uid ?? "";

    final DatabaseReference database = FirebaseDatabase.instance.reference();

    final DatabaseReference usersRef = database.child('users');

    final DatabaseReference userRef = usersRef.child(uid);

    // TODO must be fixed to get the signed in user
    userRef.once().then((DataSnapshot snapshot) {
      // Handle the retrieved data
      setState(() {
        email = snapshot.value['email'];
        name = snapshot.value['name'];
        phone = snapshot.value['phone'];
        city = snapshot.value['city'];
        country = snapshot.value['country'];
        meds = snapshot.value['meds'];
        birth = snapshot.value['birth'];
        first = snapshot.value['first_dose'];
        second = snapshot.value['second_dose'];
        third = snapshot.value['third_dose'];
      });
    }).catchError((error) {
      // Handle any errors that occur while retrieving data
      print('Failed to retrieve data: $error');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Information Page"),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 26.0,
            ),
            Container(
              width: double.infinity,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patient Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      UserInfoRow(title: 'Email', value: email),
                      UserInfoRow(title: 'Name', value: name),
                      UserInfoRow(title: 'Phone Number', value: phone),
                      UserInfoRow(title: 'City', value: city),
                      UserInfoRow(title: 'Country', value: country),
                      UserInfoRow(title: 'Medical conditions', value: meds),
                      UserInfoRow(title: 'Date of Birth', value: birth),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 26.0,
            ),
            Container(
              width: double.infinity,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dose Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      UserInfoRow(title: 'First Dose', value: first),
                      UserInfoRow(title: 'Second Dose', value: second),
                      UserInfoRow(title: 'Third Dose', value: third),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 26.0,
            ),
            RoundedButton(
                text: "Download Certificate",
                press: () {
                  //TODO add the funtion
                })
          ],
        ),
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final String title;
  final String value;

  UserInfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
