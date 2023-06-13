import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_keeper/screens/calendar.dart';
import 'package:time_keeper/screens/day_of_the_week.dart';

//use starting character k when setting up constants
var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.grey);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.black54,
);
void main() {
  //ensures the orientation works as intended
  WidgetsFlutterBinding.ensureInitialized();
  //locking the screen orientation in place
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((function) {
    dynamic passedDate;
    runApp(
      MaterialApp(
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
          initialRoute: Calendar.screen,
          routes: {
            Calendar.screen: (context) => const Calendar(),
            DayOfTheWeek.screen: (context) =>
                DayOfTheWeek(passedDate: passedDate),
            // Settings.screen: (context) => const Settings(),
            // Login.screen: (context) => const Login(),
            // Registration.screen : (context) => Registration(),
            // DeleteAccount.screen: (context) => const DeleteAccount(),
            // ChangePassword.screen: (context) => const ChangePassword(),
          }),
    );
  });
}
