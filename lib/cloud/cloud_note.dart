import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String? note;
  final double? regularHours;
  final double? overtimeHours;
  final double? mileage;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    this.regularHours,
    this.overtimeHours,
    this.mileage,
    this.note,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        note = snapshot.data()[noteFieldName] as String,
        regularHours = snapshot.data()[regularHoursFieldName] as double,
        overtimeHours = snapshot.data()[overtimeHoursFieldName] as double,
        mileage = snapshot.data()[mileageFieldName] as double;
}
