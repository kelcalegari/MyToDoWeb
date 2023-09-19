import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Configs {
  late List<Map<String, dynamic>> _configLists;
  User? user = FirebaseAuth.instance.currentUser;

  Configs({
    List<Map<String, dynamic>>? listasConfig,
  }) {
    user = FirebaseAuth.instance.currentUser;
    if (listasConfig != null) {
      listasConfig.sort((a, b) => a['ordem'].compareTo(b['ordem']));
      _configLists = listasConfig;
    }
  }

  List<Map<String, dynamic>> get configLists => _configLists;

  factory Configs.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    List<Map<String, dynamic>> list =
        List<Map<String, dynamic>>.from(data['listasConfig']);
    list.sort((a, b) => a['ordem'].compareTo(b['ordem']));
    return Configs(
      listasConfig: list,
    );
  }

  // Criar uma nova configuração no Firestore
  Future<void> createConfigs() async {
    try {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user?.uid)
          .collection('configuracoes')
          .doc(user?.uid);

      await docRef.set({
        'listasConfig': _configLists,
      });
    } catch (e) {
      throw Exception('Erro ao criar a configuração: $e');
    }
  }

  Future<Configs> getConfigs() async {
    try {
      final DocumentReference docRef = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user?.uid)
          .collection('configuracoes')
          .doc(user?.uid);

      DocumentSnapshot snapshot = await docRef.get();

      if (snapshot.exists) {
        return Configs.fromFirestore(snapshot);
      } else {
        return Configs(listasConfig: [
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
      }
    } catch (e) {
      throw Exception('Erro ao buscar a configuração: $e');
    }
  }

  Future<void> addConfigs(Map<String, dynamic> type) async {
    _configLists.add(type);
    await updateFirestoreConfigs();
  }

  Future<void> deleteConfig(String oldTipo) async {
    Map<String, dynamic>? apagar;
    for (Map<String, dynamic> atual in _configLists) {
      if ((atual['nome'] == oldTipo)) {
        apagar = atual;
      } else if (apagar != null) {
        atual['ordem'] -= 1;
      }
    }
    if (apagar != null) {
      _configLists.remove(apagar);
    }
    await updateFirestoreConfigs();
  }

  Future<void> updateConfigByName(
      String oldTipo, Map<String, dynamic> type) async {
    for (Map<String, dynamic> atual in _configLists) {
      if ((atual['nome'] == oldTipo)) {
        _configLists[_configLists.indexOf(atual)] = type;
      }
    }
    await updateFirestoreConfigs();
  }

  // Atualizar uma configuração no Firestore
  Future<void> updateFirestoreConfigs() async {
    try {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user?.uid)
          .collection('configuracoes')
          .doc(user?.uid);

      await docRef.update({
        'listasConfig': _configLists,
      });
    } catch (e) {
      throw Exception('Erro ao atualizar a configuração: $e');
    }
  }

  // Deletar uma configuração do Firestore
  Future<void> deleteConfigs() async {
    try {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user?.uid)
          .collection('configuracoes')
          .doc(user?.uid);

      await docRef.delete();
    } catch (e) {
      throw Exception('Erro ao deletar a configuração: $e');
    }
  }

  List<Map<String, dynamic>> getSortedConfigLists(
      List<Map<String, dynamic>> lista) {
    lista.sort((a, b) => a['ordem'].compareTo(b['ordem']));
    return lista;
  }

  Future<void> updateConfigLists() async {
    try {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user?.uid)
          .collection('configuracoes')
          .doc(user?.uid);

      DocumentSnapshot snapshot = await docRef.get();
      Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?; // Explicit cast here
      if (data != null && data.containsKey('listasConfig')) {
        List<Map<String, dynamic>> lista =
            (data['listasConfig'] as List<dynamic>)
                .cast<Map<String, dynamic>>(); // Explicit cast here
        lista.sort((a, b) => a['ordem'].compareTo(b['ordem']));
        _configLists = lista;
      } else {
        // If 'listasConfig' is not found in Firestore, set the default list
        _configLists = [
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
        ];
        createConfigs();
      }
    } catch (e) {
      throw Exception('Erro ao buscar a configuração: $e');
    }
  }

  List<String> getTags(String nome) {
    for (var item in _configLists) {
      if (item['nome'] == nome) {
        return List<String>.from(item['tag']);
      }
    }
    return [];
  }
}
