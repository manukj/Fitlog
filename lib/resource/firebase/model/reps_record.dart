import 'package:cloud_firestore/cloud_firestore.dart';

class RepsRecord {
  DateTime date;
  int count;

  RepsRecord({required this.date, required this.count});

  factory RepsRecord.fromMap(Map<String, dynamic> map) {
    return RepsRecord(
      date: (map['date'] as Timestamp).toDate(),
      count: map['count'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'count': count,
    };
  }
}
