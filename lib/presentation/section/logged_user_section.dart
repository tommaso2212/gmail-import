import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gmail_import/application/google_auth_service.dart';
import 'package:gmail_import/model/user_model.dart';
import 'package:gmail_import/presentation/widget/google_login_button.dart';

final loggedUserProvider =
    StateNotifierProvider<LoggedUserProvider, UserModel?>(
  (ref) => LoggedUserProvider(),
);

class LoggedUserProvider extends StateNotifier<UserModel?> {
  LoggedUserProvider() : super(null) {
    _init();
  }

  void _init() {
    GoogleAuthService.googleInstance.onCurrentUserChanged.listen(
      (event) => state = event != null
          ? UserModel(
              name: event.displayName,
              email: event.email,
              imageUrl: event.photoUrl,
            )
          : null,
    );
  }

  Future<bool> get isLogged => GoogleAuthService.googleInstance.isSignedIn();
}

class LoggedEmailSection extends ConsumerWidget {
  const LoggedEmailSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loggedUserProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: user != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: user.imageUrl != null
                        ? NetworkImage(user.imageUrl!)
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(user.email ?? 'Nessuna mail'),
                  ),
                  FilledButton(
                    onPressed: () => GoogleAuthService.logout(),
                    child: Text('Logout'),
                  ),
                ],
              )
            : GoogleLoginButton(),
      ),
    );
  }
}
