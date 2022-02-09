import 'package:bloodDonor/QR.dart';
import 'package:bloodDonor/viewProfile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';

class AdminAppointmentsScreen extends StatefulWidget {
  final String uid;
  final String location;

  AdminAppointmentsScreen({@required this.uid,@required this.location });
  @override
  _AdminAppointmentsScreenState createState() => _AdminAppointmentsScreenState();
}

class _AdminAppointmentsScreenState extends State<AdminAppointmentsScreen> {
  Widget iconBuild(String status) {
    if (status == "pending") return Icon(Icons.timer,color: Color(0xFFF3D111));
    return Icon(Icons.check_circle, color: Colors.green);
  }

  bool undo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(widget.location),
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
                      Text("Pending Appointment",
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
              .where("status", isEqualTo: "pending")
              .where("location_ID", isEqualTo: widget.location)
              .orderBy("time")
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
                  String date = DateFormat.yMEd().add_jms().format(dateTime);

    return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection("Users")
        .doc(appointment.get("user_ID"))
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
                          caption: "delete",
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: (){
                            if(appointment.get("status") =="pending") {

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){return AlertDialog(
                                    title: Text("are you sure you want to cancel this pending appointment?"),
                                    actions: <Widget>[
                                      MaterialButton(
                                          elevation: 5.0,
                                          child: Text("Cancel"),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          }),
                                      MaterialButton(
                                          elevation: 5.0,
                                          child: Text("Delete"),
                                          onPressed: (){
                                            FirebaseFirestore.instance.collection("appointments")
                                                .doc(
                                                appointment.id)
                                                .delete().catchError((e){
                                              print(e);
                                            });
                                            Navigator.pop(context);
                                          }),

                                    ],
                                  );}
                              );

                            }
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
                                            ViewProfilePage(uid: widget.uid, viewID: appointment.get("user_ID"))));
                              }
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
                                      child: Text(date,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20))),

                                  FlatButton.icon(icon: Icon(Icons.qr_code_scanner_rounded),
                                    onPressed: () async{
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  QR(
                                                      appID: appointment.id)));

                                    },
                                    label: Text("Confirm",textAlign: TextAlign.right),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                  );}
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


}
