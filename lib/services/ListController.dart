import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Configs.dart';

import '../models/tasks/BasicTask.dart';
import 'firebase_auth_service.dart';

class ListController extends ChangeNotifier {
  final Locator locator;
  bool _isLoading = true;
  bool _wasNotInit = true;
  bool searchState = false;
  String _idUser = "";
  String _filterText = "";
  late Configs _configUser;

  ListController(this.locator);

  void _setNotLoading() {
    _isLoading = false;
    notifyListeners();
  }

  String get filterText => _filterText;
  void setFilterText(String newFilter) {
    _filterText = newFilter;
    notifyListeners();
  }

  bool isUserChange() {
    String idUserAtual = locator<FirebaseAuthService>().userAtual.id ?? "";
    if (_idUser == idUserAtual) {
      return false;
    } else {
      _idUser = idUserAtual;
      return true;
    }
  }

  Future<bool> init() async {
    if (_wasNotInit || isUserChange()) {
      _configUser = await Configs().getConfigs();

      for (Map<String, dynamic> tipo in _configUser.configLists) {
        _lists[tipo['nome']] =
            (await BasicTask.getTasks(tipo['nome'])).toList();
      }

      _wasNotInit = false;
      _setNotLoading();

      return true;
    }
    return false;
  }

  //BasicTasks
  final Map<String, List<BasicTask>> _lists = {};

  List<BasicTask> basicTasks(String taskType) {
    return _lists[taskType] ?? [];
  }

  bool get isLoading => _isLoading;

  Future<void> addBasicTask(String taskType, String title, String details,
      DateTime? deadline, String? tag, String? priority) async {
    BasicTask newTask = BasicTask(
        taskType: taskType,
        title: title,
        details: details,
        deadline: deadline,
        tag: tag,
        priority: priority);
    newTask = await BasicTask.addTask(newTask);
    if (deadline == null) {
      _lists[taskType]?.add(newTask);
    } else {

      _lists[taskType]?.indexWhere((task) {
        if (task.deadline != null) {

          return newTask.deadline!.isBefore(task.deadline!);
        }
        return false;
      });

      insertInOrder(taskType, newTask);
    }

    notifyListeners();
  }

  void insertInOrder(String taskType, BasicTask newTask) {
    BasicTask? lastWithPrazo;
    int? insertionIndex = _lists[taskType]?.indexWhere((task) {
      if (task.deadline != null) {
        lastWithPrazo = task;
        return newTask.deadline!.isBefore(task.deadline!);
      }
      return false;
    });
    if (insertionIndex == null) {
      _lists[taskType]?.add(newTask);
    } else if (insertionIndex == -1) {
      if (lastWithPrazo != null) {
        int index = _lists[taskType]?.indexOf(lastWithPrazo!) ?? -1;
        _lists[taskType]?.insert(index + 1, newTask);
      } else {
        _lists[taskType]?.insert(0, newTask);
      }
    } else {
      _lists[taskType]?.insert(insertionIndex, newTask);
    }
  }

  Future<void> updateBasicTask(
      String taskType,
      int index,
      String title,
      String details,
      DateTime? deadline,
      String? tag,
      String? priority) async {

    if (_lists[taskType]?.elementAt(index).deadline != deadline) {
      _lists[taskType]
        ?.elementAt(index)
        .upThisTask(title, details, deadline, tag, priority);
      BasicTask? task = _lists[taskType]?.elementAt(index);
      _lists[taskType]?.removeAt(index);
      if (task != null) {
        insertInOrder(taskType, task);
      }
      else {
        _lists[taskType]
        ?.elementAt(index)
        .upThisTask(title, details, deadline, tag, priority);
      }
    }
    else{
      _lists[taskType]
          ?.elementAt(index)
          .upThisTask(title, details, deadline, tag, priority);
    }
    await BasicTask.updateTask(_lists[taskType]!.elementAt(index));
    notifyListeners();
  }

  Future<void> uTaskBasicState(BasicTask task) async {
    int? index = _lists[task.taskType]?.indexOf(task);
    _lists[task.taskType]?.elementAt(index!).done =
        !_lists[task.taskType]!.elementAt(index).done;
    await BasicTask.uTaskState(_lists[task.taskType]!.elementAt(index!));
    notifyListeners();
  }

  Future<void> deleteBasicTask(String taskType, int index) async {
    BasicTask temp = _lists[taskType]!.elementAt(index);
    _lists[taskType]!.remove(temp);
    notifyListeners();
    await BasicTask.deleteTask(temp);
  }

  List<BasicTask> getAllTaskToday() {
    List<BasicTask> allTask = [];
    for (String tipo in getListofTipes()) {
      allTask
          .addAll(basicTasks(tipo).where((task) => task.isDueToday).toList());
    }

    return allTask;
  }

  List<String> getListofTipes() {
    return _configUser.configLists
        .map((item) => item['nome'].toString())
        .toList();
  }

  Configs get configUser => _configUser;

  void updateConfigUser() {
    _configUser.updateFirestoreConfigs();
    notifyListeners();
  }

  void addNewList(Map<String, dynamic> type) {
    _configUser.addConfigs(type);
    notifyListeners();
  }

  void deleteDocumentsByType(String type) {
    _configUser.deleteConfig(type);
    BasicTask.deleteDocsByType(type);
    _lists.remove('tipo');
    notifyListeners();
  }

  void updateDocumentsByType(
      String oldType, String newType, Map<String, dynamic> type) {
    _configUser.updateConfigByName(oldType, type);
    BasicTask.updateDocsByType(oldType, newType);
    List<BasicTask>? temp = _lists[oldType];
    if (temp != null) {
      for (BasicTask task in temp) {
        task.taskType = newType;
      }
      _lists[newType] = temp;
    }
    notifyListeners();
  }

  List<String> getTags(String name) {
    return _configUser.getTags(name);
  }
}
