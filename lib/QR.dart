import 'package:bloodDonor/Location.dart';
import 'package:bloodDonor/editProfile.dart';
import 'package:bloodDonor/widgets/appointments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QR extends StatefulWidget {
  final String appID;
  QR({@required this.appID});

  @override
  _QRState createState() => _QRState();
}

class _QRState extends State<QR> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: new AppBar(
        title: Text("QR Code"),
        elevation: 15,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[ SizedBox(
          height: 60,
        ),
          QrImage(
          data: widget.appID,
        ),

        ]
      )
    );

  }
}
