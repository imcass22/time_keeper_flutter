// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'calendar_screen.dart';

class DayOfTheWeekScreen extends StatefulWidget {
  static const String screen = 'day-of-the-week_screen';
  dynamic passedDate;
  DayOfTheWeekScreen({
    Key? key,
    required this.passedDate,
  }) : super(key: key);

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
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
        title: Text(
            '${widget.passedDate}'), //TODO get date user selects from the calendar here
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
                const EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 10),
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
                const EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 10),
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
                const EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 10),
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
                const EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 10),
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
              SizedBox(
                width: 350,
                height: 300,
                child: TextField(
                  controller: _notes,
                  decoration: const InputDecoration(
                    hintText: 'Enter your notes here...',
                    constraints: BoxConstraints(
                      maxHeight: 300,
                      maxWidth: 350,
                    ),
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
