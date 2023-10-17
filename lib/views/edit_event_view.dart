import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_keeper/model/event.dart';
import '../widgets/reuseable_elevated_button.dart';

class EditEventView extends StatefulWidget {
  final Event event;
  const EditEventView({super.key, required this.event});

  @override
  State<EditEventView> createState() => _EditEventViewState();
}

class _EditEventViewState extends State<EditEventView> {
  final TextEditingController notesController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController regularHoursController = TextEditingController();
  final TextEditingController overtimeHoursController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  String totalHours = "0";

  @override
  void initState() {
    super.initState();
    dateController.text = widget.event.date.toIso8601String().substring(0, 10);
    notesController.text = widget.event.notes!;
    regularHoursController.text = widget.event.regularHours!;
    overtimeHoursController.text = widget.event.overtimeHours!;
    mileageController.text = widget.event.mileage!;
    totalHours = widget.event.totalHours!;
  }

  // method for calculation the sum of regular and overtime hours
  void hoursSum() {
    setState(() {
      double? total = double.tryParse(regularHoursController.text)! +
          double.tryParse(overtimeHoursController.text)!;
      totalHours = total.toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
    notesController.dispose();
    regularHoursController.dispose();
    overtimeHoursController.dispose();
    mileageController.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 242, 236),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 85, 145, 140),
        title: const Text('Edit Data'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 2),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 154, 171, 154),
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                child: const Text(
                  'Edit your data below: ',
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
                    initialDate: widget.event.date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2222),
                  );
                  if (newDate != null) {
                    setState(() {
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
                    'Edit your regular hours: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(
                    width: 70,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: regularHoursController,
                      decoration: const InputDecoration(
                        constraints: BoxConstraints(
                          maxHeight: 30,
                          maxWidth: 40,
                        ),
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // only allows numbers to be entered into the text field
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly,
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
                    'Edit your overtime hours: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(
                    width: 70,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: overtimeHoursController,
                      decoration: const InputDecoration(
                        constraints: BoxConstraints(
                          maxHeight: 30,
                          maxWidth: 40,
                        ),
                        border: OutlineInputBorder(),
                        fillColor: Colors.grey,
                      ),
                      // only allows numbers to be entered into the text field
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly,
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
                    'Edit your mileage: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(
                    width: 70,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: mileageController,
                      decoration: const InputDecoration(
                        constraints: BoxConstraints(
                          maxHeight: 30,
                          maxWidth: 40,
                        ),
                        border: OutlineInputBorder(),
                        fillColor: Color.fromARGB(255, 218, 217, 217),
                      ),
                      // only allows numbers to be entered into the text field
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly,
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
                    decoration: const InputDecoration(
                      hintText: 'Enter your notes here...',
                      constraints: BoxConstraints(
                        maxHeight: 200,
                        maxWidth: 390,
                      ),
                      border: OutlineInputBorder(),
                      fillColor: Color.fromARGB(255, 226, 222, 222),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ReuseableElevatedButton(
              text: 'Save',
              color: const Color.fromARGB(255, 85, 145, 140),
              onPressed: () {
                hoursSum();
                FirebaseFirestore.instance
                    .collection('events')
                    .doc(widget.event.id)
                    .update({
                  'date': DateTime.parse(dateController.text),
                  'regular hours': regularHoursController.text,
                  'overtime hours': overtimeHoursController.text,
                  'mileage': mileageController.text,
                  'notes': notesController.text,
                  'total hours': totalHours,
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
            ReuseableElevatedButton(
              text: 'Delete',
              color: const Color.fromARGB(255, 141, 62, 58),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('events')
                    .doc(widget.event.id)
                    .delete();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
