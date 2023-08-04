import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_keeper/routes.dart';
import 'package:time_keeper/screens/settings_screen.dart';

class CalendarScreen extends StatefulWidget {
  static const String screen = 'calendar';
  const CalendarScreen({super.key});
  static dynamic focusedDay;
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TextEditingController _date = TextEditingController();

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        final datePicked = Navigator.pushNamed(context, dayOfTheWeekRoute,
            arguments: dateSelected(selectedDay));
        print(datePicked);
      });
    }
  }

  DateTime dateSelected(selectedDay) {
    return _selectedDay = DateTime.timestamp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeKeeper'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Welcome! Select a date to enter or view your data.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: TableCalendar(
                //startingDayOfWeek: StartingDayOfWeek.monday,
                pageJumpingEnabled: true,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                focusedDay: _focusedDay,
                firstDay: DateTime(2020, 10, 16),
                lastDay: DateTime(3000, 3, 14),
                calendarFormat: _calendarFormat,
                //calling onDaySelected method to take user to the day_of_the_week screen
                onDaySelected: onDaySelected,
                onPageChanged: dateSelected,
                //TODO add an onchanged maybe to when date is selected, it will take to new screen
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
              ),
              child: Row(
                children: [
                  const Text(
                    'Monthly Regular Hours Total: ',
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
                    'Monthly Overtime Hours Total: ',
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
                    'Monthly Hours Total: ',
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
                    'Monthly Mileage Total: ',
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
      ),
    );
  }
}
