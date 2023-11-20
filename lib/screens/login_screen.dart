import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_keeper/screens/forgot_password_screen.dart';
import 'package:time_keeper/screens/registration_screen.dart';
import 'package:time_keeper/widgets/reuseable_elevated_button.dart';
import 'package:time_keeper/widgets/standard_textfield.dart';
import 'package:time_keeper/firebase_options.dart';
import '../auth/auth_exceptions.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import '../dialogs/error_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text controllers
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // error handling
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
          title: const Text('Login'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: FutureBuilder(
                future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                ),
                builder: (context, snapshot) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      const Icon(
                        Icons.punch_clock_outlined,
                        size: 100,
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'Enter your email and password to login',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      //username textfield from components/my_textfield.dart
                      StandardTextField(
                        controller: _emailController,
                        obscureText: false,
                        hintText: 'Enter your email here',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 25),
                      //password textfield from components/my_textfield.dart
                      StandardTextField(
                        controller: _passwordController,
                        hintText: 'Enter your password here',
                        obscureText: true,
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 25.0),
                      //Register
                      ReuseableElevatedButton(
                        text: 'Login',
                        color: const Color.fromARGB(255, 55, 82, 117),
                        onPressed: () {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          context.read<AuthBloc>().add(
                                AuthEventLogIn(
                                  email,
                                  password,
                                ),
                              );
                        },
                      ),
                      const SizedBox(height: 25.0),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text('I forgot my password'),
                      ),
                      const SizedBox(height: 25.0),
                      //Wrap text widget in a row since the column is centered, then can the allignment to the end
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Not registered yet?'),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Register here',
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
