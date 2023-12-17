import 'userInput.dart';
import 'login-sign-up/lsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileWelcome extends StatelessWidget {
  final User user;

  const UserProfileWelcome({Key? key, required this.user}) : super(key: key);

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
        onPressed: null,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
