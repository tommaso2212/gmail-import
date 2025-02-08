import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gmail_import/application/google_gmail_service.dart';
import 'package:gmail_import/model/gmail_model.dart';
import 'package:gmail_import/presentation/section/gmail_list_section.dart';
import 'package:gmail_import/presentation/section/logged_user_section.dart';
import 'package:gmail_import/presentation/utils/loader_manager.dart';

final gmailImportProvider = Provider<GmailImportService>((ref) {
  final userProvider = ref.read(loggedUserProvider.notifier);
  final gmailService = GoogleGmailService();

  final listProvider = ref.read(fetchedEmails.notifier);

  final loaderManager = ref.read(loaderManagerProvider.notifier);

  return GmailImportService(
    userProvider: userProvider,
    gmailService: gmailService,
    listProvider: listProvider,
    loaderManager: loaderManager,
  );
});

class GmailImportService {
  GmailImportService({
    required this.userProvider,
    required this.gmailService,
    required this.listProvider,
    required this.loaderManager,
  });

  final LoggedUserProvider userProvider;
  final GoogleGmailService gmailService;
  final StateController<List<GmailModel>> listProvider;
  final LoaderManager loaderManager;

  Future<void> fetchEmails({String? query}) async {
    if (!await userProvider.isLogged) {
      return loaderManager.emitError(errorMessage: 'Login required');
    }

    try {
      loaderManager.emitLoading();
      await gmailService.init();
      final ids = await gmailService.getEmailsIds(
        q: query,
      );
      final emails = List<GmailModel>.empty(growable: true);
      for (var i = 0; i < ids.length; i++) {
        final email = await gmailService.getMail(ids[i]);
        loaderManager.emitProgress(i / ids.length);
        if (email != null) {
          emails.add(email);
        }
      }
      listProvider.state = emails;
      return loaderManager.reset();
    } catch (e) {
      return loaderManager.emitError(errorMessage: e.toString());
    }
  }

  Future<void> insertEmails(List<GmailModel> emails) async {
    if (!await userProvider.isLogged) {
      return loaderManager.emitError(errorMessage: 'Login required');
    }

    try {
      loaderManager.emitLoading();
      await gmailService.init();

      for (var i = 0; i < emails.length; i++) {
        await gmailService.insert(emails[i]);
        loaderManager.emitProgress(i / emails.length);
      }
      return loaderManager.reset();
    } catch (e) {
      return loaderManager.emitError(errorMessage: e.toString());
    }
  }
}
