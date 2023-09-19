import 'package:firebase_auth/firebase_auth.dart';



import '../constants.dart';
import '../models/Account.dart';
import '../models/Configs.dart';

class FirebaseAuthService {
  Account? _currentAccount;

  final FirebaseAuth _firebaseAuth;

  Account get userAtual => _currentAccount ?? Account(id: "");

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Account? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }

    _currentAccount =
        Account(id: user.uid, name: user.displayName, eMail: user.email);
    return _currentAccount;
  }

  Future<void> updateAccount() async {
    _currentAccount = (await currentAccount())!;
  }

  Stream<Account?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<UserCredential> signInFirebaseAuth(String email, String senha) async {
    UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
    _currentAccount = Account(
        id: authResult.user?.uid,
        name: authResult.user?.displayName,
        eMail: email);
    return authResult;
  }

  Future<UserCredential> cadastroInFirebaseAuth(
      String nome, String eMail, String senha) async {
    UserCredential authResult =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      password: senha,
      email: eMail,
    );
    authResult.user?.updateDisplayName(nome);
    _currentAccount = Account(id: authResult.user?.uid, name: nome, eMail: eMail);
    _currentAccount?.saveAccount(_currentAccount!);
    Configs createConfig = Configs(listasConfig: [
      {
        'icone': 1,
        'tipo': 'basictask',
        'nome': 'Pessoal',
        'ordem': 1,
        'tag': ['TAG 1', 'TAG 2'],
      },
      {
        'icone': 1,
        'tipo': 'basictask',
        'nome': 'Trabalho',
        'ordem': 2,
        'tag': ['TAG 1', 'TAG 2'],
      }
    ]);
    await createConfig.createConfigs();
    return authResult;
  }

  Future<void> updateAccountData(String newName, String newEmail,
      String currentPassword, String? newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);


      await user.updateEmail(newEmail);
      await user.updateDisplayName(newName);


      if (newPassword != null) {
        await user.updatePassword(newPassword);
      }
      _currentAccount?.eMail = newEmail;
      _currentAccount?.name = newName;
    } else {
      throw Exception(
          accountNotFoundMessage);
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<Account?> currentAccount() async {
    User? user = _firebaseAuth.currentUser!;
    return _userFromFirebase(user);
  }
}
