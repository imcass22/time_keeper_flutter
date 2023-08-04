// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_keeper/cloud/cloud_storage_constants.dart';
import 'package:time_keeper/cloud/firebase_cloud_storage.dart';
import 'package:time_keeper/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:time_keeper/generics/get_arguments.dart';
import 'package:time_keeper/screens/settings_screen.dart';
import 'package:time_keeper/views/user_text_list_view.dart';
import 'package:time_keeper/widgets/reuseable_elevated_button.dart';
import '../auth/auth_service.dart';
import '../cloud/cloud_note.dart';

class DayOfTheWeekScreen extends StatefulWidget {
  const DayOfTheWeekScreen({Key? key}) : super(key: key);

  @override
  State<DayOfTheWeekScreen> createState() => _DayOfTheWeekScreenState();
}

class _DayOfTheWeekScreenState extends State<DayOfTheWeekScreen> {
  CloudNote? _note;
  CloudNote? regularHours;
  CloudNote? overtimeHours;
  CloudNote? mileage;
  String get userID => AuthService.firebase().currentUser!.id;
  //create an instance of FireBaseFirestore, and capture a snapshot of userText to store in the userText collection
  // final Stream<QuerySnapshot> userText =
  //    FirebaseFirestore.instance.collection('userText').snapshots();
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
  void dispose() {
    super.dispose();
    _notes.dispose();
    _regularHours.dispose();
    _overtimeHours.dispose();
    _mileage.dispose();
  }

  Future saveUserData() async {
    userData(
      double.parse(_regularHours.text.trim()),
      double.parse(_overtimeHours.text.trim()),
      double.parse(_mileage.text.trim()),
      _notes.text.trim(),
    );
  }

  Future userData(double regularHours, double overtimeHours, double mileage,
      String notes) async {
    await FirebaseFirestore.instance.collection('userText').add({
      'regular hours': regularHours,
      'overtime hours': overtimeHours,
      'mileage': mileage,
      'notes': notes,
    });
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
      body: SingleChildScrollView(
        child: Column(
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
                    onTap: () async {},
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReuseableElevatedButton(
                  text: 'Save',
                  color: const Color.fromARGB(255, 20, 92, 151),
                  onPressed: () {
                    saveUserData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Your data has been saved',
                        ),
                        backgroundColor: Colors.white,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
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
            // StreamBuilder(
            //   stream: _userTextService.allText(ownerUserId: userID),
            //   builder: (context, snapshot) {
            //     switch (snapshot.connectionState) {
            //       case ConnectionState.waiting:
            //       case ConnectionState.active:
            //         if (snapshot.hasData) {
            //           final userText = snapshot.data as Iterable<CloudNote>;
            //           return Builder(builder: (context) {
            //             return UserTextListView(
            //               onDeleteText: (CloudNote text) async {
            //                 await _userTextService.deleteText(
            //                     documentId: text.documentId);
            //               },
            //               text: userText,
            //             );
            //           });
            //         } else {
            //           return const Center(child: CircularProgressIndicator());
            //         }
            //       default:
            //         return const Center(child: CircularProgressIndicator());
            //     }
            //   },
            // ),
            // Container(
            //   padding: const EdgeInsets.only(
            //     top: 20,
            //     left: 20,
            //     right: 20,
            //   ),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'Total Regular Hours: ',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //       Expanded(
            //         child: Container(),
            //       ),
            //       const Text('Amount'),
            //     ],
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsets.only(
            //     top: 20,
            //     left: 20,
            //     right: 20,
            //   ),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'Total Overtime Hours: ',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //       Expanded(
            //         child: Container(),
            //       ),
            //       const Text('Amount'),
            //     ],
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsets.only(
            //     top: 20,
            //     left: 20,
            //     right: 20,
            //   ),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'Total Daily Hours: ',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //       Expanded(
            //         child: Container(),
            //       ),
            //       const Text('Amount'),
            //     ],
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsets.only(
            //     top: 20,
            //     left: 20,
            //     right: 20,
            //   ),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'Total Weekly Hours: ',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //       Expanded(
            //         child: Container(),
            //       ),
            //       const Text('Amount'),
            //     ],
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsets.only(
            //     top: 20,
            //     left: 20,
            //     right: 20,
            //   ),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'Total Weekly Mileage: ',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //       Expanded(
            //         child: Container(),
            //       ),
            //       const Text('Amount'),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
