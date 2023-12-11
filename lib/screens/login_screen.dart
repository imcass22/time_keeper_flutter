import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_keeper/screens/forgot_password_screen.dart';
import 'package:time_keeper/widgets/reuseable_elevated_button.dart';
import 'package:time_keeper/widgets/standard_textfield.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text controllers
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

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
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // show error message "Wrong Credentials" to user for security purposes. Do not want to give malicious actors specific information
      showErrorMessage('Wrong Credentials');
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
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              // helps when dealing with different screen sizes
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
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
                  controller: emailController,
                  obscureText: false,
                  hintText: 'Enter your email here',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 25),
                //password textfield from components/my_textfield.dart
                StandardTextField(
                  controller: passwordController,
                  hintText: 'Enter your password here',
                  obscureText: true,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 25.0),
                //Register
                ReuseableElevatedButton(
                  text: 'Login',
                  color: const Color.fromARGB(255, 37, 33, 41),
                  onPressed: () async {
                    signUserIn();
                  },
                ),
                const SizedBox(height: 25.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'I forgot my password',
                    style: TextStyle(
                      color: Color.fromARGB(255, 55, 82, 117),
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                //Wrap text widget in a row since the column is centered, then can the allignment to the end
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not registered yet?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Register here',
                          style: TextStyle(
                            color: Color.fromARGB(255, 55, 82, 117),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
