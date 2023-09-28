import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_keeper/auth/auth_user.dart';
import 'package:time_keeper/screens/settings_screen.dart';
import 'package:time_keeper/views/add_event_view.dart';
import 'package:time_keeper/views/edit_event_view.dart';
import '../model/event.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;

  late Map<DateTime, List<Event>> _events;

  @override
  void initState() {
    //so events are loaded
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    //_selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _loadFirestoreEvents();
  }

  //get unique hash code for each date
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  // load all Firestore user data
  _loadFirestoreEvents() async {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('events')
        // get data for ONLY the current user
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('date', isGreaterThanOrEqualTo: firstDay)
        .where('date', isLessThanOrEqualTo: lastDay)
        .withConverter(
            fromFirestore: Event.fromFirestore,
            toFirestore: (event, options) => event.toFirestore())
        .get();
    for (var doc in snap.docs) {
      final event = doc.data();
      final day =
          DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      _events[day]!.add(event);
    }
    setState(() {});
  }

  List<Event> _getEventsForDay(DateTime day) {
    //retrieve all events from the selected day
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 242, 236),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 85, 145, 140),
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 2,
            ),
            Container(
              height: 90,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 154, 171, 154),
              child: Container(
                padding: const EdgeInsets.only(top: 24, left: 8, right: 8),
                child: const Text(
                  'Welcome! Select a date to view your data or press the plus button to add a new log.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 370,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                children: [
                  TableCalendar<Event>(
                    eventLoader: _getEventsForDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    pageJumpingEnabled: true,
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    availableGestures: AvailableGestures.all,
                    focusedDay: _focusedDay,
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                      _loadFirestoreEvents();
                    },
                    calendarStyle: const CalendarStyle(
                      isTodayHighlighted: true,
                      selectedDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 85, 145, 140),
                    child: const Icon(Icons.add, color: Colors.white),
                    onPressed: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEventView(
                            selectedDate: _selectedDay,
                          ),
                        ),
                      );
                      if (result ?? false) {
                        _loadFirestoreEvents();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // navigation to edit events
            ..._getEventsForDay(_selectedDay).map(
              (event) => GestureDetector(
                onTap: () async {
                  Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditEventView(event: event),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(
                    event.date.toString().substring(0, 10),
                  ),
                  subtitle: Text(
                    'Regular hours: ${event.regularHours!}\nOvertime hours: ${event.overtimeHours}\nTotal hours: ${event.totalHours}\nMileage: ${event.mileage}\nNotes: ${event.notes}',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
