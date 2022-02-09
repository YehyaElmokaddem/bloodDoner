import 'package:bloodDonor/Location.dart';
import 'package:bloodDonor/widgets/appointments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import 'authentication/auth.dart';
import 'authentication/onboard.dart';
import 'editProfile.dart';
import 'home_screen.dart';
import 'organizations.dart';


class Menu extends StatefulWidget {
  final String uid;
  Menu({@required this.uid});
  @override

  // TODO: implement createState
  MenuState createState() => MenuState();



}

class MenuState extends State<Menu>{
  int _bottomNavBarIndex = 4;
  void share (BuildContext context){
    final RenderBox box = context.findRenderObject();
    final String text = "https://blooddonorkuwait.000webhostapp.com/#";
    Share.share(text, sharePositionOrigin: box.localToGlobal(Offset.zero)& box.size );

  }
  Material MyItems(IconData icon, String heading , Color color){

    return Material(
      color: Colors.white,
      elevation: 15.0 ,
      shadowColor: Colors.black12,
      borderRadius: BorderRadiusDirectional.circular(24.0),
      child:Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(heading, style:TextStyle(color: color , fontSize: 15.0),),
                        ),
                      ),
                      Material(
                        color: color,
                        borderRadius: BorderRadius.circular(24.0) ,
                        child:Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ) ,
                      )
                    ],

                  )
                ],
              )
          )
      ),

    );

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();
    return Scaffold(
      appBar: new AppBar(
        leading: Icon(Icons.menu),
        title: Text("Menu"),
        elevation: 15,
        backgroundColor: Colors.red,
      ),
      body: StaggeredGridView.count(crossAxisCount:  2, crossAxisSpacing: 12.0 , mainAxisSpacing: 12.0,
        padding:EdgeInsets.symmetric(horizontal: 16.0 ,vertical: 8.0) , children: <Widget> [
          GestureDetector(child: MyItems(Icons.person,"PROFILE",Colors.red),onTap:() {Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      EditProfilePage(
                          uid: widget.uid)));}),
          //MyItems(Icons.add,"DONATE",Colors.red),
          //MyItems(Icons.notifications,"NOTIFICATIONS",Colors.red),
          GestureDetector(child: MyItems(Icons.local_hospital,"ORGANAIZATIONS",Colors.red), onTap:() {Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      organizations(
                          uid: widget.uid)));}),
          //MyItems(Icons.star,"BADGES",Colors.red),
          GestureDetector(child: MyItems(Icons.history,"HISTORY",Colors.red), onTap:() {Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      AppointmentsScreen(
                          uid: widget.uid)));},),
          //MyItems(Icons.wallet_giftcard,"CREDITS",Colors.red),
          //MyItems(Icons.settings,"SETTINGS",Colors.red),
          GestureDetector(child: MyItems(Icons.share,"SHARE",Colors.red),onTap:() async {share(context);} ,),




        ], staggeredTiles: [
          StaggeredTile.extent(2, 150.0),
          //StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          // StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          //StaggeredTile.extent(1, 150.0),
          //StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),

        ],
      ),

    );
  }



}