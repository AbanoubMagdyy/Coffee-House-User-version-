
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  late  String message;
  late String userName;
  late String email;
  late String time;
  late DateTime dateTime;

  MessageModel(
      {required this.message,
        required this.time,
        required this.userName,
        required this.dateTime,
        required this.email,
      });

  MessageModel.fromJson(Map<String, dynamic> json) {
    email = json['ID'];
    Timestamp firestoreTimestamp = json['datetime'];
    DateTime datetime = firestoreTimestamp.toDate();
    dateTime = datetime;
    time = json['Time'];
    message = json['Message'];
  }

  Map<String, dynamic> toMap() {
    return {
      'Time': time,
      'ID': email,
      'Message': message,
      'datetime': dateTime,
    };
  }
}
