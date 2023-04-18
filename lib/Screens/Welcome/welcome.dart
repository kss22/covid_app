import 'package:covid_app/Screens/Login/login_entity.dart';
import 'package:covid_app/Screens/Login/login_page.dart';
import 'package:covid_app/Screens/Signup/signup_screen.dart';
import 'package:covid_app/assets/assets.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
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
          )
        ],
      ),
    );
  }
}
