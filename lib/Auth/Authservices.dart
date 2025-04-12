import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authservices {
  Future<bool> logout() async {
    //logout method
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      return true;
    } catch (e) {
      print("Error in LogOut:$e");
      return false;
    }
  }

  getuserID(){
      final user = FirebaseAuth.instance.currentUser;
      if (user!=null) {
       return   user.uid;
      }
 
  }
}
