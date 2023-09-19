import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app/ResponsiveLayout.dart';
import '../constants.dart';
import '../models/tasks/BasicTask.dart';
import '../services/ListController.dart';
import 'package:provider/provider.dart';


import 'funcions.dart';

class CardBasicTask extends StatefulWidget {
  final BasicTask basicTask;
  final VoidCallback onChanged;
  final VoidCallback onTap;
  final bool isInHome;
  bool view = false;
  CardBasicTask(
      {required this.basicTask,
      required this.onChanged,
      required this.onTap,
      this.isInHome = false,
      super.key});

  @override
  State<CardBasicTask> createState() => _CardBasicTaskState();
}

class _CardBasicTaskState extends State<CardBasicTask> {
  String dataStr = "";

  @override
  Widget build(BuildContext context) {
    bool isToday = false;
    bool isLate = false;
    if (widget.basicTask.deadline != null) {
      dataStr =
          DateFormat('HH:mm - dd/MM/yyyy').format(widget.basicTask.deadline!);

      DateTime today = DateTime.now();
      isToday = widget.basicTask.deadline?.year == today.year &&
          widget.basicTask.deadline?.month == today.month &&
          widget.basicTask.deadline?.day == today.day;

      isLate = widget.basicTask.deadline?.isBefore(today) ?? false;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            widget.view = !widget.view;
          });
        },
        onTap: widget.onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.basicTask.title,
                                    textScaleFactor: 1.5,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: widget.basicTask.done
                                        ? const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough)
                                        : const TextStyle(
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            if ((dataStr != "") ||
                                (widget.basicTask.priority != null) ||
                                (widget.basicTask.tag != null))
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxHeight: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Visibility(
                                      visible:
                                          widget.basicTask.priority != null,
                                      child: Chip(
                                        labelPadding: const EdgeInsets.all(0),
                                        visualDensity:
                                            (ResponsiveLayout.isMobile(context))
                                                ? VisualDensity.compact
                                                : VisualDensity.comfortable,
                                        label: SizedBox(
                                          height: 20,
                                          child: Text(
                                            widget.basicTask.priority ?? "",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                height: 0),
                                          ),
                                        ),
                                        backgroundColor: getColorFromPriority(
                                            widget.basicTask.priority),
                                      ),
                                    ),
                                    Visibility(
                                        visible: (widget.basicTask.priority !=
                                                null) &&
                                            ((dataStr != "") ||
                                                (widget.basicTask.tag != null)),
                                        child: const SizedBox(width: 10)),
                                    Visibility(
                                      visible: widget.basicTask.tag != null,
                                      child: Chip(
                                        labelPadding: const EdgeInsets.all(0),
                                        visualDensity:
                                            (ResponsiveLayout.isMobile(context))
                                                ? VisualDensity.compact
                                                : VisualDensity.comfortable,
                                        label: SizedBox(
                                          height: 20,
                                          child: Text(
                                            widget.basicTask.tag ?? "",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                height: 0),
                                          ),
                                        ),
                                        backgroundColor:
                                            const Color(secondaryColor),
                                      ),
                                    ),
                                    Visibility(
                                        visible:
                                            (widget.basicTask.tag != null) &&
                                                (dataStr != ""),
                                        child: const SizedBox(width: 10)),
                                    Visibility(
                                      visible: dataStr != "",
                                      child: Chip(
                                        labelPadding: const EdgeInsets.all(0),
                                        visualDensity:
                                            (ResponsiveLayout.isMobile(context))
                                                ? VisualDensity.compact
                                                : VisualDensity.comfortable,
                                        label: SizedBox(
                                          height: 20,
                                          child: Text(
                                            dataStr,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                height: 0),
                                          ),
                                        ),
                                        backgroundColor: isToday
                                            ? const Color(tertiaryColor)
                                            : isLate
                                                ? Colors.red
                                                : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Checkbox(
                        value: widget.basicTask.done,
                        onChanged: (bool? value) {
                          context
                              .read<ListController>()
                              .uTaskBasicState(widget.basicTask);
                        }),
                  ],
                ),
                if (widget.view &&
                    (widget.basicTask.details.isNotEmpty) &&
                    (ResponsiveLayout.isMobile(context) || widget.isInHome))
                  Column(
                    children: [
                      const Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxHeight: 100),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                      widget.basicTask.details,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
