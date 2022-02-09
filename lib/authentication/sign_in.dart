import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bloodDonor/adminHome.dart';
import 'package:bloodDonor/search.dart';
import 'package:bloodDonor/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../home_screen.dart';
import 'auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String message = '';
  bool isHidden = true;
bool admin = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<bool>  isAdmin(String ID) => Future.delayed(Duration(seconds: 1), () async
  {
    CollectionReference appRef = FirebaseFirestore.instance.collection("Users");
    QuerySnapshot apSnapshot = await appRef.where("user_ID", isEqualTo: ID)
        .get();
    apSnapshot.docs.forEach((DocumentSnapshot doc) {
      setState(() {
        admin = doc.data()["isAdmin"];
        debugPrint("hellooooooooo $admin");
      });
    });
    return true;
  });
  void fetch(String ID) async {
    bool hasData = await isAdmin(ID);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'email',
                  hintText: 'email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: isHidden,
                decoration: InputDecoration(
                  labelText: 'password',
                  suffixIcon: InkWell(
                    onTap: _togglePassword,
                    child: iconBuild()
                  ),
                  hintText: 'password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  color: Colors.red,
                  child: InkWell(
                    onTap: () async {
                      showDialog(
                        context: context,
                      builder: (BuildContext context){return LoadingAlertBox();},
                      );
                      
                      final user = await Auth().signIn(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      Navigator.pop(context);

                      if (user != null) {
                       //fetch(user.uid);

                       if(user.uid != "Zy6qMjl5Umf2IUNbhrc5wGk2NpJ3") {
                         Navigator.pushReplacement(
                           context,
                           MaterialPageRoute(
                             builder: (_) =>
                                 AnimatedSplashScreen(
                                   splash: Image.asset('assets/logo.png'),
                                   nextScreen: Home(uid: user.uid),
                                   splashTransition: SplashTransition
                                       .fadeTransition,
                                   backgroundColor: Colors.red,
                                 ),
                           ),
                         );
                       }
                       else{
                         Navigator.pushReplacement(
                           context,
                           MaterialPageRoute(
                             builder: (_) =>
                                 AnimatedSplashScreen(
                                   splash: Image.asset('assets/logo.png'),
                                   nextScreen: AdminHome(uid: user.uid),
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
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                    "invalid information"),

                              );
                            });
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
              SizedBox(height: 20),
              InkWell(
                onTap: () async {

                  if (emailController.text.isEmpty) {
                    setState(() {
                      message = 'Invalid Email format';
                    });

                  } else {
                    final result =
                        await Auth().resetPassword(email: emailController.text);
                    setState(() {
                      message = result;
                    });

                  }



                },
                child: Text(
                  'Forgot your email/password?',
                  style: TextStyle(
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                  ),
                ),

              ),
              SizedBox(height: 10),
              if (message != '')
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info),
                    SizedBox(width: 10),
                    Text(
                      '$message',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );

  }
  void _togglePassword()
  {

    setState(() {
      isHidden = !isHidden;
    });
  }
  Widget iconBuild() {
    if (isHidden == true) return Icon(Icons.visibility);
    return Icon(Icons.visibility_off);
  }
}
