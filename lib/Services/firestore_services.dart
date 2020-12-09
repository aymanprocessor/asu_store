import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

User user = FirebaseAuth.instance.currentUser;
final firestore = FirebaseFirestore.instance;
//final CollectionReference userCol = firestore.collection('users');
Future<void> addUser(Map<String, dynamic> user) {
  final CollectionReference userCol = firestore.collection('users');

  return userCol.doc(user['email']).set(user, SetOptions(merge: true));
}
