import 'package:bloodDonor/Location.dart';
import 'package:bloodDonor/editProfile.dart';
import 'package:bloodDonor/widgets/appointments.dart';
import 'package:bloodDonor/widgets/stats_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';


class AnnouncementUser extends StatefulWidget {

  final String uid;
  AnnouncementUser({@required this.uid});

  @override
  _AnnouncementUserState createState() => _AnnouncementUserState();
}

class _AnnouncementUserState extends State<AnnouncementUser> {


  int num = 10;

  int _bottomNavBarIndex = 0;

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(widget.uid)
            .snapshots(),
        builder: (_, AsyncSnapshot<DocumentSnapshot> userSnapshot) => userSnapshot.data == null

            ? SizedBox(height: 10)
            :Scaffold(
          //backgroundColor: Colors.grey[200],
          appBar: new AppBar(

            title: Text("Announcments"),
            elevation: 15,
            backgroundColor: Colors.red,
          ),

          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Container(
                child: Column(
                  children: <Widget>[

                    Center(
                      child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text("Announcements",
                                      style:
                                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center),


                                ]),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("notifications")
                          .where("type", isEqualTo: "announcement")
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
                              DocumentSnapshot announcement = snapshot.data.docs[index];
                              Timestamp timestamp = announcement.get("time") as Timestamp;
                              DateTime dateTime = timestamp.toDate();
                              String date = DateFormat.yMd().add_jm().format(dateTime);

                              return Slidable(
                                  key: Key(index.toString()),
                                  actionPane: SlidableDrawerActionPane(),
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: "clear",
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () async{

                                        Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text("Announcement cleared"),
                                        ));

                                        FirebaseFirestore.instance.collection("notifications").doc(
                                            announcement.id).update(
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

                                          title: Text("",
                                              style: TextStyle(
                                                  fontSize: 20, fontWeight: FontWeight.bold)),
                                          trailing: Text(date),
                                          leading: Icon(Icons.message,color: Colors.red,),
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
                                                  child: Text(announcement.get("content"),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontSize: 20))),

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
                    )
                  ],
                )
            ),
          ),

        ));

  }
}
