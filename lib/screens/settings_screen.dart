import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_keeper/screens/delete_account_screen.dart';
import 'package:time_keeper/widgets/reuseable_elevated_button.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import '../dialogs/error_dialog.dart';
import '../dialogs/password_reset_email_sent_dialog.dart';
import '../enums/menu_action.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
//text controllers
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
            await showErrorDialog(context,
                'We could not process your request please make sure you are a registered user, or if not, register a user now by going back one step.');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout ?? true) {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Log out'),
                  ),
                ];
              },
            ),
          ],
          title: const Text('Settings'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 84, 77, 88),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 26),
                child: const Text(
                  'Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  top: 100.0, left: 40.0, bottom: 100, right: 20),
              child: Text(
                'If you would like to change your password or delete your account, click on the appropriate button below.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ReuseableElevatedButton(
              text: 'Reset Password',
              color: const Color.fromARGB(255, 37, 33, 41),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
            ReuseableElevatedButton(
              text: 'Delete Account',
              color: const Color.fromARGB(255, 151, 68, 62),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DeleteAccountScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  showLogOutDialog(BuildContext context) {}
}
