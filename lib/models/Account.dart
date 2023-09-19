import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Account {
  String? id;
  String? name;
  String? eMail;

  Account({ this.id, this.name = "", this.eMail = ""});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  @override
  String toString() {
    return 'Usuario{id: $id}';
  }

  static Account fromSnapshot(DocumentSnapshot snapshot) {
    return Account(
      id: snapshot.id,
    );
  }

  void saveAccount(Account usuario) async {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario.id)
          .set(usuario.toMap());
    } catch (e) {
      debugPrint('Erro ao salvar o usuário: $e');
    }
  }
}
