import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      return account;
    } catch (error) {
      print(error); // Handle errors appropriately
      return null;
    }
  }
}

