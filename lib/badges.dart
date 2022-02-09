import 'dart:io';

import 'package:bloodDonor/widgets/appointments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Badge extends StatefulWidget {
  final String uid;
  Badge({@required this.uid});
  @override

  // TODO: implement createState
  BadgeState createState() => BadgeState();



}

class BadgeState extends State<Badge>{
  int _bottomNavBarIndex = 4;
  void share (BuildContext context){
    final RenderBox box = context.findRenderObject();
    final String text = "https://blooddonorkuwait.000webhostapp.com/#";
    Share.share(text, sharePositionOrigin: box.localToGlobal(Offset.zero)& box.size );

  }
  SharedPreferences _preferences;
  int count=1;
  bool selfie=false;
  bool spread=false;
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    //throw UnimplementedError();
    print(widget.uid);
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        leading: Icon(Icons.menu),
        title: Text("Badges"),
        elevation: 0,
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("appointments").where("user_ID",isEqualTo: widget.uid).where("status", isEqualTo: "done").snapshots(),
        builder: (context,snap){
          if(!snap.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            );
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20,top: 12,),
                    child: Text("General",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),

                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  showDialog(context: context,
                                      builder: (context){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Image.asset("assets/logo.png",
                                                    width: 60,height: 60,),
                                                  Text("Welcome Badge",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black
                                                    ),),
                                                  SizedBox(height: 10,),
                                                  Text("Sign up and create account."),
                                                  Spacer(),
                                                  FlatButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  }, child: Text(
                                                      "Ok"
                                                  )),
                                                  SizedBox(height: 10,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        )
                                    ),
                                    width: 110,
                                    height: 110,
                                    child:
                                    Icon(Icons.clean_hands_rounded,
                                      color: Colors.white,size: 34,),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text("Welcome",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  showDialog(context: context,

                                      builder: (context){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Image.asset("assets/logo.png",
                                                    width: 60,height: 60,),
                                                  Text("Blood Donor",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black
                                                    ),),
                                                  SizedBox(height: 10,),
                                                  Text("Schedule appointment and donate successfully.",
                                                    textAlign: TextAlign.center,),
                                                  Spacer(),
                                                  FlatButton(onPressed: ()async{
                                                    Navigator.pop(context);

                                                  },
                                                      color: Colors.grey,
                                                      child: Text(
                                                          "Ok"
                                                      )),
                                                  SizedBox(height: 10,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(

                                        color:
                                        snap.data.docs.length>=1?Colors.red:
                                        Colors.grey,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        )
                                    ),
                                    width: 110,
                                    height: 110,
                                    child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/bloodd.png",
                                          width: 60,height: 60,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text("Blood Donor",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  showDialog(context: context,
                                      builder: (context){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Image.asset("assets/logo.png",
                                                    width: 60,height: 60,),
                                                  Text("Life saver",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black
                                                    ),),
                                                  SizedBox(height: 10,),
                                                  Text("Donate five times to be a life saver.",
                                                    textAlign: TextAlign.center,),
                                                  Spacer(),
                                                  FlatButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                      color: Colors.grey,
                                                      child: Text(
                                                          "Ok"
                                                      )),
                                                  SizedBox(height: 10,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:

                                        snap.data.docs.length>=5

                                            ?Colors.red:
                                        Colors.grey,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        )
                                    ),
                                    width: 110,
                                    height: 110,
                                    child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/life.png",
                                          width: 60,height: 60,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text("Life saver",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.only(left: 20,top: 12,),
                    child: Text("Donations",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),

                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  showDialog(context: context,

                                      builder: (context){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Image.asset("assets/logo.png",
                                                    width: 60,height: 60,),
                                                  Text("First Timer",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black
                                                    ),),
                                                  SizedBox(height: 10,),
                                                  Text("Donate for the first time.",
                                                    textAlign: TextAlign.center,),
                                                  Spacer(),
                                                  FlatButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                      color: Colors.grey,
                                                      child: Text(
                                                          "Ok"
                                                      )),
                                                  SizedBox(height: 10,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                        snap.data.docs.length>=1?Colors.red:
                                        Colors.grey,

                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        )
                                    ),
                                    width: 110,
                                    height: 110,
                                    child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/bloodd.png",
                                          width: 60,height: 60,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text("First Timer",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  showDialog(context: context,

                                      builder: (context){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Image.asset("assets/logo.png",
                                                    width: 60,height: 60,),
                                                  Text("Second Timer",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black
                                                    ),),
                                                  SizedBox(height: 10,),
                                                  Text("Donate for the second time.",
                                                    textAlign: TextAlign.center,),
                                                  Spacer(),
                                                  FlatButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                      color: Colors.grey,
                                                      child: Text(
                                                          "Ok"
                                                      )),
                                                  SizedBox(height: 10,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                        snap.data.docs.length>=2?Colors.red:
                                        Colors.grey,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        )
                                    ),
                                    width: 110,
                                    height: 110,
                                    child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/second.png",
                                          width: 60,height: 60,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text("Second timer",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  showDialog(context: context,

                                      builder: (context){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Image.asset("assets/logo.png",
                                                    width: 60,height: 60,),
                                                  Text("Hat Trick",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black
                                                    ),),
                                                  SizedBox(height: 10,),
                                                  Text("Donate for the third time.",
                                                    textAlign: TextAlign.center,),
                                                  Spacer(),
                                                  FlatButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                      color: Colors.grey,
                                                      child: Text(
                                                          "Ok"
                                                      )),
                                                  SizedBox(height: 10,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                        snap.data.docs.length>=3

                                            ?Colors.red:
                                        Colors.grey,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        )
                                    ),
                                    width: 110,
                                    height: 110,
                                    child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/hat.png",
                                          width: 60,height: 60,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text("Hat trick",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),


                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.only(left: 20,top: 12,),
                    child: Text("Social",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),

                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  showDialog(context: context,

                                      builder: (context){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Image.asset("assets/logo.png",
                                                    width: 60,height: 60,),
                                                  Text("Blood selfie",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black
                                                    ),),
                                                  SizedBox(height: 10,),
                                                  Text("Change your profile picture.",
                                                    textAlign: TextAlign.center,),
                                                  Spacer(),
                                                  FlatButton(onPressed: ()async{

                                                    await ImagePicker.pickImage(source: ImageSource.camera).then((value) {
                                                      setState(() {
                                                        selfie=true;
                                                      });
                                                    });



                                                  },
                                                      color: Colors.grey,
                                                      child: Text(
                                                          "Ok"
                                                      )),
                                                  SizedBox(height: 10,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                        selfie?Colors.red:
                                        Colors.grey,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        )
                                    ),
                                    width: 110,
                                    height: 110,
                                    child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/selfie.png",
                                          width: 60,height: 60,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text("Blood selfie",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  showDialog(context: context,

                                      builder: (context){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Image.asset("assets/logo.png",
                                                    width: 60,height: 60,),
                                                  Text("Spread it",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black
                                                    ),),
                                                  SizedBox(height: 10,),
                                                  Text("Share the application on any platform.",
                                                    textAlign: TextAlign.center,),
                                                  Spacer(),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      FlatButton(onPressed: (){
                                                        Navigator.pop(context);

                                                      },
                                                          color: Colors.grey,
                                                          child: Text(
                                                              "No"
                                                          )),
                                                      FlatButton(onPressed: (){
                                                        Share.share("Share the app..").
                                                        then((value) {

                                                          setState(() {
                                                            spread=true;
                                                          });
                                                          Navigator.pop(context);

                                                        });

                                                      },
                                                          color: Colors.grey,
                                                          child: Text(
                                                              "Yes"
                                                          )),

                                                    ],
                                                  ),
                                                  SizedBox(height: 10,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                        spread?Colors.red:
                                        Colors.grey,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        )
                                    ),
                                    width: 110,
                                    height: 110,
                                    child:
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/share.png",
                                          width: 60,height: 60,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text("Spread it",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: (){
                                  showDialog(context: context,

                                      builder: (context){
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Image.asset("assets/logo.png",
                                                    width: 60,height: 60,),
                                                  Text("Part of something",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black
                                                    ),),
                                                  SizedBox(height: 10,),
                                                  Text("Part of something.",
                                                    textAlign: TextAlign.center,),
                                                  Spacer(),
                                                  FlatButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                      color: Colors.grey,
                                                      child: Text(
                                                          "Ok"
                                                      )),
                                                  SizedBox(height: 10,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 2
                                        )
                                    ),
                                    width: 110,
                                    height: 110,
                                    child:
                                    Icon(Icons.clean_hands_rounded,
                                      color: Colors.white,size: 35,),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text("Part of something ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );

        },
      ),


    );
  }



}