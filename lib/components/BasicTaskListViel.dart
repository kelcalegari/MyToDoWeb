// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/ResponsiveLayout.dart';
import '../app/tasks/BasicTaskView.dart';
import '../constants.dart';
import '../models/tasks/BasicTask.dart';
import '../services/ListController.dart';
import 'CardBasicTask.dart';

import 'funcions.dart';

class BasicTaskListViel extends StatefulWidget {
  List<String> listTypes;
  int index;
  VoidCallback backward, forward;
  Function onHorizontalDragUpdate;

  BasicTaskListViel(
      {required this.listTypes,
      required this.backward,
      required this.forward,
      required this.onHorizontalDragUpdate,
      this.index = 0,
      super.key});

  @override
  State<BasicTaskListViel> createState() => _BasicTaskListVielState();
}

class _BasicTaskListVielState extends State<BasicTaskListViel> {
  Container leftEditIcon() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: const Color(0xFF2e3253).withOpacity(0.5),
      alignment: Alignment.centerLeft,
      child: const Icon(
        Icons.edit,
        color: Colors.white,
      ),
    );
  }

  Container rightDeleteIcon() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.redAccent,
      alignment: Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListController>(builder: (context, controlerList, _) {
      return _basicTask(controlerList);
    });
  }

  Stack _basicTask(ListController controlerList) {
    Container _leftEditIcon() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: const Color(0xFF2e3253).withOpacity(0.5),
        alignment: Alignment.centerLeft,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      );
    }

    Container _rightDeleteIcon() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      );
    }

    return Stack(
      children: [
        if (controlerList.isLoading) loadingIndicator(),
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            widget.onHorizontalDragUpdate(details);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BasicTaskView(
                        currentType: widget.listTypes[widget.index]),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(tertiaryColor),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        maintainAnimation: true,
                        maintainSize: true,
                        maintainState: true,
                        visible: (ResponsiveLayout.isMobile(context) &&
                            (widget.index > 0)),
                        child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: widget.backward),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              iconsList[context
                                  .read<ListController>()
                                  .configUser
                                  .configLists[widget.index]['icone']],
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.listTypes[widget.index],
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: (ResponsiveLayout.isMobile(context) &&
                            (widget.index < (widget.listTypes.length - 1))),
                        child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: widget.forward),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: controlerList
                        .basicTasks(widget.listTypes[widget.index])
                        .length,
                    itemBuilder: (context, index) {
                      return Visibility(
                        visible: filtered(controlerList, index,
                            widget.listTypes[widget.index]),
                        child: Dismissible(
                          background: _leftEditIcon(),
                          secondaryBackground: _rightDeleteIcon(),
                          onDismissed: (DismissDirection direction) async {
                            setState(() {});

                            await controlerList.deleteBasicTask(
                                widget.listTypes[widget.index], index);
                          },
                          confirmDismiss: (DismissDirection direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              BasicTask temp = controlerList
                                  .basicTasks(widget.listTypes[widget.index])
                                  .elementAt(index);
                              showTaskPopup(context,
                                  widget.listTypes[widget.index], index, temp);
                              return false;
                            } else {
                              return Future.delayed(
                                  const Duration(seconds: 1),
                                  () =>
                                      direction == DismissDirection.endToStart);
                            }
                          },
                          key: UniqueKey(),
                          child: CardBasicTask(
                            basicTask: controlerList
                                .basicTasks(widget.listTypes[widget.index])
                                .elementAt(index),
                            isInHome: true,
                            onChanged: () {},
                            onTap: () {},
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
