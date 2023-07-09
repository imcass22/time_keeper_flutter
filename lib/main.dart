import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:time_keeper/auth/bloc/auth_bloc.dart';
import 'package:time_keeper/auth/firebase_auth_provider.dart';
import 'package:time_keeper/routes.dart';
import 'package:time_keeper/screens/calendar_screen.dart';
import 'package:time_keeper/screens/change_password_screen.dart';
import 'package:time_keeper/screens/day_of_the_week_screen.dart';
import 'package:time_keeper/screens/delete_account_screen.dart';
import 'package:time_keeper/screens/forgot_password_screen.dart';
import 'package:time_keeper/screens/login_screen.dart';
import 'package:time_keeper/screens/registration_screen.dart';
import 'package:time_keeper/screens/settings_screen.dart';
import 'auth/bloc/auth_event.dart';
import 'auth/bloc/auth_state.dart';
import 'loading/loading_screen.dart';

//use starting character k when setting up constants
var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.grey);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.black54,
);
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
            //creating a light and dark color scheme based on the user's system preferences they have set up
            darkTheme: ThemeData.dark().copyWith(
              useMaterial3: true,
              colorScheme: kDarkColorScheme,
              cardTheme: const CardTheme().copyWith(
                color: kDarkColorScheme.secondaryContainer,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkColorScheme.primaryContainer,
                  foregroundColor: kDarkColorScheme.onPrimaryContainer,
                ),
              ),
            ),
            //customizing the apps theme accross the app
            theme: ThemeData().copyWith(
              useMaterial3: true,
              colorScheme: kColorScheme,
              //using .copyWith overrides the default styling
              appBarTheme: const AppBarTheme().copyWith(
                backgroundColor: kColorScheme.onPrimaryContainer,
                foregroundColor: kColorScheme.primaryContainer,
              ),
              cardTheme: const CardTheme().copyWith(
                color: kColorScheme.secondaryContainer,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColorScheme.primaryContainer,
                ),
              ),
              textTheme: ThemeData().textTheme.copyWith(
                    titleLarge: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kColorScheme.onSecondaryContainer,
                      fontSize: 16,
                    ),
                  ),
            ),
            //looks at what the user selected in their system to apply the appropriate theme
            themeMode: ThemeMode.system,
            home: const HomePage(),
            routes: {
              calendarRoute: (context) => const CalendarScreen(),
              dayOfTheWeekRoute: (context) => const DayOfTheWeekScreen(),
              settingsRoute: (context) => const SettingsScreen(),
              deleteAccountRoute: (context) => const DeleteAccountScreen(),
              changePasswordRoute: (context) => const ChangePasswordScreen(),
            },
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
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
          context: context,
          text: state.loadingText ?? 'Please wait a moment',
        );
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
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
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
