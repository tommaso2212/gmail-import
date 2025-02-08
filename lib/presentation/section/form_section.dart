import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gmail_import/application/gmail_import_service.dart';

class FormSection extends ConsumerStatefulWidget {
  const FormSection({
    super.key,
  });

  @override
  ConsumerState<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends ConsumerState<FormSection> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filtri',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            label: Text('Inserisci email'),
            border: OutlineInputBorder(),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: OutlinedButton(
              onPressed: () {
                final q = _controller.text.isNotEmpty
                    ? 'from:${_controller.text}'
                    : null;

                ref.read(gmailImportProvider).fetchEmails(query: q);
              },
              child: Text('Cerca email'),
            ),
          ),
        ),
      ],
    );
  }
}
