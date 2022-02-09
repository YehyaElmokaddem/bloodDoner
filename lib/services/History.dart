import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  getHistory(String userID) {
    return FirebaseFirestore.instance
        .collection("appointments")
        .where("user_ID", isEqualTo: userID)
        .orderBy("time", descending: true)
        .snapshots();
  }
}
