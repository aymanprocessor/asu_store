import 'package:asu_store/Services/user_services.dart';
import 'package:asu_store/models/registration_model.dart';
import 'package:asu_store/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

User user = FirebaseAuth.instance.currentUser;
final firestore = FirebaseFirestore.instance;
final CollectionReference userCol = firestore.collection('users');

Future addUser(UserModel user) async {
  await createUser(user);
  // return userCol.doc(user['email']).set(user, SetOptions(merge: true));
}

// Future<void> addBalance(int bal) {
//   return userCol
//       .doc(user.email)
//       .update({"current_balance": FieldValue.increment(bal)}).then((value) {
//     firestore.collection('balances').add({
//       "balance": bal,
//       "date": DateTime.now().millisecondsSinceEpoch,
//       "owner": user.email
//     });
//   });
// }

// class FirestoreService {
//   Future<DocumentSnapshot> id2name(String id) {
//     return FirebaseFirestore.instance.collection('products').doc(id).get();
//   }
// }
