import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStorageService extends ChangeNotifier
{
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context,String Image) async{
    return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
  }

}