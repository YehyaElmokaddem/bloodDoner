import 'package:flutter/material.dart';

class LoadingAlertBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        content: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
