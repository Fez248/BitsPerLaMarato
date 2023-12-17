import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/firebase-connections/firebaseConnection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test2/userInput.dart';
import 'package:test2/landingPade.dart';
import 'package:camera/camera.dart';
// class loginSignUp extends StatefulWidget {
//     const loginSignUp({super.key, required this.title}); //constructora

//     final String title; //titulo de la ventana

//     @override
//     State<loginSignUp> createState() => _loginSignUp();
// }

// class _loginSignUp extends State<loginSignUp> {
//     //aquí van variables que necesite y funciones auxiliares
//     void goToHome()
//     {
//         Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const MyHomePage(title: "prueba")),
//         );
//     }

//     @override
//     Widget build (BuildContext context)
//     {
//         return Scaffold(
//             body: Center(
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: <Widget> [
//                                 Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: FloatingActionButton.extended(
//                                         //const SizedBox(width: 16),
//                                         onPressed: goToHome,
//                                         label: const Text("Continuar"),    
//                                     )
//                                 )
//                             ],
//                         )
//                     ]
//                 )
//             )
//         );
//     }
// }

//---------------SIGN IN GOOGLE--------------------


class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> _handleSignIn(BuildContext context) async {
    final cameras = await availableCameras();
    
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      print("Signed in with Google: ${user!.displayName}, ${user.uid}");

      CollectionReference users = FirebaseFirestore.instance.collection('users');
      DocumentReference userDoc = users.doc(user.uid);
      var userDocument = await userDoc.get();

      if (userDocument.exists) {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileWelcome(user: user, cameras: [cameras.first]),
        ),
        );
      }
      else {
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserProfileForm()),
      );
      }

    } catch (error) {
      print("Error signing in with Google: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _handleSignIn(context);
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}