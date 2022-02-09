import 'package:bloodDonor/badges.dart';
import 'package:bloodDonor/person.dart';
import 'package:bloodDonor/widgets/NotificationUser.dart';
import 'package:bloodDonor/widgets/appointments.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Location.dart';
import 'editProfile.dart';
import 'menu.dart';

class Home extends StatefulWidget {
  final String uid;

  Home({@required this.uid});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget iconBuild(String status) {
    if (status == "pending") return Icon(Icons.timer);
    return Icon(Icons.check_circle, color: Colors.green);
  }

  String formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }
 int num = 10;

  int _bottomNavBarIndex = 0;


  @override
  Widget build(BuildContext context) {
    List<Widget> _screen=[
      PersonTab(uid: widget.uid),
      NotificationUser(uid: widget.uid),
      Location(uid: widget.uid),
      Badge(uid: widget.uid),
      Menu(uid: widget.uid),


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
          Icon(Icons.add),
          Icon(Icons.star),
          Icon(Icons.menu),
        ],
        index: 0,
        onTap: (index) {
          setState(() {

              _bottomNavBarIndex = index;

            // if(index == 4)
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (_) =>
            //               Menu(
            //                   uid: widget.uid)));
            // if(index == 2)
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (_) =>
            //               Location(
            //                   uid: widget.uid)));
          });
          debugPrint("$index  $_bottomNavBarIndex");
        },
      ),
    );
  }
}
