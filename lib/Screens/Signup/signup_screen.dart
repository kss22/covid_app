import 'package:covid_app/Screens/Signup/signup_body.dart';
import 'package:covid_app/assets/assets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  Future<FirebaseApp> _initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return UserBodySignup();
          }
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
