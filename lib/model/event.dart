import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final DateTime date;
  final String id;
  final String? notes;
  final String? regularHours;
  final String? overtimeHours;
  final String? mileage;
  final String? totalHours;
  //constructor
  Event({
    required this.regularHours,
    required this.overtimeHours,
    required this.mileage,
    required this.notes,
    required this.id,
    required this.date,
    required this.totalHours,
  });

  // reading data from firebase and converting to event
  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Event(
      regularHours: data['regular hours'],
      overtimeHours: data['overtime hours'],
      mileage: data['mileage'],
      notes: data['notes'],
      id: snapshot.id,
      date: data['date'].toDate(),
      totalHours: data['total hours'],
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'id': id,
      'notes': notes,
      'mileage': mileage,
      'regularHours': regularHours,
      'overtimeHours': overtimeHours,
      'totalHours': totalHours,
    };
  }
}
