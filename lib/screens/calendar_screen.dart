import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_keeper/screens/day_of_the_week_screen.dart';
import 'package:time_keeper/screens/settings_screen.dart';
import 'package:time_keeper/views/add_event_view.dart';
import 'package:time_keeper/views/edit_event_view.dart';
import 'package:time_keeper/widgets/calendar_widget.dart';
import '../model/event.dart';

class CalendarScreen extends StatefulWidget {
  static const String screen = 'calendar';
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  Map<DateTime, List<Event>> events = {};
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  List<Event> _getEventsForDay(DateTime day) {
    //retrieve all events from the selected day
    return events[day] ?? [];
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 85, 145, 140),
        //title: const Text('TimeKeeper'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
          icon: const Icon(Icons.settings),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_selectedDay != null
                ? _selectedDay!.toIso8601String().substring(0, 10)
                : "TimeKeeper"),
            if (_selectedDay != null)
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDay = null;
                  });
                },
                icon: const Icon(Icons.close),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: _selectedDay ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2222),
              );
              if (newDate != null) {
                setState(() {
                  _selectedDay = newDate;
                });
              }
            },
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Welcome! Select a date to view your data or press the plus button to add a new log.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: const CalendarWidget(),
              // child: CalendarDatePicker(
              //     initialDate: DateTime.now(),
              //     firstDate: DateTime(2020),
              //     lastDate: DateTime(2222),
              //     onDateChanged: (DateTime value) {
              //       _selectedDate = value;
              //     }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 85, 145, 140),
                    child: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AddEventView()),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Expanded(
            //   child: ValueListenableBuilder<List<Event>>(
            //     valueListenable: _selectedEvents,
            //     builder: (context, value, _) {
            //       return ListView.builder(
            //         itemCount: value.length,
            //         itemBuilder: (context, index) {
            //           return Container(
            //             height: 200,
            //             margin: const EdgeInsets.symmetric(
            //               horizontal: 12.0,
            //               vertical: 4.0,
            //             ),
            //             decoration: BoxDecoration(
            //               border: Border.all(),
            //               borderRadius: BorderRadius.circular(12.0),
            //             ),
            //             child: ListTile(
            //               onTap: () => print('${value[index]}'),
            //               title: Text('${value[index]}'),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),
            StreamBuilder<QuerySnapshot>(
              stream: _selectedDay == null
                  ? FirebaseFirestore.instance.collection('events').snapshots()
                  : FirebaseFirestore.instance
                      .collection('events')
                      .where('date', isEqualTo: _selectedDay)
                      .snapshots(),
              builder: (context, snapshot) {
                // handle errors
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        'There was an error fetching the data: ${snapshot.error}'),
                  );
                }
                // handle loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Event> events =
                    snapshot.data!.docs.map((e) => Event.fromJson(e)).toList();
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    Event event = events[index];
                    return ListTile(
                      title: Text(
                        event.date.toIso8601String().substring(0, 10),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditEventView(event: event),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            // Container(
            //   padding: const EdgeInsets.only(
            //     top: 50,
            //     left: 20,
            //     right: 20,
            //   ),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'Monthly Regular Hours Total: ',
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
            //         'Monthly Overtime Hours Total: ',
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
            //         'Monthly Hours Total: ',
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
            //         'Monthly Mileage Total: ',
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
