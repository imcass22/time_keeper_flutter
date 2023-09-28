import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_keeper/screens/calendar_screen.dart';
import 'package:time_keeper/screens/login_screen.dart';

// AuthPage checks if user is signed in or not, if user is not sign in, display login page otherwise display calendar page
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const CalendarScreen();
          }
          // user is NOT logged in
          else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
