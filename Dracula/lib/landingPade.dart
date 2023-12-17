import 'userInput.dart';
import 'login-sign-up/lsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:camera/camera.dart';
import 'cameraControl.dart';

class UserProfileWelcome extends StatelessWidget {
  final User user;
  final List<CameraDescription> cameras;
  const UserProfileWelcome({Key? key, required this.user, required this.cameras}) : super(key: key);

  @override

  
Widget build(BuildContext context) {
    String displayName = user.displayName ?? "DefaultName";
    return  Scaffold(
      appBar:  AppBar(
        title:  Text(displayName),
      ),
      body:  Center(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TakePictureScreen(camera: cameras.first),
            ),
          );
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
