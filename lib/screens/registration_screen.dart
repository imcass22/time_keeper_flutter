import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_keeper/widgets/elevated_button_widget.dart';
import 'package:time_keeper/widgets/my_textfield.dart';
import '../auth/auth_exceptions.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import '../dialogs/error_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Icon(
                    Icons.punch_clock_outlined,
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
                  MyTextField(
                    controller: _emailController,
                    obscureText: false,
                    hintText: 'Enter your email here',
                  ),
                  const SizedBox(height: 25),
                  //password textfield from components/my_textfield.dart
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Enter your password here',
                    obscureText: true,
                  ),
                  const SizedBox(height: 25.0),
                  //Register
                  ElevatedButtonWidget(
                    buttonText: 'Register',
                    onPressed: () async {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      context.read<AuthBloc>().add(
                            AuthEventRegister(
                              email,
                              password,
                            ),
                          );
                    },
                  ),
                  const SizedBox(height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already registered?'),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () {
                          // sent user to login screen
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        },
                        child: const Text(
                          'Login here',
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
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Enter your email and passoword to register'),
//               TextField(
//                 controller: _email,
//                 enableSuggestions: false,
//                 autocorrect: false,
//                 autofocus: true,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter your email here',
//                 ),
//               ),
//               TextField(
//                 controller: _password,
//                 obscureText: true,
//                 enableSuggestions: false,
//                 autocorrect: false,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter your password here',
//                 ),
//               ),
//               Center(
//                 child: Column(
//                   children: [
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text('Register'),
//                     ),
//                   ],
//                 ),
//               ),
//               Center(
//                 child: Column(
//                   children: [
//                     TextButton(
//                       onPressed: () {},
//                       child: const Text('Already registered? Login here.'),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
