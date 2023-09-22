import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:time_keeper/auth/bloc/auth_bloc.dart';
import 'package:time_keeper/auth/firebase_auth_provider.dart';
import 'package:time_keeper/screens/calendar_screen.dart';
import 'package:time_keeper/screens/forgot_password_screen.dart';
import 'package:time_keeper/screens/login_screen.dart';
import 'package:time_keeper/screens/registration_screen.dart';
import 'auth/bloc/auth_event.dart';
import 'auth/bloc/auth_state.dart';
import 'loading/loading_screen.dart';

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
      //dynamic passedDate;
      runApp(
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.teal,
            ),
            home: const CalendarScreen(),
          ),
        ),
      );
    },
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const CalendarScreen();
          // } else if (state is AuthStateNeedsVerification) {
          //   return const VerifyEmailScreen();
        } else if (state is AuthStateLoggedOut) {
          return const LoginScreen();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordScreen();
        } else if (state is AuthStateRegistering) {
          return const RegistrationScreen();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
