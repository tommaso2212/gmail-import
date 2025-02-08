import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gmail_import/application/gmail_import_service.dart';
import 'package:gmail_import/model/gmail_model.dart';

final fetchedEmails = StateProvider<List<GmailModel>>(
  (ref) => [],
);

class GmailListSection extends ConsumerWidget {
  const GmailListSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(fetchedEmails);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: () => ref.read(gmailImportProvider).insertEmails(list),
            child: Text('Import ${list.length}'),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: list.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) => GmailListItem(
            model: list[index],
          ),
        ),
      ],
    );
  }
}

class GmailListItem extends StatelessWidget {
  const GmailListItem({
    required this.model,
    super.key,
  });

  final GmailModel model;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(model.snippet ?? 'Empty'),
      ),
    );
  }
}
