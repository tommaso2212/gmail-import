import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:gmail_import/application/google_auth_service.dart';
import 'package:gmail_import/model/gmail_model.dart';
import 'package:googleapis/gmail/v1.dart';

class GoogleGmailService {
  GmailApi? gmailApi;

  List<String> get scopes => [
        GmailApi.gmailReadonlyScope,
        GmailApi.gmailInsertScope,
      ];

  Future<bool> _checkScopes() async =>
      await GoogleAuthService.googleInstance.canAccessScopes(scopes)
          ? true
          : GoogleAuthService.googleInstance.requestScopes(scopes);

  Future<void> init() async {
    if (await _checkScopes()) {
      final client =
          await GoogleAuthService.googleInstance.authenticatedClient();
      if (client != null) {
        gmailApi = GmailApi(client);
        return;
      }
    }
    throw Exception('Failed to initialize gmail client');
  }

  Future<List<String>> getEmailsIds({
    String? q,
  }) async {
    final emails = List<String>.empty(growable: true);

    String? nextPageToken;

    do {
      final response = await gmailApi?.users.messages.list(
        'me',
        q: q,
        pageToken: nextPageToken,
      );
      nextPageToken = response?.nextPageToken;
      emails.addAll(
        response?.messages
                ?.where((element) => element.id != null)
                .map((e) => e.id!) ??
            [],
      );
    } while (nextPageToken != null);

    return emails;
  }

  Future<GmailModel?> getMail(
    String id, {
    String format = 'raw',
  }) async {
    final response = await gmailApi?.users.messages.get(
      'me',
      id,
      format: format,
    );
    if (response != null) {
      return GmailModel(
        id: response.id,
        raw: response.raw,
        snippet: response.snippet,
      );
    }
    return null;
  }

  Future<void> insert(GmailModel model) async {
    await gmailApi?.users.messages.insert(
      Message(
        labelIds: [
          "INBOX",
        ],
        raw: model.raw,
      ),
      'me',
    );
  }
}
