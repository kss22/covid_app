import 'package:covid_app/Screens/%20MedicalPersonnel/medical_personnel_login.dart';
import 'package:covid_app/Screens/Login/login_body.dart';
import 'package:covid_app/assets/assets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PersonnelLoginPage extends StatefulWidget {
  const PersonnelLoginPage({Key? key}) : super(key: key);

  @override
  _PersonnelLoginPageState createState() => _PersonnelLoginPageState();
}

class _PersonnelLoginPageState extends State<PersonnelLoginPage> {

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
            return PersonnelBodyLogIn();
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
