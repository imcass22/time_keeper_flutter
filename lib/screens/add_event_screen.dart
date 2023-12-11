import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_keeper/screens/calendar_screen.dart';
import 'package:time_keeper/widgets/reuseable_elevated_button.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  // use controllers to get what the user types
  TextEditingController? notesController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  TextEditingController regularHoursController = TextEditingController();
  TextEditingController overtimeHoursController = TextEditingController();
  TextEditingController? mileageController = TextEditingController();
  String totalHours = '0.00';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    dateController.text =
        _selectedDate?.toIso8601String().substring(0, 10) ?? 'Select Date';
  }

  // method for calculation the sum of regular and overtime hours
  void hoursSum() {
    setState(() {
      double total = double.tryParse(overtimeHoursController.text)! +
          double.tryParse(regularHoursController.text)!;
      totalHours = total.toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
    notesController?.dispose();
    regularHoursController.dispose();
    overtimeHoursController.dispose();
    mileageController?.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedDate != null
            ? _selectedDate!.toIso8601String().substring(0, 10)
            : "TimeKeeper"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 2),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 84, 77, 88),
              child: Container(
                padding: const EdgeInsets.only(top: 12, bottom: 10, left: 22),
                child: const Text(
                  'Select a date and enter your data below: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Date picker
            Container(
              padding: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 10),
              child: TextFormField(
                controller: dateController,
                readOnly: true,
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate:
                        _selectedDate != null ? _selectedDate! : DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2222),
                  );
                  if (newDate != null) {
                    setState(() {
                      _selectedDate = newDate;
                      dateController.text =
                          newDate.toIso8601String().substring(0, 10);
                    });
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 10),
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
                    width: 80,
                    child: TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: regularHoursController,
                      decoration: const InputDecoration(
                        // to positon text input by user in text box
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        constraints: BoxConstraints(
                          maxHeight: 30,
                          maxWidth: 40,
                        ),
                        border: OutlineInputBorder(),
                        //fillColor: Colors.grey,
                      ),
                      // only allows numbers to be entered into the text field in decimal form
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 10),
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
                    width: 80,
                    child: TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: overtimeHoursController,
                      decoration: const InputDecoration(
                        // to positon text input by user in text box
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        constraints: BoxConstraints(
                          maxHeight: 30,
                          maxWidth: 40,
                        ),
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // only allows numbers to be entered into the text field in decimal form
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 10),
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
                    width: 80,
                    child: TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: mileageController,
                      decoration: const InputDecoration(
                        // to positon text input by user in text box
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        constraints: BoxConstraints(
                          maxHeight: 30,
                          maxWidth: 60,
                        ),
                        border: OutlineInputBorder(),
                        fillColor: Color.fromARGB(255, 218, 217, 217),
                      ),
                      // only allows numbers to be entered into the text field in decimal form
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          // allows for decimal numbers
                          RegExp(r'^(\d+)?\.?\d{0,2}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Container for notes
            Container(
              padding: const EdgeInsets.only(
                  top: 15, left: 20, right: 20, bottom: 10),
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
                  padding: const EdgeInsets.only(bottom: 15.0),
                  // Wrap user text in a container
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    maxLines: 50,
                    controller: notesController,
                    decoration: InputDecoration(
                      hintText: 'Enter your notes here...',
                      // change color of hint text
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                      ),
                      constraints: const BoxConstraints(
                        maxHeight: 200,
                        maxWidth: 390,
                      ),
                      border: const OutlineInputBorder(),
                      fillColor: const Color.fromARGB(255, 226, 222, 222),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ReuseableElevatedButton(
              text: 'Add',
              color: const Color.fromARGB(255, 37, 33, 41),
              onPressed: () {
                // checking if the user has entered data for the date, regular hours, and overtime hours fields. If not, a snack bar message will display
                if (regularHoursController.text.isEmpty ||
                    overtimeHoursController.text.isEmpty ||
                    // dateController is not empty it is set to 'Select Date'
                    dateController.text == 'Select Date') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Please enter a date and provide data for regular and overtime hours.'),
                      duration: Duration(seconds: 4),
                    ),
                  );
                } else {
                  // calling method to calculate the total hours after user enters data in both regular hours and overtime hours text fields
                  hoursSum();
                }
                if (_selectedDate != null &&
                    regularHoursController.text.isNotEmpty &&
                    overtimeHoursController.text.isNotEmpty) {
                  FirebaseFirestore.instance.collection('events').add(
                    {
                      // allows for user not to enter any nots
                      'notes': notesController?.text ?? '',
                      'date': _selectedDate,
                      'regular hours': regularHoursController.text,
                      'overtime hours': overtimeHoursController.text,
                      // allows for user to not enter mileage
                      'mileage': mileageController?.text ?? 0,
                      'total hours': totalHours,
                      'id': FirebaseAuth.instance.currentUser!
                          .uid, // id for each individual user
                    },
                  );
                  //need to user Navigator.of...instead of Navigator.pop to reload events upon screen change
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CalendarScreen(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
