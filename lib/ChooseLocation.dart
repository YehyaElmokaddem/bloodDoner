import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bloodDonor/map.dart';
import 'package:bloodDonor/TimeScreen.dart';

import 'menu.dart';
class ChooseLocation extends StatefulWidget {
  final String uid;

  ChooseLocation({@required this.uid});
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  int _bottomNavBarIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Locations'),
        elevation: 0,
        backgroundColor: Colors.red,
      ),
      body: Column(children: <Widget>[
        Center(
          child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Choose Location",
                          style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      SizedBox(
                        height: 6.0,
                      ),
                    ]),
              )),
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("location")
              .orderBy("locationName")
              .snapshots(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData)
              return CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                backgroundColor: Colors.grey,
              );
            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot Locations = snapshot.data.docs[index];



                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    elevation: 10,
                    margin: EdgeInsets.all(7),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon (Icons.home_work_sharp),
                          title: Text(Locations.get("locationName"),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            //shape: BoxShape.circle,
                            //border: Border.all(color: Colors.black,width: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.all(12.5),
                          padding: const EdgeInsets.all(1.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton.icon(icon: Icon(Icons.gps_fixed),
                                  onPressed: (){
                                    double latitude = double.parse(Locations.get("latitude"));
                                    double longitude= double.parse(Locations.get("longitude"));
                                    //Marker coordinates = Marker (markerId: MarkerId(Locations.get("locationName"))
                                    // ,position: LatLng(double.parse(Locations.get("latitude")), double.parse(Locations.get("longitude"))));

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                Map ( Latitude: latitude, longitude: longitude)));}

                                  ,
                                  label: Text("View Location"),
                                ),
                                FlatButton.icon(icon: Icon(Icons.add),
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                TimeScreen (uid: widget.uid, location: Locations.get("locationName"))));
                                  },
                                  label: Text("Choose this Location"),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ]),

    );
  }
}
