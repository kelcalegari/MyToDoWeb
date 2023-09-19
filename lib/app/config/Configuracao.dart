import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../components/Button.dart';
import '../../components/CustomAppBar.dart';
import '../../components/Editor.dart';
import '../../constants.dart';
import '../../services/ListController.dart';
import '../ResponsiveLayout.dart';
import 'UpdateUserAccount.dart';

class Settings extends StatefulWidget {
  Settings({super.key});

  final formKey = GlobalKey<FormState>();
  int? configIndex;
  int? viewIndex;
  List<dynamic> tags = ['Tag 1', 'Tag 2'];
  IconData selectedIcon = Icons.work;
  TextEditingController nomeController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageTitle: settingPageTitle,
      ),
      drawer: (ResponsiveLayout.isDesktop(context))
          ? null
          : Drawer(
              backgroundColor: Theme.of(context).colorScheme.background,
              child: _drawer(context),
            ),
      body: ResponsiveLayout(
          key: UniqueKey(),
          mobile: _mobileViel(context),
          tablet: null,
          desktop: _webViel(context)),
    );
  }

  Widget _mobileViel(BuildContext context) {
    return _configAtual();
  }

  Widget _webViel(BuildContext context) {
    return Row(key: UniqueKey(), children: [
      Container(
        key: UniqueKey(),
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
        child: ConstrainedBox(
          key: UniqueKey(),
          constraints: const BoxConstraints(maxWidth: 250),
          child: _drawer(context),
        ),
      ),
      Expanded(child: _configAtual()),
    ]);
  }

  Widget _configAtual() {
    switch (widget.configIndex) {
      case 1:
        return UpdateAccount();
      case 2:
        return _listConfig(context);
      default:
        return _listConfig(context);
    }
  }

  Widget _drawer(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        if (ResponsiveLayout.isNotDesktop(context))
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ListTile(
          leading: const Icon(Icons.list_sharp),
          title: const Text(listText),
          onTap: () {
            setState(() {
              widget.configIndex = 2;
            });
            if (ResponsiveLayout.isNotDesktop(context)) {
              Navigator.of(context).pop();
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.manage_accounts),
          title: const Text(accountText),
          onTap: () {
            setState(() {
              widget.configIndex = 1;
            });
            if (ResponsiveLayout.isNotDesktop(context)) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  Widget _listConfig(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (ResponsiveLayout.isNotMobile(context))
          ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: _taskLists(context))
        else if (widget.viewIndex == null)
          Expanded(child: _taskLists(context)),
        if (ResponsiveLayout.isNotMobile(context)) const VerticalDivider(),
        if (widget.viewIndex != null) Expanded(child: _editingTips(context))
      ],
    );
  }

  Stack _taskLists(BuildContext context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      _list(context),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              widget.nomeController.clear();
              widget.tags = ['Tag 1', 'Tag 2'];
              widget.selectedIcon = iconsList.first;
              widget.viewIndex =
                  context.read<ListController>().configUser.configLists.length;
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    ]);
  }

  ReorderableListView _list(BuildContext context) {
    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      children: <Widget>[
        for (int index = 0;
            index <
                context.read<ListController>().configUser.configLists.length;
            index += 1)
          ListTile(
            key: Key('$index'),
            leading: Icon(iconsList[context
                .read<ListController>()
                .configUser
                .configLists[index]['icone']]),
            title: Text(context
                .read<ListController>()
                .configUser
                .configLists[index]['nome']),
            onTap: () {
              setState(() {
                widget.nomeController.text = context
                    .read<ListController>()
                    .configUser
                    .configLists[index]['nome'];
                widget.tags.clear();
                widget.tags.addAll(context
                    .read<ListController>()
                    .configUser
                    .configLists[index]['tag']);

                widget.selectedIcon = iconsList[context
                    .read<ListController>()
                    .configUser
                    .configLists[index]['icone']];
                widget.viewIndex = index;
              });
            },
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final Map<String, dynamic> item = context
              .read<ListController>()
              .configUser
              .configLists
              .removeAt(oldIndex);
          context
              .read<ListController>()
              .configUser
              .configLists
              .insert(newIndex, item);

          for (int index = 0;
              index <
                  context.read<ListController>().configUser.configLists.length;
              index += 1) {
            if (context.read<ListController>().configUser.configLists[index]
                    ['ordem'] !=
                index) {
              context.read<ListController>().configUser.configLists[index]
                  ['ordem'] = index;
            }
          }
          context.read<ListController>().updateConfigUser();
        });
      },
    );
  }

  Widget _editingTips(BuildContext context) {
    Container deleteIconRight() {
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

    Container deleteIconLeft() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.redAccent,
        alignment: Alignment.centerLeft,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      );
    }

    List<Map<String, String>> tiposTask = [
      {'nome': 'basictask', 'titulo': basicTaskText},
      {'nome': 'basictask', 'titulo': advancedTask}
    ];

    Map<String, String> chosenValue = tiposTask.first;
    bool isNew =
        (context.read<ListController>().configUser.configLists.length ==
            widget.viewIndex!);

    return Form(
      key: widget.formKey,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Editor(
                      ctrl: widget.nomeController,
                      textInputType: TextInputType.name,
                      label: titleText,
                      pad: 0,
                      validador: (valor) {
                        if (valor!.isEmpty) {
                          return enterTitleText;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? const Color(0xFF454545)
                                  : const Color(0xFFEDF1F8),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: DropdownButton<IconData>(
                          focusColor:
                              (Theme.of(context).brightness == Brightness.dark)
                                  ? const Color(0xFF454545)
                                  : const Color(0xFFEDF1F8),
                          borderRadius: BorderRadius.circular(15.0),
                          value: widget.selectedIcon,
                          onChanged: (newValue) {
                            setState(() {
                              widget.selectedIcon = newValue!;
                            });
                          },
                          items:
                              iconsList.map<DropdownMenuItem<IconData>>((icon) {
                            return DropdownMenuItem<IconData>(
                              value: icon,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 30),
                                child: Icon(icon),
                              ),
                            );
                          }).toList(),
                          underline: Container(),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: (Theme.of(context).brightness ==
                                    Brightness.dark)
                                ? const Color(0xFF454545)
                                : const Color(0xFFEDF1F8),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: DropdownButton<Map<String, String>>(
                            borderRadius: BorderRadius.circular(15.0),
                            //style: const TextStyle(fontSize: 20.0),
                            isExpanded: true,
                            value: chosenValue,
                            hint: const Text(typeText),
                            onChanged: (newValue) {
                              setState(() {
                                chosenValue = newValue!;
                              });
                            },
                            items: tiposTask
                                .map<DropdownMenuItem<Map<String, String>>>(
                              (Map<String, String> option) {
                                return DropdownMenuItem<Map<String, String>>(
                                  value: option,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child:
                                        Text(option[titleText.toLowerCase()]!),
                                  ),
                                );
                              },
                            ).toList(),
                            underline: Container(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Editor(
                        ctrl: widget.tagController,
                        textInputType: TextInputType.text,
                        label: newTagText,
                        pad: 0,
                        validador: (valor) {
                          if (widget.tags.isEmpty) {
                            return singleTagMessage;
                          }
                          return null;
                        },
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                        onPressed: () {
                          widget.tags.add(widget.tagController.text);
                          widget.tagController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.save),
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(minHeight: 100, maxHeight: 200),
                    child: Container(
                      decoration: BoxDecoration(
                        color: (Theme.of(context).brightness == Brightness.dark)
                            ? const Color(0xFF454545)
                            : const Color(0xFFEDF1F8),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.tags.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                                background: deleteIconLeft(),
                                secondaryBackground: deleteIconRight(),
                                onDismissed:
                                    (DismissDirection direction) async {
                                  if (widget.tags.length != 1) {
                                    widget.tags.removeAt(index);
                                    setState(() {});
                                  }
                                },
                                confirmDismiss:
                                    (DismissDirection direction) async {
                                  return Future.delayed(
                                      const Duration(seconds: 1),
                                      () =>
                                          direction ==
                                          DismissDirection.endToStart);
                                },
                                key: UniqueKey(),
                                child: ListTile(
                                  title: Text(widget.tags[index]),
                                ));
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 35, left: 35, bottom: 40, top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (ResponsiveLayout.isMobile(context))
                          Expanded(
                            child: Button(
                              btnText: cancelText,
                              onPressed: () {
                                setState(() {
                                  widget.viewIndex = null;
                                  widget.tags = ['Tag 1', 'Tag 2'];
                                  widget.nomeController.clear();
                                  widget.tagController.clear();
                                });
                              },
                              pad: 0,
                            ),
                          ),
                        if (ResponsiveLayout.isMobile(context) &&
                            context
                                    .read<ListController>()
                                    .configUser
                                    .configLists
                                    .length >
                                1)
                          const SizedBox(
                            width: 20,
                          ),
                        if (!isNew &&
                            context
                                    .read<ListController>()
                                    .configUser
                                    .configLists
                                    .length >
                                1)
                          Expanded(
                            child: Button(
                              btnText: deleteText,
                              onPressed: () {
                                context
                                    .read<ListController>()
                                    .deleteDocumentsByType(context
                                            .read<ListController>()
                                            .configUser
                                            .configLists[widget.viewIndex!]
                                        ['nome']);

                                setState(() {
                                  widget.viewIndex = null;
                                  widget.tags = ['Tag 1', 'Tag 2'];
                                  widget.nomeController.clear();
                                  widget.tagController.clear();
                                });
                              },
                              pad: 0,
                            ),
                          ),
                        if ((!isNew &&
                                (context
                                        .read<ListController>()
                                        .configUser
                                        .configLists
                                        .length >
                                    1)) &&
                            ResponsiveLayout.isNotMobile(context))
                          const SizedBox(
                            width: 20,
                          ),
                        if (ResponsiveLayout.isNotMobile(context))
                          Expanded(
                            child: Button(
                              btnText: saveText,
                              onPressed: () {
                                if (widget.formKey.currentState!.validate()) {
                                  Map<String, dynamic> tipo = {
                                    "nome": widget.nomeController.text,
                                    "ordem": widget.viewIndex,
                                    "icone":
                                        iconsList.indexOf(widget.selectedIcon),
                                    "tag": widget.tags
                                  };
                                  if (!isNew) {
                                    context
                                        .read<ListController>()
                                        .updateDocumentsByType(
                                            context
                                                    .read<ListController>()
                                                    .configUser
                                                    .configLists[
                                                widget.viewIndex!]['nome'],
                                            widget.nomeController.text,
                                            tipo);
                                  } else {
                                    context
                                        .read<ListController>()
                                        .addNewList(tipo);
                                  }

                                  setState(() {
                                    widget.viewIndex = null;
                                    widget.tags = ['Tag 1', 'Tag 2'];
                                    widget.nomeController.clear();
                                    widget.tagController.clear();
                                  });
                                }
                              },
                              pad: 0,
                            ),
                          ),
                      ],
                    ),
                    if (ResponsiveLayout.isMobile(context))
                      const SizedBox(
                        height: 20,
                      ),
                    if (ResponsiveLayout.isMobile(context))
                      Button(
                        btnText: saveText,
                        onPressed: () {
                          if (widget.formKey.currentState!.validate()) {
                            Map<String, dynamic> tipo = {
                              "nome": widget.nomeController.text,
                              "ordem": widget.viewIndex,
                              "icone": iconsList.indexOf(widget.selectedIcon),
                              "tag": widget.tags
                            };
                            if (!isNew) {
                              context
                                  .read<ListController>()
                                  .updateDocumentsByType(
                                      context
                                              .read<ListController>()
                                              .configUser
                                              .configLists[widget.viewIndex!]
                                          ['nome'],
                                      widget.nomeController.text,
                                      tipo);
                            } else {
                              context.read<ListController>().addNewList(tipo);
                            }

                            setState(() {
                              widget.viewIndex = null;
                              widget.tags = ['Tag 1', 'Tag 2'];
                              widget.nomeController.clear();
                              widget.tagController.clear();
                            });
                          }
                        },
                        pad: 0,
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
