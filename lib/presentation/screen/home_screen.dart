import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gmail_import/presentation/section/form_section.dart';
import 'package:gmail_import/presentation/section/gmail_list_section.dart';
import 'package:gmail_import/presentation/section/logged_user_section.dart';
import 'package:gmail_import/presentation/utils/loader_manager.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LoaderManagerWrapper(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                LoggedEmailSection(),
                const Divider(height: 32),
                FormSection(),
                const Divider(height: 32),
                GmailListSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
