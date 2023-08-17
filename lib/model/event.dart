import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final DateTime date;
  final String id;
  final String? notes;
  final String? regularHours;
  final String? overtimeHours;
  final String? mileage;
  //constructor
  Event({
    required this.regularHours,
    required this.overtimeHours,
    required this.mileage,
    required this.notes,
    required this.id,
    required this.date,
  });
  // reading data from firebase and converting to event
  factory Event.fromJson(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Event(
      date: (data['date'] as Timestamp).toDate(),
      id: doc.id,
      notes: data['notes'],
      regularHours: data['regular hours'],
      overtimeHours: data['overtime hours'],
      mileage: data['mileage'],
    );
  }
}
