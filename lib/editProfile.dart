import 'dart:collection';
import 'dart:io';

import 'package:bloodDonor/services/FireStorageService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:settings_ui/pages/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'authentication/auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:transparent_image/transparent_image.dart';
class EditProfilePage extends StatefulWidget {
  final String uid;
  //final String uid = FirebaseAuth.instance.currentUser.uid;
  EditProfilePage({@required this.uid});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  firebase_storage.Reference ref;
  TextEditingController passController = new TextEditingController();
  String pass="";
  //profile picture
  File imageFile;
  final ImagePicker picker = ImagePicker();
  Widget bottomSheet()
  {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text("Choose Profile picture",
            style: TextStyle(fontSize: 20.0
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(icon: Icon(Icons.camera),
                onPressed: (){
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera"),
              ),
              FlatButton.icon(icon: Icon(Icons.image),
                onPressed: (){
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Galery"),
              ),
            ],
          )
        ],

      ),
    );
  }
  void takePhoto(ImageSource source) async{
    final pickedFile = await ImagePicker.pickImage(
        source: source);
    setState(() {
      imageFile = pickedFile;
    });
  }
  Future<Widget> _getImage(BuildContext context, String imageName) async{
    Image image;
    await FireStorageService.loadImage(context, imageName).then((value) {
      image = Image.network(value.toString());
    });
    return image;
  }

  Future uploadFile()async{
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${Path.basename(imageFile.path)}');
    await ref.putFile(File(imageFile.path)).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        FirebaseFirestore.instance.collection("Users").doc(
            widget.uid).update(
            {"profilePhoto": value});
      });
    });
  }

  createAlertDialog(BuildContext context)
  {
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("enter your password to change your email: "),
        content: TextField(
          controller: passController,
          obscureText: isHidden,
          decoration: InputDecoration(
            labelText: 'password',
            suffixIcon: InkWell(
                onTap: _togglePassword,
                child: iconBuild()
            ),
            hintText: 'password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve'),
            onPressed: () {
              setState(() {
                pass = passController.text;
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
  void _togglePassword()
  {

    setState(() {
      isHidden = !isHidden;
    });
  }
  Widget iconBuild() {
    if (isHidden == true) return Icon(Icons.visibility);
    return Icon(Icons.visibility_off);
  }
  bool isHidden = true;
  final  users = FirebaseFirestore.instance.collection("Users");
  TextEditingController inputController = new TextEditingController();

  bool showPassword = false;
  String message = '';
  final emailController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").doc(widget.uid).snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) return Padding(
            padding: const EdgeInsets.all(175.25),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              backgroundColor: Colors.grey,
            ),
          );
          return Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: [
                  Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10))
                            ],
                            shape: BoxShape.circle,

                          ),
                          child: ClipOval(
                            child: FadeInImage.memoryNetwork(
                                fit: BoxFit.fill,
                                placeholder: kTransparentImage,
                                image: snapshot.data.get("profilePhoto")
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.green,
                              ),
                              child: InkWell(
                                onTap: (){
                                  showModalBottomSheet(context: context,
                                      builder: ((Builder) => bottomSheet()));
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: "full name",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: snapshot.data.get("name"),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                    enabled: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: "Civil ID",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: snapshot.data.get("civil_ID"),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                    enabled: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: "Date of Birth",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: snapshot.data.get("dateOfBirth"),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                    enabled: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: "Blood Type",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: snapshot.data.get("bloodType"),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        )),
                    enabled: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: "Phone Number",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: snapshot.data.get("phoneNumber"),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    controller: inputController,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                  ),
                  InkWell(
                    onTap: () async {

                      final result =
                      await Auth().resetPassword(email: snapshot.data.get("email"));
                      setState(() {
                        message = result;
                      });

                    },
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlineButton(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          snapshot.data.get("phoneNumber");
                          Navigator.pop(context);
                        },
                        child: Text("CANCEL",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.black)),
                      ),
                      RaisedButton(
                        onPressed: () async{
                          uploadFile();
                          if (inputController.text.isNotEmpty) {
                            FirebaseFirestore.instance.collection("Users").doc(
                                widget.uid).update(
                                {"phoneNumber": inputController.text});
                          }
                          // if (emailController.text.isNotEmpty) {
                          // var user = FirebaseAuth.instanceFor().currentUser;
                          // createAlertDialog(context);
                          // user.updateEmail(emailController.text);

                          //FirebaseFirestore.instance.collection("Users").doc(
                          //   widget.uid).update(
                          //  {"email": emailController.text});
                          //}
                          Navigator.pop(context);
                        },
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  if (message != '')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 10),
                        Text(
                          '$message',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        }
        ),
      ),
    );
  }


}