import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_keeper/model/event.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime? _selectedDate;
  //store the events created
  Map<DateTime, List<Event>> events = {};
  late final ValueNotifier<List<Event>> _selectedEvents;
  // makes the calendar have a month format
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    super.initState();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDate, focusedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
      print(_focusedDay.toIso8601String().substring(0, 10));
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    //retrieve all events from the selected day
    return events[day] ?? [];
  }

  String onPageChanged(focusedDay) {
    _focusedDay = focusedDay;

    return _focusedDay.toIso8601String().substring(0, 10);
  }

  returnDate() {
    return Text(_selectedDate != null
        ? _selectedDate!.toIso8601String().substring(0, 10)
        : "TimeKeeper");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      body: Column(
        children: [
          TableCalendar(
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            pageJumpingEnabled: true,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            focusedDay: _focusedDay,
            firstDay: DateTime(2020, 10, 16),
            lastDay: DateTime(3000, 3, 14),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            //calling onDaySelected method to take user to the day_of_the_week screen
            onDaySelected: onDaySelected,
            onPageChanged: onPageChanged,
            calendarStyle: const CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      //height: 200,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
