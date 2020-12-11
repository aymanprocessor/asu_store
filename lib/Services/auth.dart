import 'package:asu_store/models/registration_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

FirebaseAuth auth = FirebaseAuth.instance;
Future<User> login(String username, String password) async {
  auth.setPersistence(Persistence.LOCAL);
  UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: username, password: password);
  if (userCredential.user != null) {
    return userCredential.user;
  }
  return null;
}

Future<User> registration(RegistrationModel data) async {
  await Firebase.initializeApp();
  final UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(
          email: data.email, password: data.password);

  User user = userCredential.user;
  if (user != null) {
    return userCredential.user;
  }
  return null;
}

Future<bool> logout() async {
  User user = auth.currentUser;
  if (user != null) {
    auth.signOut();
    return true;
  }
  return false;
}
