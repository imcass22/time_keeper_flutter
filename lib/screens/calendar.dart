import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_keeper/screens/day_of_the_week.dart';

class Calendar extends StatefulWidget {
  static const String screen = 'calendar_screen';
  const Calendar({super.key});
  static dynamic focusedDay;
  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        Navigator.pushNamed(context, DayOfTheWeek.screen,
            arguments: dateSelected(focusedDay));
      });
    }
  }

  DateTime dateSelected(focusedDay) {
    return _focusedDay = focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeKeeper'),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, Settings.screen);
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
            Container(
              height: 350,
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
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime(3000, 3, 14),
                calendarFormat: _calendarFormat,
                //calling onDaySelected method to take user to the day_of_the_week screen
                onDaySelected: onDaySelected,
                onPageChanged: dateSelected,
                //TODO add an onchanged maybe to when date is selected, it will take to new screen
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 70,
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
