import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserData {
  final String userName;
  final String photoUrl;
  final String score;
  final String timeTaken;
  final Timestamp timestamp;

  UserData({
    required this.userName,
    required this.photoUrl,
    required this.score,
    required this.timeTaken,
    required this.timestamp,
  });

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserData(
      userName: data['user_name'] ?? '',
      photoUrl: data['photo'] ?? '',
      score: data['score'] ?? '',
      timeTaken: data['time_taken'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}

class FunctionsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<UserData>> getUserData() {
    return _firestore
        .collection('users')
        .orderBy('score', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserData> userDataList = [];
      for (var doc in query.docs) {
        userDataList.add(UserData.fromFirestore(doc));
      }
      return userDataList;
    });
  }
}
