import 'package:firebase_auth/firebase_auth.dart';

class Authservices {
  Future<bool> logout() async {
    //logout method
    try {
      await FirebaseAuth.instance.signOut();
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
