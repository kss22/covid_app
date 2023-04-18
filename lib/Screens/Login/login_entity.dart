import 'package:covid_app/Screens/Login/login_page.dart';
import 'package:covid_app/assets/assets.dart';
import 'package:covid_app/assets/entities.dart';
import 'package:covid_app/assets/rounded_button.dart';
import 'package:flutter/material.dart';

class LoginEntity extends StatefulWidget {
  const LoginEntity({Key? key}) : super(key: key);

  @override
  _LoginEntityState createState() => _LoginEntityState();
}

class _LoginEntityState extends State<LoginEntity> {
  String _dropdownvalue = "Choose here";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AUBCOVAX"),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Image.asset("assets/icon.jpg"),
              height: 200,
              width: 200,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "Who Are You?",
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 32.0,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(29),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 60, right: 60),
              child: DropdownButton(
                style: Theme.of(context).textTheme.headline6,
                value: _dropdownvalue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: entities.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items, style: TextStyle(color: AppColors.secondaryColor),),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _dropdownvalue = newValue!;
                  });
                },
              ),
            ),
          ),
          // Container(
          //   height: 40.0,
          //   width: 250.0,
          //   child: DropdownButton(items: const [
          //     DropdownMenuItem(child: Text("Choose"), value: "Choose"),
          //     DropdownMenuItem(child: Text("Patient"), value: "Patient"),
          //     DropdownMenuItem(
          //         child: Text("Medical Personnel"), value: "Medical_personnel"),
          //     DropdownMenuItem(child: Text("Admin"), value: "Admin"),
          //   ], value: _dropdownValue, onChanged: dropDownCallback,
          //   iconEnabledColor: AppColors.primaryColor,
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 20.0,
          //     ),
          //     underline: Container(
          //       height: 2.0,
          //       color: AppColors.primaryColor,
          //     ),
          //     isExpanded: true,
          //     icon: Icon(
          //       Icons.arrow_drop_down,
          //       color: AppColors.primaryColor,
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 30.0,
          ),
          if (_dropdownvalue == "Patient")
          RoundedButton(
            text: "Continue",
            color: AppColors.primaryColor,
            press: () {
              //TODO selection dependency
              Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
