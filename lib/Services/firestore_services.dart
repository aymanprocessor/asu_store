import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

User user = FirebaseAuth.instance.currentUser;
final firestore = FirebaseFirestore.instance;
final CollectionReference userCol = firestore.collection('users');
Future<void> addUser(Map<String, dynamic> user) {
  return userCol.doc(user['email']).set(user, SetOptions(merge: true));
}

Future<void> addBalance(int bal) {
  return userCol
      .doc(user.email)
      .update({"current_balance": FieldValue.increment(bal)});
}

String email2name(String email) {
  userCol.doc(user.email).get().then((value) {
    return value.data()['name'];
  });
}
