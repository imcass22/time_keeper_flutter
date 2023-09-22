import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_keeper/screens/calendar_screen.dart';
import 'package:time_keeper/widgets/reuseable_elevated_button.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import '../dialogs/error_dialog.dart';
import '../dialogs/password_reset_email_sent_dialog.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateChangePassword) {
          if (state.hasSentEmail) {
            _passwordController.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(
                context, 'We encountered an error. Please try again.');
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 242, 236),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 85, 145, 140),
          title: const Text('Reset password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      top: 50.0, bottom: 50.0, left: 15.0, right: 15.0),
                  child: Text(
                    'If you would like to reset your password, enter your email and we will send you a password reset link',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 50.0, left: 15.0, right: 15.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autofocus: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Your email address..',
                    ),
                  ),
                ),
                ReuseableElevatedButton(
                  text: 'Send me a password reset link',
                  color: const Color.fromARGB(255, 62, 61, 61),
                  onPressed: () {
                    final email = _passwordController.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventChangePassword(email: email));
                  },
                ),
                const SizedBox(height: 15),
                ReuseableElevatedButton(
                  text: 'Go back to home page',
                  color: const Color.fromARGB(255, 55, 82, 117),
                  onPressed: () {
                    //sends user to calendar screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CalendarScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:time_keeper/auth/bloc/auth_event.dart';
// import 'package:time_keeper/screens/login_screen.dart';
// import 'package:time_keeper/widgets/standard_textfield.dart';

// import '../auth/auth_exceptions.dart';
// import '../auth/bloc/auth_bloc.dart';
// import '../auth/bloc/auth_state.dart';
// import '../dialogs/error_dialog.dart';

// class ChangePasswordScreen extends StatefulWidget {
//   const ChangePasswordScreen({super.key});

//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   var newPassword = '';
//   final _newPasswordController = TextEditingController();
//   final _repeatPasswordController = TextEditingController();

//   @override
//   void dispose() {
//     _newPasswordController.dispose();
//     _repeatPasswordController.dispose();
//     super.dispose();
//   }

//   final currentUser = FirebaseAuth.instance.currentUser;

//   void changePassword() async {
//     // ignore: use_build_context_synchronously
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         backgroundColor: Colors.white,
//         content: Text(
//             'Your password has been changed. Please login to your account.'),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) async {
//         if (state is AuthStateChangePassword) {
//           if (state.exception is WeakPasswordAuthException) {
//             await showErrorDialog(context, 'Weak Password');
//           }
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Change Password'),
//         ),
//         body: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Padding(
//                 padding:
//                     EdgeInsets.only(top: 100, bottom: 100, left: 26, right: 20),
//                 child: Text(
//                   'Enter your new password below and click the change password button to change your password.',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(left: 26),
//                 child: Text('New Password'),
//               ),
//               const SizedBox(height: 15),
//               StandardTextField(
//                 controller: _newPasswordController,
//                 hintText: '',
//                 obscureText: true,
//               ),
//               const SizedBox(height: 40),
//               const Padding(
//                 padding: EdgeInsets.only(left: 26),
//                 child: Text('Confirm Password'),
//               ),
//               const SizedBox(height: 15),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.white),
//                     ),
//                     //when user clicks to type text, border will turn gray
//                     focusedBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                     fillColor: Colors.grey.shade800,
//                     filled: true,
//                   ),
//                   obscureText: true,
//                   controller: _repeatPasswordController,
//                   validator: (value) {
//                     return _newPasswordController.text == value
//                         ? null
//                         : 'Please validate your entered password';
//                   },
//                 ),
//               ),
//               const SizedBox(height: 80),
//               Center(
//                 child: OutlinedButton(
//                   style: OutlinedButton.styleFrom(
//                     minimumSize: const Size(350, 50),
//                     backgroundColor: const Color.fromARGB(255, 71, 77, 96),
//                     foregroundColor: Colors.white,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       newPassword = _newPasswordController.text;
//                     });
//                     context.read<AuthBloc>().add(
//                           AuthEventChangePassword(
//                             newPassword,
//                           ),
//                         );
//                     changePassword();
//                   },
//                   child: const Text('Change Password'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
