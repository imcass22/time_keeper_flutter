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
        appBar: AppBar(
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
                  color: const Color.fromARGB(255, 37, 33, 41),
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
