import 'package:flutter/material.dart';


import '../app/ResponsiveLayout.dart';
import '../app/config/Configuracao.dart';
import 'package:provider/provider.dart';

import '../app/tasks/BasicTaskView.dart';
import '../constants.dart';
import '../models/tasks/BasicTask.dart';
import '../services/ListController.dart';
import 'Editor.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  String pageTitle;
  Key key = UniqueKey();
  CustomAppBar({required this.pageTitle, super.key});
  FocusNode focusNode = FocusNode();

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final FocusNode _focusNode = FocusNode();

  TextEditingController filterTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _focusNode.requestFocus();
    widget.focusNode.requestFocus();
    return AppBar(
      key: widget.key,
      title: Visibility(
          visible: !context.read<ListController>().searchState ||
              ResponsiveLayout.isNotMobile(context),
          child: Text(widget.pageTitle)),
      actions: [
        Visibility(
          visible: context.read<ListController>().searchState,
          child: SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Editor(
                ctrl: filterTextCtrl,
                textInputType: TextInputType.text,
                pad: 0,
                fontSize: 20,
                focusNode: _focusNode,
                onComplete: () {
                  setState(() {
                    context.read<ListController>().setFilterText(filterTextCtrl.text);
                    context.read<ListController>().searchState =
                        !context.read<ListController>().searchState;
                  });

                },
                onTapOutside: (valor){
                  setState(() {
                    context.read<ListController>().searchState =
                    !context.read<ListController>().searchState;
                  });
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: !context.read<ListController>().searchState,
          child: IconButton.outlined(
              onPressed: () {
                if (context.read<ListController>().searchState) {
                  context.read<ListController>().setFilterText(filterTextCtrl.text);
                }

                setState(() {
                  context.read<ListController>().searchState =
                      !context.read<ListController>().searchState;
                });
              },
              icon: Badge(
                  isLabelVisible: context.read<ListController>().filterText != "",
                  child: const Icon(Icons.search))),
        ),
        if (!context.read<ListController>().isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Badge(
              offset: const Offset(0, 0),
              isLabelVisible:
                  context.read<ListController>().getAllTaskToday().isNotEmpty,
              label: Text(
                context
                    .read<ListController>()
                    .getAllTaskToday()
                    .length
                    .toString(),
                style: const TextStyle(color: Colors.white),
              ),
              child: PopupMenuButton<BasicTask>(
                icon: const Icon(Icons.notification_important),
                itemBuilder: (BuildContext context) {
                  List<BasicTask> todayTasks =
                      context.read<ListController>().getAllTaskToday();

                  return todayTasks.map((task) {
                    return PopupMenuItem<BasicTask>(
                      value: task,
                      child: Container(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            task.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            task.taskType,
                          ),
                        ],
                      )),
                    );
                  }).toList();
                },
                onSelected: (task) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          BasicTaskView(currentType: task.taskType),
                      transitionDuration: const Duration(seconds: 0),
                    ),
                  );
                },
              ),
            ),
          ),
        if (ResponsiveLayout.isDesktop(context) &&
            widget.pageTitle != settingPageTitle)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}
