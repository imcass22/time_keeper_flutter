// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:time_keeper/screens/settings_screen.dart';

class DayOfTheWeekScreen extends StatefulWidget {
  const DayOfTheWeekScreen({Key? key}) : super(key: key);

  @override
  State<DayOfTheWeekScreen> createState() => _DayOfTheWeekScreenState();
}

class _DayOfTheWeekScreenState extends State<DayOfTheWeekScreen> {
  //this controller is to get what that user typed in the notes section
  late final TextEditingController _notes;
  //this controller is to get what the user typed in the regular hours section
  late final TextEditingController _regularHours;
  //this controller is to get what the user typed in the overtime hours section
  late final TextEditingController _overtimeHours;
  //this controller is to get what the user typed in the mileage section
  late final TextEditingController _mileage;

  //accepting title and input data for appBar title TODO FIX

  @override
  void initState() {
    _notes = TextEditingController();
    _regularHours = TextEditingController();
    _overtimeHours = TextEditingController();
    _mileage = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
        title: const Text(
            'Need date selected here'), //TODO get date user selects from the calendar here
      ),
      body: Column(
        children: [
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            color: const Color.fromARGB(255, 134, 150, 134),
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
              child: const Text(
                'Enter your hours and mileage below: ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                const Text(
                  'Enter your regular hours: ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _regularHours,
                    decoration: const InputDecoration(
                      constraints: BoxConstraints(
                        maxHeight: 30,
                        maxWidth: 40,
                      ),
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                const Text(
                  'Enter your overtime hours: ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _overtimeHours,
                    decoration: const InputDecoration(
                      constraints: BoxConstraints(
                        maxHeight: 30,
                        maxWidth: 40,
                      ),
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                const Text(
                  'Enter your mileage: ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                SizedBox(
                  width: 70,
                  child: TextField(
                    controller: _mileage,
                    decoration: const InputDecoration(
                      constraints: BoxConstraints(
                        maxHeight: 30,
                        maxWidth: 40,
                      ),
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
          //Container for notes
          Container(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: const Row(
              children: [
                Text(
                  'Notes: ',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                // Wrap user text in a container
                child: TextFormField(
                  maxLines: 50,
                  controller: _notes,
                  decoration: const InputDecoration(
                    hintText: 'Enter your notes here...',
                    constraints: BoxConstraints(
                      maxHeight: 200,
                      maxWidth: 390,
                    ),
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            color: const Color.fromARGB(255, 134, 150, 134),
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
              child: const Text(
                'Running weekly totals: ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 30,
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                const Text(
                  'Total Regular Hours: ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                const Text('Amount'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                const Text(
                  'Total Overtime Hours: ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                const Text('Amount'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                const Text(
                  'Total Daily Hours: ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                const Text('Amount'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                const Text(
                  'Total Weekly Hours: ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                const Text('Amount'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                const Text(
                  'Total Weekly Mileage: ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                const Text('Amount'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
