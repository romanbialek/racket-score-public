import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/widgets.dart';
import 'package:racketscore/config/api_config.dart';
import 'package:racketscore/model/models.dart';

class AppwriteService extends ChangeNotifier {
  Client client = Client();
  late final Account account;
  late User _currentUser;
  AuthStatus _status = AuthStatus.uninitialized;
  late final Databases databases;

  User get currentUser => _currentUser;

  AuthStatus get status => _status;

  String? get username => _currentUser.name;

  String? get email => _currentUser.email;

  String? get userid => _currentUser.$id;

  AppwriteService() {
    init();
    loadUser();
  }

  init() {
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(ApiConfig.projectId)
        .setSelfSigned();
    account = Account(client);
    databases = Databases(client);
  }

  /*---AUTHORIZATION---*/

  loadUser() async {
    try {
      final user = await account.get();
      _status = AuthStatus.authenticated;
      _currentUser = user;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  Future<User> createUser(
      {required String email, required String password}) async {
    try {
      final user = await account.create(
          userId: ID.unique(), email: email, password: password);
      return user;
    } finally {
      notifyListeners();
    }
  }

  Future<Session> createEmailSession(
      {required String email, required String password}) async {
    try {
      final session =
          await account.createEmailSession(email: email, password: password);
      _currentUser = await account.get();
      _status = AuthStatus.authenticated;
      return session;
    } finally {
      notifyListeners();
    }
  }

  signOut() async {
    try {
      await account.deleteSession(sessionId: 'current');
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  /*---DATABASES---*/

  Future<Document?> createMatch(
      {required String matchName,
      required String teamA,
      required String teamB,
      required int setsToWin}) async {
    try {
      Document result = await databases.createDocument(
          databaseId: ApiConfig.databaseId,
          collectionId: ApiConfig.collectionId,
          documentId: ID.unique(),
          data: MatchDto(
                  id: "",
                  authorId: _currentUser.$id,
                  matchName: matchName,
                  setsToWin: setsToWin,
                  teamAName: teamA,
                  teamBName: teamB)
              .toMap());
      return Future.value(result);
    } on AppwriteException catch (e) {
      print(e);
      return null;
    }
  }

  Future<Document?> updateMatch({
    required MatchDto match,
  }) async {
    try {
      Document result = await databases.updateDocument(
          databaseId: ApiConfig.databaseId,
          collectionId: ApiConfig.collectionId,
          documentId: match.id,
          data: match.toMap());

      return Future.value(result);
    } on AppwriteException catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Document>?> getMatches() async {
    try {
      DocumentList result = await databases.listDocuments(
          databaseId: ApiConfig.databaseId,
          collectionId: ApiConfig.collectionId,
          queries: [
            Query.equal('author_id', _currentUser.$id),
            Query.orderDesc('\$createdAt')
          ]);
      return result.documents;
    } on AppwriteException catch (e) {
      print(e);
      return null;
    }
  }

  Future<Document?> getMatch({required String documentId}) async {
    try {
      Document result = await databases.getDocument(
          databaseId: ApiConfig.databaseId,
          collectionId: ApiConfig.collectionId,
          documentId: documentId);
      return result;
    } on AppwriteException catch (e) {
      print(e);
      return null;
    }
  }
}

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
}
