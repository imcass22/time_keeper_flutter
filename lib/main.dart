import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:time_keeper/auth/auth_page.dart';
import 'package:time_keeper/auth/bloc/auth_bloc.dart';
import 'package:time_keeper/auth/firebase_auth_provider.dart';

void main() async {
  //ensures the orientation works as intended
  //initializing Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //locking the screen orientation in place
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (function) {
      runApp(
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.teal,
            ),
            home: const AuthPage(),
          ),
        ),
      );
    },
  );
}
