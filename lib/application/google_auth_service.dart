import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart'
    show GoogleSignInPlatform;
import 'package:google_sign_in_web/google_sign_in_web.dart';

class GoogleAuthService {
  static final googleInstance = GoogleSignIn();

  static Future<void> init() async {
    await (GoogleSignInPlatform.instance as GoogleSignInPlugin).init();
  }

  static Future<void> logout() async {
    await googleInstance.signOut();
  }
}
