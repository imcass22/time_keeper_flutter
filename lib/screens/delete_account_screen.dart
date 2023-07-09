import 'package:flutter/material.dart';
import 'package:time_keeper/screens/calendar_screen.dart';
import 'package:time_keeper/widgets/reuseable_elevated_button.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, bottom: 50, left: 20),
            child: Text(
              'Are you sure you would like to delete your account?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          ReuseableElevatedButton(
            text: 'Yes',
            color: const Color.fromARGB(255, 151, 68, 62),
            onPressed: () {},
          ),
          const SizedBox(height: 50),
          ReuseableElevatedButton(
            text: 'No',
            color: const Color.fromARGB(255, 20, 92, 151),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CalendarScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
