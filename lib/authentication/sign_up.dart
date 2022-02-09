

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bloodDonor/authentication/auth.dart';
import 'package:bloodDonor/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../home_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _dob = "Date of Birth";

  final nameController = TextEditingController();
  final pwController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final civilIdController = TextEditingController();

  String BloodType = "";
 bool validateCivil(var number) {
   if(number.length != 12)
     {
       return false;
     }
   else
     {
       var coeff = [2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
       int sum = 0;
       for (var i = 0; i < number.length - 1; i++) {
         // assuming number is a 12 character string
         sum += int.parse(number[i]) * coeff[i];
       }
       var x = 11 - (sum % 11);
       return (x == int.parse(number[number.length - 1]));
   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                'Fill your personal information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.5,
                child: Text(
                  'Enter your Full name as it appears on official documentations',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: pwController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.5,
                child: Text(
                  'We will send you emails regarding your appointment & donations.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: civilIdController,
                decoration: InputDecoration(
                  hintText: 'Civil Id',
                  labelText: 'Civil Id',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Blood Type',
                  labelText: 'Blood Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: <String>[
                  "O+",
                  "O-",
                  "A+",
                  "A-",
                  "B+",
                  "B-",
                  "AB+",
                  "AB-"
                ].map((String value) {
                  return new DropdownMenuItem<String>(

                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String selected) {
                    setState(() {
                      BloodType = selected;
                    });
                },
              ),
              SizedBox(height: 20),
              TextField(
                //enabled: false,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: (){
                      showDatePicker(context: context,
                          initialDate: DateTime(1999), firstDate: DateTime(1920), lastDate: DateTime(2010)).then((date){

                                _dob =  date.day.toString() +
                                    "/" +
                                    date.month.toString() +
                                    "/" +
                                    date.year.toString();

                      });
                    },
                    child: Icon(Icons.calendar_today),
                  ),
                  hintText: _dob,
                  helperText: "D/M/Y",
                  labelText: "Date of birth",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  color: Colors.red,
                  child: InkWell(
                    onTap: () async {
                      if(validateCivil(civilIdController.text)) {
                        final user = await Auth().signUp(
                          name: nameController.text,
                          email: emailController.text,
                          password: pwController.text,
                          phone: phoneController.text,
                          civilId: civilIdController.text,
                          dob: _dob,
                          bloodType: BloodType,
                          profilePhoto: "https://firebasestorage.googleapis.com/v0/b/blooddonordb-f4577.appspot.com/o/3450_20108515_1341776675954598_5703585707564454816_N1_-_Qu80_RT1600x1024-_OS960x960-_RD960x960-.png?alt=media&token=77169625-6369-495d-9d55-2c044529f8d3",
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context){return LoadingAlertBox();},
                        );
                        Navigator.pop(context);

                        if (user != null) {
                          CollectionReference counterRef = FirebaseFirestore.instance.collection("counters");
                          QuerySnapshot counterSnapshot = await counterRef.limit(1).get();
                          counterSnapshot.docs.forEach((DocumentSnapshot count)async {
                            int users = count.get("users") +1;

                            FirebaseFirestore.instance.collection("counters")
                                .doc(count.id).update(
                                {"users": users});

                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AnimatedSplashScreen(
                                    splash: Image.asset('assets/logo.png'),
                                    nextScreen: Home(
                                      uid: user.uid,
                                    ),
                                    splashTransition: SplashTransition
                                        .fadeTransition,
                                    backgroundColor: Colors.red,
                                  ),
                            ),
                          );
                        }
                      }
                      else{
                        showDialog(
                          context: context,
                        builder: (BuildContext context){return AlertDialog(
                            title: Text("please enter a valid civil ID"),

                          );}
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'CONTINUE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


