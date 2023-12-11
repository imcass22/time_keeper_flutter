import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:time_keeper/auth/auth_page.dart';
import 'package:time_keeper/auth/bloc/auth_bloc.dart';
import 'package:time_keeper/auth/firebase_auth_provider.dart';
import 'package:time_keeper/firebase_options.dart';

void main() async {
  //ensures the orientation works as intended
  //initializing Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //locking the screen orientation in place
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (function) {
      runApp(
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: MaterialApp(
            theme: ThemeData.light().copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12, width: 2.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black12,
                    width: 2.0,
                  ),
                ),
              ),
              colorScheme:
                  // Color needed to change the arrows on the calendar from blue
                  ColorScheme.fromSwatch().copyWith(
                primary: Colors.grey[500],
              ),
              scaffoldBackgroundColor: const Color.fromARGB(255, 247, 242, 236),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 37, 33, 41),
                foregroundColor: Color.fromARGB(255, 247, 242, 236),
              ),
            ),
            // remove debug banner
            debugShowCheckedModeBanner: false,
            home: const AuthPage(),
          ),
        ),
      );
    },
  );
}
