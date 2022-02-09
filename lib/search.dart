import 'package:bloodDonor/requests.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:bloodDonor/viewProfile.dart';

class SearchScreen extends StatefulWidget {
  final String uid;

  SearchScreen({@required this.uid});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  Future<void> createRequest(String ID) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'content': 'You are requested to donate, your specific blood type is needed',
      'time': dateTime,
      'user_ID':ID,
      'cleared' : false,
      'type': "request"
    });
  }
  Future<void>  requestAll(String bt) async
  {
    CollectionReference appRef = FirebaseFirestore.instance.collection("Users");
    QuerySnapshot apSnapshot = await appRef.where("bloodType", isEqualTo: bt).get();
    apSnapshot.docs.forEach((DocumentSnapshot doc)async {
      if(bt != "")
        {
          await FirebaseFirestore.instance.collection('notifications').add({
            'content': 'You are requested to donate, your specific blood type is needed',
            'time': dateTime,
            'user_ID':doc.id,
            'cleared' : false,
            'type': "request"
          });
        }
    });
  }

  Future<void>  getStatus(String ID) async
  {
    CollectionReference appRef = FirebaseFirestore.instance.collection("appointments");
    QuerySnapshot apSnapshot = await appRef.where("user_ID", isEqualTo: ID)
        .where('status', isEqualTo: 'pending').limit(1).get();
    apSnapshot.docs.forEach((DocumentSnapshot doc) {
      setState(() {
        if(doc.data()["status"] != null) {
          status = doc.data()["status"];
        }
        else{
          status = "done";
        }
            debugPrint("status:  $status");
      });
    });
  }
  DateTime dateTime = DateTime.now();
  String BloodType = "";
  String status = "";
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
        .collection("Users")
            .doc(widget.uid).snapshots(),
    builder: ((context, snapshot) {
    if (!snapshot.hasData)
    return CircularProgressIndicator(
    strokeWidth: 2,
    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
    backgroundColor: Colors.grey,
    );

    return Scaffold(
      appBar: new AppBar(
        leading: GestureDetector(child: ClipOval(
          //clipper: MyClipper(),
          child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(snapshot.data.get("profilePhoto")),
              backgroundColor: Colors.white
          ),
        ),onTap:() {}),

        title: (!snapshot.hasData)
            ? const Text('Loading...')
            : Text(snapshot.data.get("name")),

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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                              children: <Widget>[ Text("Search",
                              style:
                              TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left),
                                SizedBox(
                                  width: 20.0,
                                ),
                                FlatButton.icon(icon: Icon(Icons.add_alert),
                                  onPressed: () async{
                                  if(BloodType == "")
                                    {
                                      showDialog(
                                        context: context,
                                      builder: (BuildContext context){return AlertDialog(
                                          title: Text(
                                              "Request failed, you have to choose a Blood Type"),

                                        );}
                                      );
                                    }
                                  else{
                                    dateTime = DateTime.now();
                                    requestAll(BloodType);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context){return AlertDialog(
                                        title: Text(
                                            "Request Successful for all chosen donors"),

                                      );}
                                    );
                                  }

                                  },
                                  label: Text("Request All",textAlign: TextAlign.right),
                                ),
                                FlatButton.icon(icon: Icon(Icons.list),
                                  onPressed: () async{
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                RequestsScreen(
                                                    uid: widget.uid)));

                                  },
                                  label: Text("View Requests",textAlign: TextAlign.right),
                                )
                        ]),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          hintText: 'Blood Type',
                          labelText: 'Blood Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: <String>[
                          "O+",
                          "O-",
                          "A+",
                          "A-",
                          "B+",
                          "B-",
                          "AB+",
                          "AB-"
                        ].map((String value) {
                          return new DropdownMenuItem<String>(

                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (String selected) {
                          setState(() {
                            BloodType = selected;
                          });
                        },
                      )
                    ]),
              )),
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .where("bloodType", isEqualTo: BloodType)
              .where("isAdmin", isEqualTo: false)
              .orderBy("name")
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
                  DocumentSnapshot user = snapshot.data.docs[index];

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
                                  backgroundImage: NetworkImage(user.get("profilePhoto")),
                                  backgroundColor: Colors.white
                              ),
                            ), onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ViewProfilePage(uid: widget.uid, viewID: user.id)));
                          },
                          ),
                          title: Text(user.get("name"),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          trailing: Text("Civil ID: "+user.get("civil_ID")),

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
                              //Expanded(
                                 // child: Text("Age: "+(dateTime.difference(user.get("dateOfBirth")).inHours /24).toString(),
                                  //   textAlign: TextAlign.center,
                                  //    style: TextStyle(fontSize: 15))),
                              Expanded(
                                child: Text("phone number: "+user.get("phoneNumber"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15)),
                              ),
                              FlatButton.icon(icon: Icon(Icons.add_alert),
                                onPressed: () async{
                                  //await getStatus(user.id);
                                    dateTime = DateTime.now();
                                    createRequest(user.id);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context){return AlertDialog(
                                        title: Text(
                                            "Request successful"),

                                      );}
                                    );
                                },
                                label: Text("Request"),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              //row here
            );
          }),
        ),
      ]),
    );
    }));
  }

}



