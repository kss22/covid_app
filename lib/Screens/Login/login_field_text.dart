import 'package:covid_app/assets/assets.dart';
import 'package:flutter/material.dart';

class ErrorFieldtext extends StatelessWidget {
  final String errorMessage;
  final bool visibility;
  final String label;
  final String hint;
  final TextCapitalization cap;
  final TextEditingController controllers;

  const ErrorFieldtext({
    Key? key,
    required this.errorMessage,
    required this.controllers,
    required this.visibility,
    required this.label,
    required this.hint,
    required this.cap,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5.0),
      child: TextField(
        controller: controllers,
        autofocus: false,
        textCapitalization: cap,
        obscureText: !visibility,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.primaryColor,
          labelText: label,
          hintText: hint,
          // errorBorder: OutlineInputBorder(),
          errorText: errorMessage,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}