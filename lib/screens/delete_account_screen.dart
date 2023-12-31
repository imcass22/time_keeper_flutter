import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_keeper/screens/registration_screen.dart';
import 'package:time_keeper/widgets/reuseable_elevated_button.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 100, bottom: 50, left: 5),
            child: Text(
              'Are you sure you would like to delete your account?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
          const SizedBox(height: 40),
          ReuseableElevatedButton(
            text: 'Yes',
            color: const Color.fromARGB(255, 151, 68, 62),
            onPressed: () async {
              // get current user
              Future<User> getFirebaseUser() async {
                return FirebaseAuth.instance.currentUser!;
              }

              var user = await getFirebaseUser();
              // await for the Firestore data to be removed
              await FirebaseFirestore.instance
                  .collection('events')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .delete();
              // delete user
              await user.delete();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RegistrationScreen(
                    onTap: () {},
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 50),
          ReuseableElevatedButton(
            text: 'No',
            color: const Color.fromARGB(255, 37, 33, 41),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
