import 'dart:async';

import 'package:bloodDonor/Location.dart';
import 'package:bloodDonor/widgets/appointments.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'editProfile.dart';
import 'home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
class fullMap extends StatefulWidget {


  @override

  // TODO: implement createState
  fullMapState createState() => fullMapState();


}

class fullMapState extends State<fullMap>{

  Completer<GoogleMapController> _controller = Completer();
  @override
  void initState() {
    super.initState();
    //fetch();
  }
  double lat = 0;
  double long =0;
  List<Marker> allMarkers =[];
  Future<bool> buildMarkers()=> Future.delayed(Duration(seconds: 1), ()
  {
    allMarkers.clear();
    FirebaseFirestore.instance
        .collection("location").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot doc) {
        lat = double.parse(doc.data()['latitude']);
        long = double.parse(doc.data()['longitude']);
        setState(() {
          allMarkers.add(
              Marker (markerId: MarkerId(doc.data()['locationName'])
                  ,position: LatLng(lat,long))
          );
        });

        //debugPrint("$lat  $long");
        //debugPrint("$allMarkers");
      });
    });
    return true;
  });
  void fetch() async {
    bool hasData = await buildMarkers();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    fetch();
     //debugPrint("$Markers");
    return Scaffold(
        appBar:new AppBar(

          title: Text("All locations"),
          elevation: 0,
          backgroundColor: Colors.red,
        ),
        body: Container (child: GoogleMap(
          markers: Set.from(allMarkers),
          initialCameraPosition: CameraPosition(
              target: LatLng (29.39039281747301, 47.97631187860718),
              zoom: 10.0
          ),
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);

            {

              _controller.complete(controller);
            }



          },


        )
        ));
  }


}
