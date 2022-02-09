import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  int _bottomNavBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: Image.asset('assets/logo.png'),
        title: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(widget.uid)
              .snapshots(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return Text(snapshot.data.get("name"));
          }),
        ),
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
                  Text("Appointment History",
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
              .collection("appointments")
              .orderBy("time", descending: true)
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
                  DocumentSnapshot appointment = snapshot.data.docs[index];
                  Timestamp timestamp = appointment.get("time") as Timestamp;
                  DateTime dateTime = timestamp.toDate();
                  String date = dateTime.day.toString() +
                      "/" +
                      dateTime.month.toString() +
                      "/" +
                      dateTime.year.toString();

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: Colors.white,
                    elevation: 10,
                    margin: EdgeInsets.all(7),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: iconBuild(appointment.get("status")),
                          title: Text(appointment.get("status"),
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
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(date,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20))),
                              Expanded(
                                child: Text(appointment.get("location_ID"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ],
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
        onTap: (index) {
          setState(() {
            _bottomNavBarIndex = index;
          });
          debugPrint("$index  $_bottomNavBarIndex");
        },
      ),
    );
  }
}
