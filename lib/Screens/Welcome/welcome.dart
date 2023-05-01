import 'package:covid_app/Screens/Login/login_entity.dart';
import 'package:covid_app/Screens/Signup/signup_screen.dart';
import 'package:covid_app/assets/assets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    final FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();
    // Create a reference to the time slots node in your Firebase database
    final DatabaseReference timeSlotsRef = FirebaseDatabase.instance.reference().child('time_slots');

// Define the start and end times for the time slots
    DateTime startTime = DateTime(2023, 5, 1, 8);
    DateTime endTime = DateTime(2023, 5, 1, 18);

// Loop through each 30-minute time slot and add it to the database
    while (startTime.isBefore(endTime)) {
      // Create a new time slot object with the start time, end time, and availability
      String startTimeString = startTime.toString();
      String endTimeString = startTime.add(Duration(minutes: 30)).toString();
      Map<String, dynamic> newTimeSlot = {
        'start_time': startTimeString,
        'end_time': endTimeString,
        'available': true
      };

      // Add the new time slot to the database
      timeSlotsRef.push().set(newTimeSlot);

      // Increment the start time by 30 minutes
      startTime = startTime.add(Duration(minutes: 30));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Welcome to AUBCOVAX"),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset("assets/icon.jpg", height: 200, width: 200,),
          ),
          SizedBox(
            height: 50.0,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              WelcomeText.welcomeTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          SizedBox(
            height: 50,
            width: 300,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginEntity()));
              },
              child: const Text("Login", style: TextStyle(fontSize: 18.0),),
              color: AppColors.primaryColor,
              textColor: Colors.white,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
            height: 50,
            width: 300,
            child: RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
              },
              child: const Text("Sign-up", style: TextStyle(fontSize: 18.0),),
              color: AppColors.secondaryColor,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
