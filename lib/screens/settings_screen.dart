import 'package:firebase_auth/firebase_auth.dart';

//signs user out of the app
void signUserOut() {
  FirebaseAuth.instance.signOut();
}
