import 'package:bloodDonor/authentication/onboard.dart';
import 'package:bloodDonor/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    new MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: OnBoardingScreen(),
    ),
  );
}
