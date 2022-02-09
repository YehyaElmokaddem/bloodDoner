import 'dart:io';

import 'package:bloodDonor/Charts.dart';
import 'package:bloodDonor/adminAppointments.dart';
import 'package:bloodDonor/adminHome.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bloodDonor/map.dart';


class ChartsLocation extends StatefulWidget {
  final String uid;

  ChartsLocation({@required this.uid});
  @override
  _ChartsLocationState createState() => _ChartsLocationState();
}

class _ChartsLocationState extends State<ChartsLocation> {
  var counter = [0,0,0,0,0,0,0];
  bool complete = false;
  int _bottomNavBarIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: GestureDetector(child: Icon(Icons.list),onTap: (){
          Navigator.pop(context);
        },),
        title: Text('Charts'),
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
                                FlatButton.icon(icon: Icon(Icons.list),
                                  onPressed: (){
                                    fetch(Locations.get("locationName"));
                                    //while(!complete){debugPrint("not");}
                                    sleep(const Duration(seconds:1));
                                    debugPrint("$counter");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                Charts(uid: widget.uid, location: Locations.get("locationName"), counter: counter)));

                                  },
                                  label: Text("View Charts"),
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
  /*Future<void> createChart(String location) async {

    counter = [0,0,0,0,0,0,0];
    DateTime now = DateTime.now();

    CollectionReference userRef = FirebaseFirestore.instance.collection("appointments");
    QuerySnapshot userSnapshot = await userRef.where("location_ID",isEqualTo: location).where("status",isEqualTo: "done").get();
    userSnapshot.docs.forEach((DocumentSnapshot app)async {

      Timestamp timestamp = app.get("time") as Timestamp;
      DateTime dateTime = timestamp.toDate();
      Duration diff = now.difference(dateTime);
      if(now.isAfter(dateTime))
      {
        if(diff.inDays == 0)
        {
          setState(() {
            counter[6]++;
          });

        }
        else if(diff.inDays == 1)
        {
          setState(() {
            counter[5]++;
          });
        }
        else if(diff.inDays == 2)
        {
          setState(() {
            counter[4]++;
          });
        }
        else if(diff.inDays == 3)
        {
          setState(() {
            counter[3]++;
          });
        }
        else if(diff.inDays == 4)
        {
          setState(() {
            counter[2]++;
          });
        }
        else if(diff.inDays == 5)
        {
          setState(() {
            counter[1]++;
          });
        }
        else if(diff.inDays == 6)
        {
          setState(() {
            counter[0]++;
          });
        }
      }

    });
    complete = false;
debugPrint("first");
  }*/
  Future<bool> createChart(String location)=> Future.delayed(Duration(seconds: 1), ()
  {
    counter = [0,0,0,0,0,0,0];
    DateTime now = DateTime.now();

      FirebaseFirestore.instance
      .collection("appointments").where("location_ID",isEqualTo: location).where("status",isEqualTo: "done").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot app) {

      Timestamp timestamp = app.get("time") as Timestamp;
      DateTime dateTime = timestamp.toDate();
      Duration diff = now.difference(dateTime);
      if(now.isAfter(dateTime))
      {
        if(diff.inDays == 0)
        {
          setState(() {
            counter[6]++;
          });

        }
        else if(diff.inDays == 1)
        {
          setState(() {
            counter[5]++;
          });
        }
        else if(diff.inDays == 2)
        {
          setState(() {
            counter[4]++;
          });
        }
        else if(diff.inDays == 3)
        {
          setState(() {
            counter[3]++;
          });
        }
        else if(diff.inDays == 4)
        {
          setState(() {
            counter[2]++;
          });
        }
        else if(diff.inDays == 5)
        {
          setState(() {
            counter[1]++;
          });
        }
        else if(diff.inDays == 6)
        {
          setState(() {
            counter[0]++;
          });
        }
      }

      });
      });
    return true;
  });
  void fetch(String location) async {
    bool hasData = await createChart(location);
  }
}
