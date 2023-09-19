import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/tasks/BasicTask.dart';
import '../services/ListController.dart';
import 'Button.dart';
import 'Chip/BasicChip.dart';
import 'Chip/DateChip.dart';
import 'Chip/PrioriedadeChip.dart';
import 'Editor.dart';

Center loadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

String parseAuthExceptionMessage(
    {String plugin = "auth", required String? input}) {
  if (input == null) {
    return "unknown";
  }
  String regexPattern = r'\(auth\/(.*)\)';
  RegExp regExp = RegExp(regexPattern);
  Match? match = regExp.firstMatch(input);

  if (match != null) {
    return match.group(1)!;
  }

  return "unknown";
}

Future<String?> showPopUp(
    BuildContext context, String initialValue, List<String> options) async {
  String chosenValue =
      options.contains(initialValue) ? initialValue : options.first;

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(labelOption),
            content: DropdownButton(
              isExpanded: true,
              value: chosenValue,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    chosenValue = newValue;
                  });
                }
              },
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              underline: Container(),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(chosenValue);
                },
                child: Text(okText),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<DateTime?> selectDate(BuildContext context, DateTime? deadline) async {
  deadline ??= DateTime.now();
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: deadline,
    firstDate: DateTime(DateTime.now().year),
    lastDate: DateTime(DateTime.now().year + 10),
  );

  if (pickedDate != null) {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(deadline),
    );

    if (pickedTime != null) {
      DateTime newDeadline = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      return newDeadline;
    }
  }
  return null;
}

void showTaskPopup(
    BuildContext context, String listType, int? index, BasicTask? task) {
  String? getString(TextEditingController controlador, String valSrt) {
    return controlador.text.toLowerCase() == valSrt ? null : controlador.text;
  }

  TextEditingController _titleController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _priorityController = TextEditingController();
  TextEditingController _tagController = TextEditingController();
  TextEditingController _deadlineController = TextEditingController();

  _priorityController.text = priorityText;
  _tagController.text = tagText;
  _deadlineController.text = deadlineText;
  final formKey = GlobalKey<FormState>();

  if (index != null && task != null) {
    _titleController.text = task.title;
    _detailsController.text = task.details;
    if (task.deadline != null) {
      _deadlineController.text =
          DateFormat('HH:mm - dd/MM/yyyy').format(task.deadline!);
    } else if (_deadlineController.text == "") {
      _deadlineController.text = deadlineText;
    }

    if (task.tag != null) {
      _tagController.text = task.tag!;
    } else if (_tagController.text == "") {
      _tagController.text = tagText;
    }

    if (task.priority != null) {
      _priorityController.text = task.priority!;
    } else if (_priorityController.text == "") {
      _priorityController.text = priorityText;
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  '$taskText $listType:',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 0,
                  runSpacing: 0,
                  children: [
                    PrioriedadeChip(ctrl: _priorityController),
                    const SizedBox(width: 10),
                    BasicChip(
                        ctrl: _tagController,
                        opts: context.read<ListController>().getTags(listType)),
                    const SizedBox(width: 10),
                    DateChip(ctrl: _deadlineController),
                  ],
                ),
                const SizedBox(height: 10),
                Editor(
                  ctrl: _titleController,
                  textInputType: TextInputType.text,
                  pad: 0,
                  label: titleText,
                  validador: (valor) {
                    if (valor!.isEmpty) {
                      return enterTitleText;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Editor(
                  ctrl: _detailsController,
                  textInputType: TextInputType.multiline,
                  pad: 0,
                  maxLines: 4,
                  label: detailsText,
                ),
                const SizedBox(height: 20),
                Button(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      String? tag = getString(_tagController, tagText.toLowerCase());
                      String? prioriedade =
                          getString(_priorityController, priorityText.toLowerCase());
                      DateTime? deadline =
                          (_deadlineController.text.toLowerCase() == deadlineText.toLowerCase())
                              ? null
                              : DateFormat('HH:mm - dd/MM/yyyy')
                                  .parse(_deadlineController.text);
                      if (index != null) {
                        context.read<ListController>().updateBasicTask(
                              listType,
                              index,
                              _titleController.text,
                              _detailsController.text,
                              deadline,
                              tag,
                              prioriedade,
                            );
                      } else {
                        context.read<ListController>().addBasicTask(
                              listType,
                              _titleController.text,
                              _detailsController.text,
                              deadline,
                              tag,
                              prioriedade,
                            );
                      }

                      Navigator.pop(context);
                    }
                  },
                  btnText: saveText,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Color? getColorFromPriority(String? priority) {
  switch (priority) {
    case 'Baixa':
      return Colors.grey[300] ?? Colors.grey;
    case 'Media':
      return Colors.cyan;
    case 'Alta':
      return Colors.deepPurple;
    case 'Urgente':
      return Colors.red[500] ?? Colors.red;
  }
  return null;
}

bool filtered(ListController controlerList, int index, String currentType) {
  if (controlerList.filterText == "") {
    return true;
  }
  if (controlerList
      .basicTasks(currentType)
      .elementAt(index)
      .title
      .toLowerCase()
      .contains(controlerList.filterText.toLowerCase())) {
    return true;
  }

  if (controlerList.basicTasks(currentType).elementAt(index).tag != null) {
    if (controlerList
        .basicTasks(currentType)
        .elementAt(index)
        .tag!
        .toLowerCase()
        .contains(controlerList.filterText.toLowerCase())) {
      return true;
    }
  }
  if (controlerList.basicTasks(currentType).elementAt(index).priority != null) {
    if (controlerList
        .basicTasks(currentType)
        .elementAt(index)
        .priority!
        .toLowerCase()
        .contains(controlerList.filterText.toLowerCase())) {
      return true;
    }
  }

  return false;
}

bool isValidPassword(String password) {
  if (password.length <= 6) {
    return false;
  }
  RegExp uppercaseRegex = RegExp(r'[A-Z]');
  RegExp lowercaseRegex = RegExp(r'[a-z]');
  RegExp numberRegex = RegExp(r'[0-9]');

  if (!uppercaseRegex.hasMatch(password) ||
      !lowercaseRegex.hasMatch(password) ||
      !numberRegex.hasMatch(password)) {
    return false;
  }

  return true;
}

String? validateName(value) {
  if (value.length < 2) {
    return nameRequiredMessage;
  } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
    return invalidNameMessage;
  }
  return null;
}
