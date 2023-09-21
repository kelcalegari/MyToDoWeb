// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../../components/Button.dart';
import '../../components/CardBasicTask.dart';
import '../../components/Chip/BasicChip.dart';
import '../../components/Chip/DateChip.dart';
import '../../components/CustamDrawer.dart';
import '../../components/CustomAppBar.dart';
import '../../components/Editor.dart';
import '../../components/Chip/PrioriedadeChip.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../components/funcions.dart';
import '../../constants.dart';
import '../../models/tasks/BasicTask.dart';
import '../../services/ListController.dart';
import '../ResponsiveLayout.dart';

class BasicTaskView extends StatefulWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();

  BasicTask? taskView;
  int? viewIndex;
  bool isEditing = false;
  bool newTask = false;
  bool _bottomSheetActive = false;
  String currentType;
  final formKey = GlobalKey<FormState>();
  final viewFormKey = GlobalKey<FormState>();
  BasicTaskView({required this.currentType, super.key});

  @override
  State<StatefulWidget> createState() {
    return _BasicTaskViewState();
  }

  void _resetText() {
    titleController.text = "";
    detailsController.text = "";
    priorityController.text = priorityText;
    tagController.text = tagText;
    deadlineController.text = deadlineText;
  }
}

class _BasicTaskViewState extends State<BasicTaskView> {
  @override
  void initState() {
    super.initState();
    widget.titleController.addListener(_atualizarTask);
    widget.detailsController.addListener(_atualizarTask);
    widget.priorityController.addListener(_atualizarTask);
    widget.tagController.addListener(_atualizarTask);
    widget.deadlineController.addListener(_atualizarTask);
  }

  @override
  void dispose() {
    widget.titleController.dispose;
    widget.detailsController.dispose;
    widget.priorityController.dispose;
    widget.tagController.dispose;
    widget.deadlineController.dispose;
    super.dispose();
  }

  void _atualizarTask() {
    if (widget.taskView != null) {
      DateTime? deadline =
          (widget.deadlineController.text.toLowerCase() == deadlineText)
              ? null
              : DateFormat('HH:mm - dd/MM/yyyy')
                  .parse(widget.deadlineController.text);

      widget.taskView!.upThisTask(
          widget.titleController.text,
          widget.detailsController.text,
          deadline,
          widget.tagController.text,
          widget.priorityController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOFF = MediaQuery.of(context).viewInsets.bottom == 0;
    widget._resetText;
    return Consumer<ListController>(builder: (context, controlerList, _) {
      return Scaffold(
        key: UniqueKey(),
        appBar: CustomAppBar(
          pageTitle: "$taskText ${widget.currentType}",
        ),
        drawer: (ResponsiveLayout.isDesktop(context))
            ? null
            : Drawer(
                child: CustamDrawer(
                  actualPage: widget.currentType,
                ),
              ),
        floatingActionButton:
            (ResponsiveLayout.isNotDesktop(context) && isKeyboardOFF)
                ? FloatingActionButton(
                    onPressed: () {
                      widget._resetText();
                      (ResponsiveLayout.isMobile(context))
                          ? _displayBottomSheet(context, null, null)
                          : setState(() {
                              widget.taskView = null;
                              widget.newTask = true;
                              widget.isEditing = true;
                              widget.viewIndex = null;
                            });
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
        body: ResponsiveLayout(
          key: UniqueKey(),
          mobile: _mobileViel(controlerList),
          tablet: _tabletViel(controlerList),
          desktop: _webViel(controlerList),
        ),
      );
    });
  }

  Stack _mobileViel(ListController controlerList) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if ((widget.isEditing == true || widget.newTask == true) &&
          !widget._bottomSheetActive &&
          ResponsiveLayout.isMobile(context)) {
        _displayBottomSheet(context, widget.viewIndex, widget.taskView);
      }
    });
    return _basicTask(controlerList);
  }

  Row _tabletViel(ListController controlerList) {
    return Row(
      children: [
        Flexible(
          flex: 4,
          child: _basicTask(controlerList),
        ),
        const VerticalDivider(),
        Flexible(
            flex: 5,
            child: (widget.taskView != null || widget.newTask)
                ? _taskView(controlerList)
                : Container())
      ],
    );
  }

  Row _webViel(ListController controlerList) {
    return Row(
      children: [
        Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CustamDrawer(
                  labelButton: newTaskText,
                  actualPage: widget.currentType,
                  onPressed: () {
                    widget._resetText();
                    setState(
                      () {
                        widget.taskView = null;
                        widget.newTask = true;
                        widget.isEditing = true;
                        widget.viewIndex = null;
                      },
                    );
                  },
                ),
              ),
            )),
        Flexible(
          flex: 4,
          child: _basicTask(controlerList),
        ),
        const VerticalDivider(),
        Flexible(
            flex: 5,
            child: (widget.taskView != null || widget.newTask)
                ? _taskView(controlerList)
                : Container())
      ],
    );
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
        if (controlerList.isLoading)
          loadingIndicator()
        else
          ListView.builder(
            key: UniqueKey(),
            itemCount: controlerList.basicTasks(widget.currentType).length,
            itemBuilder: (context, index) {
              return (ResponsiveLayout.isMobile(context))
                  ? Visibility(
                      visible:
                          filtered(controlerList, index, widget.currentType),
                      child: Dismissible(
                        background: _leftEditIcon(),
                        secondaryBackground: _rightDeleteIcon(),
                        onDismissed: (DismissDirection direction) {
                          context
                              .read<ListController>()
                              .deleteBasicTask(widget.currentType, index);
                        },
                        confirmDismiss: (DismissDirection direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            BasicTask temp = controlerList
                                .basicTasks(widget.currentType)
                                .elementAt(index);
                            _displayBottomSheet(context, index, temp);
                            return false;
                          } else {
                            return Future.delayed(const Duration(seconds: 1),
                                () => direction == DismissDirection.endToStart);
                          }
                        },
                        key: ObjectKey(index),
                        child: CardBasicTask(
                          basicTask: controlerList
                              .basicTasks(widget.currentType)
                              .elementAt(index),
                          onChanged: () {},
                          onTap: () {
                            if (ResponsiveLayout.isNotMobile(context)) {
                              widget._resetText();
                              widget.viewIndex = index;
                              widget.taskView = BasicTask.copy(controlerList
                                  .basicTasks(widget.currentType)
                                  .elementAt(index));
                              widget.isEditing = false;
                              setState(() {});
                            }
                            ;
                          },
                        ),
                      ),
                    )

                  : Visibility(
                      visible:
                          filtered(controlerList, index, widget.currentType),
                      child: CardBasicTask(
                        basicTask: controlerList
                            .basicTasks(widget.currentType)
                            .elementAt(index),
                        onChanged: () {},
                        onTap: () {
                          widget._resetText();
                          setState(() {
                            widget.viewIndex = index;
                            widget.taskView = BasicTask.copy(controlerList
                                .basicTasks(widget.currentType)
                                .elementAt(index));
                            widget.isEditing = false;
                            widget.newTask = false;
                          });
                        },
                      ),
                    );
            },
          ),
      ],
    );
  }

  void _displayBottomSheet(BuildContext context, int? index, BasicTask? task) {
    widget._bottomSheetActive = true;
    _resetView();

    _fetchTexts(index, task);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          if (!ResponsiveLayout.isMobile(context) &&
              widget._bottomSheetActive) {
            widget.isEditing = true;
            widget.viewIndex = index;
            if (task == null) {
              widget.newTask = true;
            }
            Navigator.pop(context);
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: widget.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: FittedBox(
                              child: Text(
                                "$taskText:",
                                style: TextStyle(
                                  fontSize: 20,
                                  overflow: TextOverflow
                                      .ellipsis, // Opcional: controla como o texto é cortado
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              PrioriedadeChip(ctrl: widget.priorityController),
                              const SizedBox(width: 10),
                              BasicChip(
                                  ctrl: widget.tagController,
                                  opts: context
                                      .read<ListController>()
                                      .getTags(widget.currentType)),
                              const SizedBox(width: 10),
                              DateChip(ctrl: widget.deadlineController),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Editor(
                        ctrl: widget.titleController,
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
                      const SizedBox(height: 10),
                      Editor(
                        ctrl: widget.detailsController,
                        textInputType: TextInputType.multiline,
                        pad: 0,
                        maxLines: 4,
                        label: detailsText,
                      ),
                      const SizedBox(height: 20),
                      Button(
                        onPressed: () async {
                          if (widget.formKey.currentState!.validate()) {
                            String? tag = getStr(
                                widget.tagController, tagText.toLowerCase());
                            String? prioriedade = getStr(
                                widget.priorityController,
                                priorityText.toLowerCase());
                            DateTime? deadline =
                                (widget.deadlineController.text.toLowerCase() ==
                                        deadlineText.toLowerCase())
                                    ? null
                                    : DateFormat('HH:mm - dd/MM/yyyy')
                                        .parse(widget.deadlineController.text);
                            if (index != null) {
                              context.read<ListController>().updateBasicTask(
                                    widget.currentType,
                                    index,
                                    widget.titleController.text,
                                    widget.detailsController.text,
                                    deadline,
                                    tag,
                                    prioriedade,
                                  );
                            } else {
                              context.read<ListController>().addBasicTask(
                                    widget.currentType,
                                    widget.titleController.text,
                                    widget.detailsController.text,
                                    deadline,
                                    tag,
                                    prioriedade,
                                  );
                            }
                            setState(() {
                              widget.taskView = null;
                              widget.viewIndex = null;
                              widget.isEditing = false;
                              widget.newTask = false;
                            });
                            Navigator.pop(context);
                          }
                        },
                        btnText: saveText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    ).whenComplete(() {
      widget._bottomSheetActive = false;
    });
  }

  Container _taskView(ListController controlerList) {
    Form _addVielTask(BuildContext context, int? index, BasicTask? task,
        bool isEditing, bool newTask) {
      _fetchTexts(index, task);

      return Form(
        key: widget.viewFormKey,
        child: ListView(
          dragStartBehavior: DragStartBehavior.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrioriedadeChip(
                      ctrl: widget.priorityController,
                      divScreen: 1.8,
                      isEditing: isEditing,
                    ),
                    const SizedBox(width: 10),
                    BasicChip(
                      ctrl: widget.tagController,
                      opts: context
                          .read<ListController>()
                          .getTags(widget.currentType),
                      divScreen: 1.8,
                      isEditing: isEditing,
                    ),
                    const SizedBox(width: 10),
                    DateChip(
                      ctrl: widget.deadlineController,
                      divScreen: 1.8,
                      isEditing: isEditing,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                isEditing
                    ? Editor(
                        ctrl: widget.titleController,
                        textInputType: TextInputType.text,
                        pad: 0,
                        label: titleText,
                        validador: (valor) {
                          if (valor!.isEmpty) {
                            return enterTitleText;
                          }
                          return null;
                        },
                      )
                    : Text(
                        widget.titleController.text,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                const SizedBox(height: 10),
                isEditing
                    ? Editor(
                        ctrl: widget.detailsController,
                        textInputType: TextInputType.multiline,
                        pad: 0,
                        maxLines: 4,
                        label: detailsText,
                      )
                    : ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 150),
                        child: Text(
                          (widget.detailsController.text.isNotEmpty)
                              ? widget.detailsController.text
                              : detailsText,
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!newTask)
                      Flexible(
                        child: Button(
                            btnText: deleteText,
                            pad: 0,
                            onPressed: () {
                              if (index != null) {
                                context
                                    .read<ListController>()
                                    .deleteBasicTask(widget.currentType, index);
                              }
                              setState(() {
                                widget.taskView = null;
                                widget.viewIndex = null;
                                widget.isEditing = false;
                                widget.newTask = false;
                              });
                            }),
                      ),
                    if (!newTask) const SizedBox(width: 20),
                    isEditing
                        ? Flexible(
                            child: Button(
                              pad: 0,
                              onPressed: () {
                                setState(() {
                                  widget.isEditing = false;
                                  widget.newTask = false;
                                });
                              },
                              btnText: cancelText,
                            ),
                          )
                        : Flexible(
                            child: Button(
                                btnText: editText,
                                pad: 0,
                                onPressed: () {
                                  setState(() {
                                    widget.isEditing = true;
                                  });
                                }),
                          ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isEditing)
                  Button(
                    pad: 0,
                    onPressed: () async {
                      if (widget.viewFormKey.currentState!.validate()) {
                        String? tag =
                            getStr(widget.tagController, tagText.toLowerCase());
                        String? prioriedade = getStr(widget.priorityController,
                            priorityText.toLowerCase());
                        DateTime? deadline =
                            (widget.deadlineController.text.toLowerCase() ==
                                    deadlineText.toLowerCase())
                                ? null
                                : DateFormat('HH:mm - dd/MM/yyyy')
                                    .parse(widget.deadlineController.text);
                        if (index != null) {
                          context.read<ListController>().updateBasicTask(
                                widget.currentType,
                                index,
                                widget.titleController.text,
                                widget.detailsController.text,
                                deadline,
                                tag,
                                prioriedade,
                              );
                        } else {
                          context.read<ListController>().addBasicTask(
                                widget.currentType,
                                widget.titleController.text,
                                widget.detailsController.text,
                                deadline,
                                tag,
                                prioriedade,
                              );
                        }
                        setState(() {
                          widget.isEditing = false;
                          widget.viewIndex ??= controlerList
                              .basicTasks(widget.currentType)
                              .length;
                          if (newTask) {
                            widget.newTask = false;
                            widget.taskView = BasicTask(
                                taskType: widget.currentType,
                                title: widget.titleController.text,
                                details: widget.detailsController.text,
                                deadline: deadline,
                                tag: tag,
                                priority: prioriedade);
                          }
                        });
                      }
                    },
                    btnText: saveText,
                  ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: (widget.taskView != null || widget.newTask)
          ? _addVielTask(context, widget.viewIndex, widget.taskView,
              widget.isEditing, widget.newTask)
          : Container(),
    );
  }

  void _resetView() {
    widget.taskView = null;
    widget.viewIndex = null;
    widget.isEditing = false;
    widget.newTask = false;
  }

  void _fetchTexts(int? index, BasicTask? task) {
    if (index != null && task != null) {
      widget.titleController.text = task.title;
      widget.detailsController.text = task.details;
      if (task.deadline != null) {
        widget.deadlineController.text =
            DateFormat('HH:mm - dd/MM/yyyy').format(task.deadline!);
      } else if (widget.deadlineController.text == "") {
        widget.deadlineController.text = deadlineText;
      }

      if (task.tag != null) {
        widget.tagController.text = task.tag!;
      } else if (widget.tagController.text == "") {
        widget.tagController.text = tagText;
      }

      if (task.priority != null) {
        widget.priorityController.text = task.priority!;
      } else if (widget.priorityController.text == "") {
        widget.priorityController.text = priorityText;
      }
    }
  }

  String? getStr(TextEditingController controlador, String valSrt) {
    return controlador.text.toLowerCase() == valSrt ? null : controlador.text;
  }
}
