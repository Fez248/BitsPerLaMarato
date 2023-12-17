import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFunctions {
  // Function to add data to Firestore
  static Future<void> addData() async {
    try {
      // Reference to the 'users' collection
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Add a new document with a generated ID
      await users.add({
        'name': 'John Doe',
        'age': 25,
        'email': 'john.doe@example.com',
      });

      print('Data added successfully!');
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  // Function to retrieve data from Firestore
  static Future<void> retrieveData() async {
    try {
      // Reference to the 'users' collection
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Get all documents in the 'users' collection
      QuerySnapshot querySnapshot = await users.get();

      // Iterate through the documents and print the data
      querySnapshot.docs.forEach((doc) {
        print('Name: ${doc['name']}, Age: ${doc['age']}, Email: ${doc['email']}');
      });
    } catch (e) {
      print('Error retrieving data: $e');
    }
  }
}