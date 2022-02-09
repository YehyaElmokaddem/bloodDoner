import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';
class AppointmentsScreen extends StatefulWidget {
  final String uid;

  AppointmentsScreen({@required this.uid});
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  Widget iconBuild(String status) {
    if (status == "pending") return Icon(Icons.timer,color: Color(0xFFF3D111));
    else if (status == "expired") return Icon(Icons.alarm_off,color: Colors.red);
    return Icon(Icons.check_circle, color: Colors.green);
  }
 bool undo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Appointments'),
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
              .where("user_ID", isEqualTo: widget.uid)
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
                  String date = DateFormat.yMEd().add_jms().format(dateTime);

                  return Slidable(
                    key: Key(index.toString()),
                    actionPane: SlidableDrawerActionPane(),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: "delete",
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () async{
                          if(appointment.get("status") !="pending") {

                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("appointment deleted"),
                            ));

                              FirebaseFirestore.instance.collection("appointments")
                                  .doc(
                                  appointment.id)
                                  .delete().catchError((e){
                                print(e);
                              });
                          if(appointment.get("status")== "done") {
                            CollectionReference counterRef = FirebaseFirestore
                                .instance.collection("counters");
                            QuerySnapshot counterSnapshot = await counterRef
                                .limit(1).get();
                            counterSnapshot.docs.forEach((
                                DocumentSnapshot count) async {
                              int appointments = count.get("appointments") - 1;
                              int done = count.get("done") - 1;

                              FirebaseFirestore.instance.collection("counters")
                                  .doc(count.id).update(
                                  {"appointments": appointments});
                              FirebaseFirestore.instance.collection("counters")
                                  .doc(count.id).update(
                                  {"done": done});
                            });
                          }
                          else if(appointment.get("status")== "expired"){
                            CollectionReference counterRef = FirebaseFirestore
                                .instance.collection("counters");
                            QuerySnapshot counterSnapshot = await counterRef
                                .limit(1).get();
                            counterSnapshot.docs.forEach((
                                DocumentSnapshot count) async {
                              int appointments = count.get("appointments") - 1;
                              int expired = count.get("expired") - 1;

                              FirebaseFirestore.instance.collection("counters")
                                  .doc(count.id).update(
                                  {"appointments": appointments});
                              FirebaseFirestore.instance.collection("counters")
                                  .doc(count.id).update(
                                  {"expired": expired});
                            });
                          }
                          }
                          else{
                            showDialog(
                                context: context,
                                builder: (BuildContext context){return AlertDialog(
                                  title: Text("are you sure you want to cancel your upcoming appointment?"),
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
                                        onPressed: () async{
                                          FirebaseFirestore.instance.collection("appointments")
                                              .doc(
                                              appointment.id)
                                              .delete().catchError((e){
                                            print(e);
                                          });

                                          CollectionReference counterRef = FirebaseFirestore.instance.collection("counters");
                                          QuerySnapshot counterSnapshot = await counterRef.limit(1).get();
                                          counterSnapshot.docs.forEach((DocumentSnapshot count)async {
                                            int appointments = count.get("appointments") -1;
                                            int pending = count.get("pending") -1;

                                            FirebaseFirestore.instance.collection("counters")
                                                .doc(count.id).update(
                                                {"appointments": appointments});
                                            FirebaseFirestore.instance.collection("counters")
                                                .doc(count.id).update(
                                                {"pending": pending});

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
