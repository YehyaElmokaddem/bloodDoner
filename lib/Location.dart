import 'package:flutter/cupertino.dart';


import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share/share.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bloodDonor/map.dart';
import 'package:bloodDonor/ChooseLocation.dart';
import 'package:bloodDonor/fullMap.dart';

import 'home_screen.dart';
import 'menu.dart';
class Location extends StatefulWidget {
  final String uid;
  Location({@required this.uid});
  @override

  // TODO: implement createState
  LocationState createState() => LocationState();



}

class LocationState extends State<Location>{
  int _bottomNavBarIndex = 4;
  String latitudeData ="";
  String longitudeData= "";
  @override
  void initState(){
    super.initState();
    getCurrentLoacation();
  }
  getCurrentLoacation() async{
    final geoposition = await Geolocator().getCurrentPosition( desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitudeData ='${geoposition.latitude}';
      longitudeData ='${geoposition.longitude}';
    });
  }

  Material MyItems(IconData icon, String heading , Color color){

    return Material(
      color: Colors.white,
      elevation: 14.0 ,
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
      appBar:AppBar(
          //leading: Icon(Icons.add),
          backgroundColor: Colors.red,
          title: Text('Schedule appointment',
            style: TextStyle ( color: Colors.white,),
          ),
        elevation: 15,
      ),
      body: StaggeredGridView.count(crossAxisCount:  2, crossAxisSpacing: 12.0 , mainAxisSpacing: 12.0,
        padding:EdgeInsets.symmetric(horizontal: 16.0 ,vertical: 8.0) , children: <Widget> [
          GestureDetector(child: MyItems(Icons.location_city,"View all locations",Colors.red),onTap:(){Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      fullMap()));},),
          //MyItems(Icons.add,"DONATE",Colors.red),
          GestureDetector(child: MyItems(Icons.search,"Choose a location",Colors.red),onTap: (){Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ChooseLocation(uid: widget.uid)));}),
          //MyItems(Icons.local_hospital,"ORGANAIZATIONS",Colors.red),
          //MyItems(Icons.badge,"BADGES",Colors.red),
          //MyItems(Icons.history,"HISTORY",Colors.red),
          //MyItems(Icons.wallet_giftcard,"CREDITS",Colors.red),
          //MyItems(Icons.settings,"SETTINGS",Colors.red),
          //GestureDetector(child: MyItems(Icons.share,"SHARE",Colors.red),onTap:() {share(context);} ,),



        ], staggeredTiles: [
          StaggeredTile.extent(2, 150.0),
          //StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(2, 150.0),
          // StaggeredTile.extent(1, 150.0),
          //StaggeredTile.extent(1, 150.0),
          //StaggeredTile.extent(1, 150.0),
          //StaggeredTile.extent(1, 150.0),
          //StaggeredTile.extent(1, 150.0),
          //StaggeredTile.extent(1, 150.0),
        ],
      ),


    );
  }



}