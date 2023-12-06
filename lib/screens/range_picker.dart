import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_keeper/widgets/reuseable_elevated_button.dart';
import 'package:time_keeper/widgets/reuseable_outlined_button.dart';

class RangePicker extends StatefulWidget {
  const RangePicker({super.key});

  @override
  State<RangePicker> createState() => _RangePickerState();
}

class _RangePickerState extends State<RangePicker> {
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );

  CollectionReference db = FirebaseFirestore.instance.collection('events');

  double _totalRegularHours = 0;
  double _totalOvertimeHours = 0;
  double _totalTotalHours = 0;

  Future<double> sumRegularHours(DateTime startDate, DateTime endDate) async {
    // Query event collection for documents between the start and end dates
    await FirebaseFirestore.instance
        .collection('events')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) async {
        double? value =
            double.tryParse(element.data()['regular hours'].toString()) ?? 0;
        _totalRegularHours = _totalRegularHours + value;
      });
    });
    return _totalRegularHours;
  }

  Future<double> sumOvertimeHours(DateTime startDate, DateTime endDate) async {
    // Query event collection for documents between the start and end dates
    await FirebaseFirestore.instance
        .collection('events')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) async {
        double? value =
            double.tryParse(element.data()['overtime hours'].toString()) ?? 0;
        _totalOvertimeHours = _totalOvertimeHours + value;
      });
    });
    return _totalOvertimeHours;
  }

  Future<double> sumTotalHours(DateTime startDate, DateTime endDate) async {
    // Query event collection for documents between the start and end dates
    await FirebaseFirestore.instance
        .collection('events')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) async {
        double? value =
            double.tryParse(element.data()['total hours'].toString()) ?? 0;
        _totalTotalHours = _totalTotalHours + value;
      });
    });
    return _totalTotalHours;
  }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime.now().subtract(const Duration(days: 100)),
      lastDate: DateTime.now().add(const Duration(days: 100)),
    );
    if (newDateRange == null) return; // 'X' is pressed

    setState(() {
      dateRange = newDateRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    final startDate = dateRange.start;
    final endDate = dateRange.end;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeKeeper'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 2),
            Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 84, 77, 88),
              child: Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 8, right: 8, bottom: 10),
                child: const Text(
                  'Select a range of dates to display a total of hours worked.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReuseableOutlinedButton(
                  text:
                      '${startDate.month}/${startDate.day}/${startDate.year} - ${endDate.month}/${endDate.day}/${endDate.year}',
                  color: const Color.fromARGB(255, 246, 238, 229),
                  onPressed: pickDateRange,
                ),
                const SizedBox(height: 40),
                ReuseableElevatedButton(
                  text: 'Calculate Hours',
                  color: const Color.fromARGB(255, 37, 33, 41),
                  onPressed: () async {
                    _totalRegularHours = 0;
                    _totalOvertimeHours = 0;
                    _totalTotalHours = 0;
                    await sumRegularHours(startDate, endDate);
                    await sumOvertimeHours(startDate, endDate);
                    await sumTotalHours(startDate, endDate);
                    print('Sum of regular hours is: $_totalRegularHours');
                    print('Sum of overtime hours is: $_totalOvertimeHours');
                    print('Sum of total hours is: $_totalTotalHours');
                  },
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(22),
                  child: ListTile(
                    title: Text(
                      'Total Regular Hours: $_totalRegularHours\n\nTotal Overtime Hours: $_totalOvertimeHours\n\nTotal Hours: $_totalTotalHours',
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
