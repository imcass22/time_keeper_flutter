import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 26.0, right: 20, top: 100, bottom: 15),
                child: Text(
                    "We've sent you an email verification. Please open it to verify your account"),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 26.0, right: 20, top: 15, bottom: 50),
              child: Text(
                  "If you haven't received a verificaton email yet, press the below button."),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(350, 50),
                backgroundColor: const Color.fromARGB(255, 55, 82, 117),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // sent email verification to user
                context.read<AuthBloc>().add(
                      const AuthEventSendEmailVerificaton(),
                    );
              },
              child: const Text('Send email verification'),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(350, 50),
                backgroundColor: const Color.fromARGB(255, 55, 82, 117),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
