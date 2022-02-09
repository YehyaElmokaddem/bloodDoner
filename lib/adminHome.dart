import 'package:bloodDonor/admin.dart';
import 'package:bloodDonor/adminAppointments.dart';
import 'package:bloodDonor/badges.dart';
import 'package:bloodDonor/chartsLocation.dart';
import 'package:bloodDonor/locationAppointments.dart';
import 'package:bloodDonor/person.dart';
import 'package:bloodDonor/search.dart';
import 'package:bloodDonor/widgets/NotificationAdmin.dart';
import 'package:bloodDonor/widgets/appointments.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Location.dart';
import 'editProfile.dart';
import 'menu.dart';

class AdminHome extends StatefulWidget {
  final String uid;

  AdminHome({@required this.uid});
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  int num = 10;

  int _bottomNavBarIndex = 0;


  @override
  Widget build(BuildContext context) {
    checkShortage();
    List<Widget> _screen=[
      AdminTab(uid: widget.uid),
      NotificationAdmin(uid: widget.uid),
      //Center(child: Text("Under Development",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
      SearchScreen(uid: widget.uid),
      LocationAppointment(uid: widget.uid),
      ChartsLocation(uid: widget.uid),


    ];
    return Scaffold(
      body: _screen[_bottomNavBarIndex],
      bottomNavigationBar: CurvedNavigationBar(
        //currentIndex: _bottomNavBarIndex ,
        color: Colors.red,
        backgroundColor: Colors.white,
        height: 50,
        buttonBackgroundColor: Colors.grey,
        items: [
          Icon(Icons.person),
          Icon(Icons.notifications),
          //Icon(Icons.add),
          Icon(Icons.search),
          Icon(Icons.list),
          Icon(Icons.bar_chart),
        ],
        index: 0,
        onTap: (index) {
          setState(() {

            _bottomNavBarIndex = index;

          });
          debugPrint("$index  $_bottomNavBarIndex");
        },
      ),
    );
  }
  Future<void>  checkShortage() async
  {

    CollectionReference userRef = FirebaseFirestore.instance.collection("Blood");
    QuerySnapshot userSnapshot = await userRef.get();
    userSnapshot.docs.forEach((DocumentSnapshot location)async {

      String bloodType = "";
      if(location.get("A+") < location.get("threshold"))
      {
        createShortage(location.get("location_ID"), "A+");
      }
      if(location.get("A-") < location.get("threshold"))
      {
        createShortage(location.get("location_ID"), "A-");
      }
      if(location.get("AB+") < location.get("threshold"))
      {
        createShortage(location.get("location_ID"), "AB+");
      }
      if(location.get("AB-") < location.get("threshold"))
      {
        createShortage(location.get("location_ID"), "AB-");
      }
      if(location.get("B+") < location.get("threshold"))
      {
        createShortage(location.get("location_ID"), "B+");
      }
      if(location.get("B-") < location.get("threshold"))
      {
        createShortage(location.get("location_ID"), "B-");
      }
      if(location.get("O+") < location.get("threshold"))
      {
        createShortage(location.get("location_ID"), "O+");
      }
      if(location.get("O-") < location.get("threshold"))
      {
        createShortage(location.get("location_ID"), "O-");
      }

    });
  }

  Future<void> createShortage(String location,String bloodType) async {

    String message = "there is a shortage in "+bloodType+" blood type at "+location;
    bool create = true;
    DateTime now = DateTime.now();
    CollectionReference userRef = FirebaseFirestore.instance.collection("notifications");
    QuerySnapshot userSnapshot = await userRef.where("type",isEqualTo: "shortage").get();
    userSnapshot.docs.forEach((DocumentSnapshot sho)async {
      if(sho.get("content")== message) {
        Timestamp timestamp = sho.get("time") as Timestamp;
        DateTime dateTime = timestamp.toDate();
        Duration diff = now.difference(dateTime);
        if(diff.inHours > 24) {
          await FirebaseFirestore.instance.collection('notifications').add({
            'content': message,
            'time': now,
            'user_ID': "Zy6qMjl5Umf2IUNbhrc5wGk2NpJ3",
            'cleared': false,
            'type': "shortage"
          });

        }

        create = false;
      }
    });
    if(create == true){
    await FirebaseFirestore.instance.collection('notifications').add({
    'content': message,
    'time': now,
    'user_ID': "Zy6qMjl5Umf2IUNbhrc5wGk2NpJ3",
    'cleared': false,
    'type': "shortage"
    });
    }
  }
}
