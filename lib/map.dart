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
class Map extends StatefulWidget {

  final double Latitude;
  final double longitude;
  Map({@required this.Latitude, @required this.longitude});
  @override

  // TODO: implement createState
  MapState createState() => MapState();


}

class MapState extends State<Map>{

  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  @override
  void initState() {
    super.initState();

    polylinePoints = PolylinePoints();

    // set up initial locations
    // this.setInitialLocation();
    getCurrentLoacation();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    List<Marker> allMarkers =[
      Marker (markerId: MarkerId("origin")
        ,position: LatLng(widget.Latitude, widget.longitude)),
      //Marker (markerId: MarkerId("destination")
          //,position: LatLng(double.parse(latitudeData), double.parse(longitudeData)))

    ];

    //throw UnimplementedError();
    return Scaffold(
        appBar:new AppBar(

          title: Text("map"),
          elevation: 0,
          backgroundColor: Colors.red,
        ),
        body: Container (child: GoogleMap(
          polylines: _polylines,
          markers: Set.from(allMarkers),
          initialCameraPosition: CameraPosition(
              target: LatLng (widget.Latitude, widget.longitude),
              zoom: 14.0
          ),
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);

            // showPinsOnMap();
            setPolylines();

          },

        )
        ));
  }
  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDO7kj0wUsMCsVhtzba6rAk-sm7juBpJTU",
        PointLatLng(
          // double.parse(latitudeData),
          //double.parse( longitudeData),
            29.31628847451259, 48.07124545267099
        ),
        PointLatLng(
          widget.Latitude,
          widget.longitude,
        )
    );

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(
            Polyline(
                width: 10,
                polylineId: PolylineId('polyLine'),
                color: Color(0xFF08A5CB),
                points: polylineCoordinates
            )
        );
      });
    }}
  getCurrentLoacation() async{
    final geoposition = await Geolocator().getCurrentPosition( desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitudeData ='${geoposition.latitude}';
      longitudeData ='${geoposition.longitude}';
    });
  }
  String latitudeData ="";
  String longitudeData= "";

}
