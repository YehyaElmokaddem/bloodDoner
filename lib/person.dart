import 'package:bloodDonor/Location.dart';
import 'package:bloodDonor/editProfile.dart';
import 'package:bloodDonor/widgets/appointments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';

class PersonTab extends StatefulWidget {
  final String uid;
  PersonTab({@required this.uid});

  @override
  _PersonTabState createState() => _PersonTabState();
}


class _PersonTabState extends State<PersonTab> {
  Stream status;
  bool isbtnEnable = false;
  Future<void> btnEnableDisable() async {
    status = FirebaseFirestore.instance.collection('appointments').where('user_ID', isEqualTo: widget.uid).snapshots();
    status.listen((event) {
      if (event.docs.any((element) => element['status'] == 'pending')) {
        setState(() {
          isbtnEnable = false;
        });
      } else {
        setState(() {
          isbtnEnable = true;
        });
      }
    });
  }
  Widget iconBuild(String status) {
    if (status == "pending") return Icon(Icons.timer);
    return Icon(Icons.check_circle, color: Colors.green);
  }

  String formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }
  int num = 10;
  String qrCodeResult = "Not Yet Scanned";

  int _bottomNavBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    checkExpired(widget.uid);
    btnEnableDisable();
    return StreamBuilder(
        stream: FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.uid)
        .snapshots(),
    builder: (_, AsyncSnapshot<DocumentSnapshot> userSnapshot) => userSnapshot.data == null

        ? SizedBox(height: 10)
        :Scaffold(
    backgroundColor: Colors.grey[200],
    appBar: new AppBar(
    leading: GestureDetector(child: ClipOval(
    //clipper: MyClipper(),
    child: CircleAvatar(
    radius: 25,
    backgroundImage: NetworkImage(userSnapshot.data.get("profilePhoto")),
    backgroundColor: Colors.white
    ),
    ),onTap:() {Navigator.push(
    context,
    MaterialPageRoute(
    builder: (_) =>
    EditProfilePage(
    uid: widget.uid)));}),

    title: (!userSnapshot.hasData)
    ? const Text('Loading...')
        : Text(userSnapshot.data.get("name")),
    actions: [
    Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text('Blood type', style: TextStyle(color: Colors.grey[300])),
    userSnapshot.hasData
    ? Text('${userSnapshot.data.data()['bloodType']}',
    style: TextStyle(fontWeight: FontWeight.bold))
        : SizedBox(),
    ],
    ),
    ),
    ],
    elevation: 15,
    backgroundColor: Colors.red,
    ),
    body: Center(
      child: Column(
      children: [
      /// [Make a  donation widget]
      Container(
      constraints: BoxConstraints(),
      margin: EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
      BoxShadow(
      color: Colors.grey[400],
      offset: Offset(3.0, 3.0),
      blurRadius: 3.0,
      ),
      ],
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Padding(
      padding: EdgeInsets.all(15),
      child: Text("Make a donation"),
      ),
      Expanded(
      child: Container(
      padding:
      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      margin:
      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
      children: [
      Text(
      'Each donation can save up to three lives.',
      style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 5),
      Text(
      'Every 2 seconds someone needs blood',
      style: TextStyle(fontSize: 12),
      ),
      Expanded(
      child: Image.network(
      'https://ichef.bbci.co.uk/news/800/cpsprodpb/182FF/production/_107317099_blooddonor976.jpg'),
      ),
        Container(
          width: double.infinity,
          child: RaisedButton(
            color: isbtnEnable ? Colors.red : Colors.grey,
            onPressed: () {
              isbtnEnable ? Navigator.push(context, MaterialPageRoute(builder: (_) => Location(uid: widget.uid))) : () {};
            },
            child: Text(
              isbtnEnable ? 'SCHEDULE NEW APPPOINTMENT' : 'Appointment Pending',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
      ),
      ),
      ),
      ],
      ),
      ),

      /// [Appointment request is pending widget]
      StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where("user_ID", isEqualTo: widget.uid)
          .where('status', isEqualTo: 'pending')
          .limit(1)
          .snapshots(),
      builder: (_, AsyncSnapshot<QuerySnapshot> appointmentSnapshot) =>
      appointmentSnapshot.data == null
          || appointmentSnapshot.data.docs.isEmpty
      ? SizedBox(height: 10)
          : Container(
      height: MediaQuery.of(context).size.height * 0.18,
      width: double.infinity,
      decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
      BoxShadow(
      color: Colors.grey[400],
      offset: Offset(3.0, 3.0),
      blurRadius: 3.0,
      ),
      ],
      ),
      padding: EdgeInsets.symmetric(
      horizontal: 15, vertical: 10),
      child: Row(
      children:[ Expanded(
      child: Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
            caption: "Confirm",
            color: Colors.yellow,
            icon: Icons.qr_code_scanner,
            onTap: () async{
              String codeSanner = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.DEFAULT);   //barcode scnner
              setState(() {
                qrCodeResult = codeSanner;
              });

              if (appointmentSnapshot.data.docs.first.id == qrCodeResult)
                {

                  Timestamp timestamp = appointmentSnapshot.data.docs.first.get("time") as Timestamp;
                  DateTime dateTime = timestamp.toDate();
                  DateTime now = DateTime.now();
                  Duration diff = now.difference(dateTime);
                  if(diff.inHours <= 24 && diff.inHours >= 0)
                    {
                      FirebaseFirestore.instance.collection("appointments").doc(
                          appointmentSnapshot.data.docs.first.id).update(
                          {"status": "done"});
                      showDialog(
                          context: context,
                          builder: (BuildContext context){return AlertDialog(
                            title: Text(
                                "appointment confirmed successfully"),

                          );});

                      CollectionReference counterRef = FirebaseFirestore.instance.collection("counters");
                      QuerySnapshot counterSnapshot = await counterRef.limit(1).get();
                      counterSnapshot.docs.forEach((DocumentSnapshot count)async {
                        int pending = count.get("pending") -1;
                        int done = count.get("done") +1;

                        FirebaseFirestore.instance.collection("counters")
                            .doc(count.id).update(
                            {"pending": pending});
                        FirebaseFirestore.instance.collection("counters")
                            .doc(count.id).update(
                            {"done": done});

                      });
                    }
                  else{
                    showDialog(
                        context: context,
                        builder: (BuildContext context){return AlertDialog(
                      title: Text(
                          "Sorry, the confirmation has to be done within 24 hours from the appointment time"),

                    );});
                  }
                }
              else
                {
                  showDialog(
                      context: context,
                      builder: (BuildContext context){return AlertDialog(
                        title: Text(
                            "Sorry, this is not the correct QR code for your appointment"),

                      );});
                }
            }
        ),
      IconSlideAction(
      caption: "delete",
      color: Colors.red,
      icon: Icons.delete,
      onTap: (){

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
      appointmentSnapshot.data.docs.first.id)
          .delete().catchError((e){
      print(e);
      });
    CollectionReference counterRef = FirebaseFirestore.instance.collection("counters");
    QuerySnapshot counterSnapshot = await counterRef.limit(1).get();
    counterSnapshot.docs.forEach((DocumentSnapshot count)async {
    int pending = count.get("pending") -1;
    int appointments = count.get("appointments") -1;

    FirebaseFirestore.instance.collection("counters")
        .doc(count.id).update(
    {"pending": pending});
    FirebaseFirestore.instance.collection("counters")
        .doc(count.id).update(
    {"appointments": appointments});
    });
      Navigator.pop(context);
      }),

      ],
      );}
      );


      },
      ),

      ],
      actionExtentRatio: 1/5,
      child: Container(
      decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
      Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceAround,
      children: [
      Icon(Icons.timer,
      color: Color(0xFFF3D111)),
      Text(
      'Appointment Request is pending',
      style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      ),
      ),
      SizedBox(),
      ],
      ),
      Expanded(
      child: Container(
      padding:
      EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
      ),
      decoration: BoxDecoration(
      border:
      Border.all(color: Colors.grey[400]),
      color: Colors.white,
      ),
      child: Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
      Text(DateFormat.jm().format(appointmentSnapshot.data.docs.first.data()['time'].toDate())),
      Container(
      padding: EdgeInsets.symmetric(
      vertical: 5),
      child: VerticalDivider(
      color: Colors.red),
      ),
      Text(
      '${appointmentSnapshot.data.docs.first.data()['location_ID']}'),
      Container(
      padding: EdgeInsets.symmetric(
      vertical: 5),
      child: VerticalDivider(
      color: Colors.red),
      ),
      Text(
      '${formatTime(appointmentSnapshot.data.docs.first.data()['time'] as Timestamp)}'),
      ],
      ),
      ),
      ),
      Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
      onTap: () {
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (_) =>
      AppointmentsScreen(
      uid: userSnapshot
          .data.id)));
      },
      child: Text(
      'VIEW ALL APPOINTMENTS',
      style: TextStyle(
      decoration: TextDecoration.underline,
      color: Colors.red,
      fontSize: 8,
      ),
      ),
      ),
      ),
      ],

      ),
      ),
      ),
      ),
      ]
      ),
      ),
      ),
      ],
      ),
    )));
  }

  Future<void>  checkExpired(String userID) async
  {

    CollectionReference userRef = FirebaseFirestore.instance.collection("Users");
    QuerySnapshot userSnapshot = await userRef.get();
    userSnapshot.docs.forEach((DocumentSnapshot user)async {

      CollectionReference appRef = FirebaseFirestore.instance.collection("appointments");
      QuerySnapshot apSnapshot = await appRef.where("user_ID", isEqualTo: user.id).where("status", isEqualTo: "pending").get();
      apSnapshot.docs.forEach((DocumentSnapshot doc)async {

        Timestamp timestamp = doc.get("time") as Timestamp;
        DateTime dateTime = timestamp.toDate();
        DateTime now = DateTime.now();
        Duration diff = now.difference(dateTime);
        if(diff.inHours > 24)
        {
          FirebaseFirestore.instance.collection("appointments")
              .doc(doc.id).update(
              {"status": "expired"});

          await FirebaseFirestore.instance.collection('notifications').add({
            'content': 'your scheduled appointment expired',
            'time': now,
            'user_ID':doc.id,
            'cleared' : false,
            'type': "expired"
          });

          CollectionReference counterRef = FirebaseFirestore.instance.collection("counters");
          QuerySnapshot counterSnapshot = await counterRef.limit(1).get();
          counterSnapshot.docs.forEach((DocumentSnapshot count)async {
            int pending = count.get("pending") -1;
            int expired = count.get("expired") +1;

            FirebaseFirestore.instance.collection("counters")
                .doc(count.id).update(
                {"pending": pending});
            FirebaseFirestore.instance.collection("counters")
                .doc(count.id).update(
                {"expired": expired});

          });

        }




      });

    });
  }
}
