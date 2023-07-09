import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_keeper/screens/delete_account_screen.dart';
import 'package:time_keeper/widgets/reuseable_elevated_button.dart';
import 'package:time_keeper/widgets/reuseable_outlined_button.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import '../auth/firebase_auth_provider.dart';
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
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 134, 150, 134),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 26),
                child: const Text(
                  'Account',
                  style: TextStyle(
                    color: Colors.black87,
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
            // const Padding(
            //   padding: EdgeInsets.only(left: 26.0, top: 30.0, bottom: 10.0),
            //   child: Text(
            //     'First name',
            //     style: TextStyle(
            //       fontSize: 16,
            //     ),
            //   ),
            // ),
            // StandardTextField(
            //   controller: _firstNameController,
            //   hintText: '',
            //   obscureText: false,
            // ),
            // const Padding(
            //   padding: EdgeInsets.only(left: 26.0, top: 30.0, bottom: 10.0),
            //   child: Text(
            //     'Last name',
            //     style: TextStyle(
            //       fontSize: 16,
            //     ),
            //   ),
            // ),
            // StandardTextField(
            //   controller: _lastNameController,
            //   hintText: '',
            //   obscureText: false,
            // ),
            // const Padding(
            //   padding: EdgeInsets.only(left: 26.0, top: 30.0, bottom: 10.0),
            //   child: Text(
            //     'Email',
            //     style: TextStyle(
            //       fontSize: 16,
            //     ),
            //   ),
            // ),
            // StandardTextField(
            //   controller: _emailController,
            //   hintText: '',
            //   obscureText: false,
            // ),
            // const SizedBox(height: 40.0),
            // ReuseableElevatedButton(
            //   text: 'Save',
            //   color: const Color.fromARGB(255, 20, 92, 151),
            //   onPressed: () {},
            // ),
            // const SizedBox(height: 70),
            ReuseableOutlinedButton(
              text: 'Reset Password',
              color: const Color.fromARGB(255, 62, 61, 61),
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
