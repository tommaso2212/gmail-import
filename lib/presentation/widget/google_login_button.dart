import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return renderButton(
      configuration: GSIButtonConfiguration(
        logoAlignment: GSIButtonLogoAlignment.center,
        size: GSIButtonSize.large,
        theme: GSIButtonTheme.outline,
        type: GSIButtonType.standard,
        shape: GSIButtonShape.rectangular,
        text: GSIButtonText.signin,
      ),
    );
  }
}
