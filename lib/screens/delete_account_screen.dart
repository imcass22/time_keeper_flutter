import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_keeper/screens/registration_screen.dart';
import 'package:time_keeper/widgets/reuseable_elevated_button.dart';
import '../auth/auth_exceptions.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_state.dart';
import '../dialogs/error_dialog.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, 'User with the entered credentials is not found');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 242, 236),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 85, 145, 140),
          title: const Text('Delete Account'),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50, bottom: 50, left: 20),
              child: Text(
                'Are you sure you would like to delete your account?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
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
                    builder: (context) => const RegistrationScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
            ReuseableElevatedButton(
              text: 'No',
              color: const Color.fromARGB(255, 62, 61, 61),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
