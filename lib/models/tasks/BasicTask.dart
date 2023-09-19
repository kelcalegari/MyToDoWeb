// ignore_for_file: no_leading_underscores_for_local_identifiers



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BasicTask {
  String? id;
  String title;
  String taskType;
  String details;
  bool done;
  DateTime _startDate;
  DateTime? deadline;
  String? tag;
  String? priority;

  BasicTask(
      {required this.taskType,
      required this.title,
      this.id,
      this.details = '',
      this.done = false,
      this.deadline,
      this.tag,
      this.priority,
      DateTime? datInit})
      : _startDate = datInit ?? DateTime.now();

  BasicTask.copy(BasicTask outraTarefa)
      : id = outraTarefa.id,
        title = outraTarefa.title,
        details = outraTarefa.details,
        done = outraTarefa.done,
        _startDate = outraTarefa._startDate,
        deadline = outraTarefa.deadline,
        tag = outraTarefa.tag,
        priority = outraTarefa.priority,
        taskType = outraTarefa.taskType;
  @override
  String toString() {
    return "$id - $title - $done - $details - $tag - ${deadline.toString()}";
  }

  void upThisTask(String _titulo, String _detalhes, DateTime? _prazo,
      String? _tag, String? _prioridade) {
    title = _titulo;
    details = _detalhes;
    deadline = _prazo;
    tag = _tag;
    priority = _prioridade;
  }

  // Método para converter um documento Firestore em uma instância da classe BasicTask
  factory BasicTask.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return BasicTask(
        id: doc.id,
        taskType: data['tipoTask'],
        title: data['titulo'],
        done: data['done'],
        details: data['detalhes'],
        deadline: data['prazo'] != null
            ? (data['prazo'] as Timestamp).toDate()
            : null,
        tag: data['tag'],
        priority: data['prioriedade'],
        datInit: (data['datInit'] as Timestamp).toDate());
  }

  // Método para adicionar uma tarefa ao Firestore
  static Future<BasicTask> addTask(BasicTask task) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user?.uid)
          .collection('tasks')
          .doc();

      await docRef.set({
        'id': docRef.id,
        'tipoTask': task.taskType,
        'titulo': task.title,
        'done': task.done,
        'detalhes': task.details,
        'prazo': task.deadline != null ? Timestamp.fromDate(task.deadline!) : null,
        'tag': task.tag != null ? task.tag! : null,
        'prioriedade': task.priority != null ? task.priority! : null,
        'datInit': Timestamp.fromDate(task._startDate),
      });
      return BasicTask(
        id: docRef.id,
        taskType: task.taskType,
        title: task.title,
        done: task.done,
        details: task.details,
        deadline: task.deadline,
        tag: task.tag,
        priority: task.priority,
        datInit: task._startDate,
      );
    } catch (e) {
      debugPrint("Erro ao adicionar a tarefa: $e");
      rethrow;
    }
  }

  // Método para atualizar uma tarefa no Firestore
  static Future<void> updateTask(BasicTask task) async {

    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user?.uid)
          .collection('tasks')
          .doc(task.id)
          .update({
        'titulo': task.title,
        'done': task.done,
        'detalhes': task.details,
        'prazo': task.deadline != null ? Timestamp.fromDate(task.deadline!) : null,
        'tag': task.tag != null ? task.tag! : null,
        'prioriedade': task.priority != null ? task.priority! : null,
      });
    } catch (e) {
      print("Erro ao atualizar a tarefa: $e");
    }
  }

  static Future<void> uTaskState(BasicTask? task) async {
    if (task != null) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user?.uid)
            .collection('tasks')
            .doc(task.id)
            .update({
          'done': task.done,
        });
      } catch (e) {
        print("Erro ao atualizar a tarefa: $e");
      }
    }
  }

  // Método para deletar uma tarefa no Firestore
  static Future<void> deleteTask(BasicTask task) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user?.uid)
          .collection('tasks')
          .doc(task.id)
          .delete();
    } catch (e) {
      print("Erro ao deletar a tarefa: $e");
    }
  }

  // Método para recuperar todas as tarefas do Firestore
  static Future<List<BasicTask>> getTasks(String tipo) async {
   
    try {
      final user = FirebaseAuth.instance.currentUser;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user?.uid)
          .collection('tasks')
          .where('tipoTask', isEqualTo: tipo)
          .orderBy('prazo', descending: false)
          .orderBy('datInit', descending: false)
          .get();
      List<BasicTask> temp =
          snapshot.docs.map((doc) => BasicTask.fromFirestore(doc)).toList();
 

      List<BasicTask> retorno = temp.where((task) =>task.deadline != null).toList();

      temp.removeWhere((task) => task.deadline != null);

      retorno.addAll(temp);

      return retorno;
    } catch (e) {
      debugPrint("Erro ao recuperar as tarefas: $e");
      return [];
    }
  }

  static Future<List<BasicTask>> getUncompletedTasks() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user?.uid)
          .collection('tasks')
          .where('done', isEqualTo: false)
          .get();

      return snapshot.docs.map((doc) => BasicTask.fromFirestore(doc)).toList();
    } catch (e) {
      print("Erro ao recuperar as tarefas não concluídas: $e");
      return [];
    }
  }

  static Future<void> deleteDocsByType(String tipo) async {
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user?.uid)
        .collection('tasks')
        .where('tipoTask', isEqualTo: tipo)
        .get();

    for (QueryDocumentSnapshot docSnapshot in snapshot.docs) {
      await docSnapshot.reference.delete();
    }
  }

  static Future<void> updateDocsByType(
      String oldTipo, String newTipo) async {
    if (oldTipo == newTipo) {
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user?.uid)
        .collection('tasks')
        .where('tipoTask', isEqualTo: oldTipo)
        .get();

    for (QueryDocumentSnapshot docSnapshot in snapshot.docs) {
      await docSnapshot.reference.update({
        'tipoTask': newTipo,
      });
    }
  }

  bool get isDueToday {
    if (deadline != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dueDate = DateTime(deadline!.year, deadline!.month, deadline!.day);
      return (dueDate.isAtSameMomentAs(today) || dueDate.isBefore(today)) &&
          !done;
    }
    return false;
  }
}
