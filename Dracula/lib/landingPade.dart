import 'userInput.dart';
import 'login-sign-up/lsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:camera/camera.dart';
import 'cameraControl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class UserProfileWelcome extends StatelessWidget {
  final User user;
  final List<CameraDescription> cameras;
  const UserProfileWelcome({Key? key, required this.user, required this.cameras}) : super(key: key);

  @override

  
Widget build(BuildContext context) {
  String displayName = user.displayName ?? "DefaultName";
  return Scaffold(
    appBar: AppBar(
      title: Text(displayName),
      backgroundColor: Colors.red, // Set the background color to red
    ),
    body: SfCalendar(
      view: CalendarView.month,
      firstDayOfWeek: 1, // Monday
      todayHighlightColor: Colors.red,
      backgroundColor: Colors.pink[50],
      monthViewSettings: MonthViewSettings(showAgenda: true),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: cameras.first),
          ),
        );
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
    ),
  );
}
}