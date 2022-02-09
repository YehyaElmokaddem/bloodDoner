import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bloodDonor/viewProfile.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';

class RequestsScreen extends StatefulWidget {
  final String uid;

  RequestsScreen({@required this.uid});
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  Widget iconBuild(String status) {
    if (status == "pending") return Icon(Icons.timer,color: Color(0xFFF3D111));
    return Icon(Icons.check_circle, color: Colors.green);
  }
  bool undo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 15,
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
                      Row(
                          children: <Widget>[ Text("Requests",
                              style:
                              TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left),
                            SizedBox(
                              width: 150.0,
                            ),
                            FlatButton.icon(icon: Icon(Icons.add_alert),
                              onPressed: () async{
                                clearAll();

                              },
                              label: Text("Clear All",textAlign: TextAlign.right),
                            )
                          ])
                    ]),
              )),
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("notifications")
              .where("type", isEqualTo: "request")
              .where("cleared", isEqualTo: false)
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
                  DocumentSnapshot request = snapshot.data.docs[index];
                  Timestamp timestamp = request.get("time") as Timestamp;
                  DateTime dateTime = timestamp.toDate();
                  String date = DateFormat.yMEd().add_jms().format(dateTime);

                  return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .doc(request.get("user_ID"))
                      .snapshots(),
                  builder: ((context, snapshot) {
                  if (!snapshot.hasData)
                  return CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  backgroundColor: Colors.grey,
                  );

                  return  Slidable(
                        key: Key(index.toString()),
                        actionPane: SlidableDrawerActionPane(),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: "Clear",
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: (){
                              FirebaseFirestore.instance.collection("notifications").doc(
                                  request.id).update(
                                  {"cleared": true});
                            },
                          )
                        ],
                        actionExtentRatio: 1/5,
                        child: Card(
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
                            leading: GestureDetector(
                              child: ClipOval(
                              //clipper: MyClipper(),
                              child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(snapshot.data.get("profilePhoto")),
                              backgroundColor: Colors.white
                              ),
                              ), onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ViewProfilePage(uid: widget.uid, viewID: request.get("user_ID"))));
                            },
                            ),
                            title: Text(snapshot.data.get("name"),
                            style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                              trailing: Text("Civil ID: "+snapshot.data.get("civil_ID")),

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
                                        child: Text("Phone number: "+snapshot.data.get("phoneNumber"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20))),
                                    Expanded(
                                      child: Text(date,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                    );
                  }
                  )
                  );
                },
              ),
            );
          }),
        ),
      ]),
    );
  }

  void clearAll() async{
    CollectionReference appRef = FirebaseFirestore.instance.collection("notifications");
    QuerySnapshot apSnapshot = await appRef.get();
    apSnapshot.docs.forEach((DocumentSnapshot doc)async {

        FirebaseFirestore.instance.collection("notifications").doc(
            doc.id).update(
            {"cleared": true});

    });
  }


}
