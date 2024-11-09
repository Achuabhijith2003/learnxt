import 'package:firebase_auth/firebase_auth.dart';

class Authservices {
 Future<bool> logout()async {
   
      //logout method
      try {
        await FirebaseAuth.instance.signOut();
        return true;
      } catch (e) {
        print("Error in LogOut:$e");
         return false;
      }

      // ignore: use_build_context_synchronously
      // Navigator.pushReplacement(
      //     // ignore: use_build_context_synchronously
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const Loginpage(),
      //     ));
    }
  }

