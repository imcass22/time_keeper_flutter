import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_keeper/model/extension.dart';
import 'package:time_keeper/widgets/reuseable_elevated_button.dart';
import 'package:time_keeper/widgets/standard_textfield.dart';

class RegistrationScreen extends StatefulWidget {
  final Function()? onTap;
  const RegistrationScreen({super.key, required this.onTap});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //text controllers
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // sign user in method
  void signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // try creating the user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // show error message to user
      showErrorMessage(e.code);
    }
  }

  // error message to user for wrong email or password
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 37, 33, 41),
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: Color.fromARGB(255, 247, 242, 236),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Enter your email and password to register',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  //username textfield from components/my_textfield.dart
                  StandardTextField(
                    controller: emailController,
                    obscureText: false,
                    hintText: 'Enter your email here',
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (!val!.isValidEmail) {
                        return 'Enter a valid email.';
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                  //password textfield from components/my_textfield.dart
                  StandardTextField(
                    controller: passwordController,
                    hintText: 'Enter your password here',
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (!val!.isValidPassword) {
                        return 'Password should contain an upper case letter, a lower \ncase letter, a number, and a special character.';
                      }
                    },
                  ),
                  const SizedBox(height: 25.0),
                  //Register
                  ReuseableElevatedButton(
                    text: 'Register',
                    color: const Color.fromARGB(255, 37, 33, 41),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        signUserUp();
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const AuthPage(),
                        //   ),
                        // );
                      }
                    },
                  ),
                  const SizedBox(height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already registered?'),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login here',
                          style: TextStyle(
                            color: Color.fromARGB(255, 55, 82, 117),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
