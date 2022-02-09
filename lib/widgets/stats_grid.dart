import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  @override

  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("counters")
            .limit(1)
            .snapshots(),
        builder: ((context, snapshot) =>
        !snapshot.hasData
            ?  CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              backgroundColor: Colors.grey,
            )
          : Container(
      height: MediaQuery.of(context).size.height * 0.75  ,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard("total users", snapshot.data.docs.first.data()['users'].toString(), Colors.orange),
                Icon(Icons.person, color: Colors.blue),

              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[

                Icon(Icons.list,color: Colors.orange),
                _buildStatCard('total appointments',snapshot.data.docs.first.data()['appointments'].toString() , Colors.blue),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[

                _buildStatCard('Done', snapshot.data.docs.first.data()['done'].toString(), Colors.green),
                Icon(Icons.check_circle,color: Colors.green),

              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[

                Icon(Icons.timer,color: Colors.grey),
                _buildStatCard('Pending', snapshot.data.docs.first.data()['pending'].toString(), Colors.grey),

              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[

                _buildStatCard('Expired', snapshot.data.docs.first.data()['expired'].toString(), Colors.red),
                Icon(Icons.alarm_off,color: Colors.red),

              ],
            ),
          ),

        ],
      ),
    )
        ),
    );
  }

  Expanded _buildStatCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

}