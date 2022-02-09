import 'package:bloodDonor/Location.dart';
import 'package:bloodDonor/editProfile.dart';
import 'package:bloodDonor/widgets/Announcement.dart';
import 'package:bloodDonor/widgets/appointments.dart';
import 'package:bloodDonor/widgets/stats_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class AdminTab extends StatefulWidget {
  final String uid;
  AdminTab({@required this.uid});

  @override
  _AdminTabState createState() => _AdminTabState();
}

class _AdminTabState extends State<AdminTab> {
  Widget iconBuild(String status) {
    if (status == "pending") return Icon(Icons.timer);
    return Icon(Icons.check_circle, color: Colors.green);
  }

  String formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }
  int num = 10;

  int _bottomNavBarIndex = 0;
  @override
  Widget build(BuildContext context) {
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
              leading: ClipOval(
                //clipper: MyClipper(),
                child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(userSnapshot.data.get("profilePhoto")),
                    backgroundColor: Colors.white
                )
              ),


              title: (!userSnapshot.hasData)
                  ? const Text('Loading...')
                  : Text(userSnapshot.data.get("name")),
              actions:<Widget> [
                IconButton(icon: Icon(Icons.announcement),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  Announcement(
                                      uid: widget.uid)));
                })
              ],


              elevation: 15,
              backgroundColor: Colors.red,
            ),
            body: StatsGrid()

            ));

  }

}
