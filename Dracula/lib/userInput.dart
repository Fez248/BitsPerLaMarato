import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'landingPade.dart';

class UserProfileForm extends StatefulWidget {
  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _updateUserProfile(),
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }

Future<void> _updateUserProfile() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      DocumentReference userDoc = users.doc(user.uid);

      // Get age and height from controllers
      int age = int.tryParse(_ageController.text) ?? 0;
      int height = int.tryParse(_heightController.text) ?? 0;

      // Check if the document exists
      var userDocument = await userDoc.get();

      if (userDocument.exists) {
        // Update the existing document with new data
        await userDoc.update({
          'name': user.displayName,
          'age': age,
          'height': height
        });

        print('User profile updated successfully!');
      } else {
        // Create a new document with the UID and set the data
        await userDoc.set({
          'name': user.displayName,
          'age': age,
          'height': height,
        });

        print('User profile document created and updated successfully!');

        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileWelcome(user: user),
        ),
      );
      }
    } else {
      print('No authenticated user found.');
    }
  } catch (e) {
    print('Error updating user profile: $e');
  }
}
}