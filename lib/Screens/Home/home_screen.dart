import 'package:covid_app/assets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email = "";

  @override
  Widget build(BuildContext context) {
    final DatabaseReference database = FirebaseDatabase.instance.reference();

    return Scaffold(
      appBar: AppBar(
        title: Text("AUBCOVAX"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RoundedButton(text: "click", press: (){
              database.child('users').child('user1').once().then((DataSnapshot snapshot) {
                // Handle the retrieved data
                setState(() {
                  email = snapshot.value['email'];
                });
              }).catchError((error) {
                // Handle any errors that occur while retrieving data
                print('Failed to retrieve data: $error');
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Data received successfully'),
                ),
              );
            }),
            Text(email),
          ],
        ),
      ),
    );
  }
}
