import 'package:covid_app/Screens/Login/login_body.dart';
import 'package:covid_app/assets/assets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'admin_login.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {

  // Initialize Firebase App
  Future<FirebaseApp> _initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return AdminLogIn();
          }
          else{
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }
        },
      ),

    );
  }
}
