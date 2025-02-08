import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gmail_import/application/google_auth_service.dart';
import 'package:gmail_import/presentation/screen/home_screen.dart';

Future<void> main() async {
  await GoogleAuthService.init();
  runApp(const ProviderScope(child: Main()));
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
