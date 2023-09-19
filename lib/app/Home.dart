// ignore_for_file: file_names, must_be_immutable

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


import '../components/BasicTaskListViel.dart';
import '../components/CustamDrawer.dart';
import '../components/CustomAppBar.dart';
import '../components/funcions.dart';
import '../constants.dart';
import '../services/ListController.dart';
import 'ResponsiveLayout.dart';

class Home extends StatefulWidget {
  bool notStarted = true;
  int index = 0;
  Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  bool isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ListController>(builder: (context, controlerList, _) {
      if (widget.notStarted) {
        return FutureBuilder(
            future: Provider.of<ListController>(context, listen: false).init(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  appBar: CustomAppBar(
                    pageTitle: homePageTitle,
                  ),
                  body: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: loadingIndicator(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(
                  color: Colors.redAccent,
                  child: loadingIndicator(),
                );
              } else if (!snapshot.hasData) {
                return Container(
                  color: Colors.orangeAccent,
                  child: loadingIndicator(),
                );
              } else {
                return _page(context, controlerList);
              }
            });
      } else {
        return _page(context, controlerList);
      }
    });
  }

  Scaffold _page(BuildContext context, ListController controlerList) {
    widget.notStarted = false;
    return Scaffold(
      key: UniqueKey(),
      appBar: CustomAppBar(
        pageTitle: homePageTitle,
      ),
      floatingActionButton: PopupMenuButton<String>(
        splashRadius: 10,
        onSelected: (value) {
          showTaskPopup(context, value, null, null);
        },
        itemBuilder: (BuildContext context) {
          return controlerList.getListofTipes().map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(
                choice,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: const Icon(
                Icons.add,
                size: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      drawer: (ResponsiveLayout.isDesktop(context))
          ? null
          : Drawer(
              backgroundColor: Theme.of(context).colorScheme.background,
              child: const CustamDrawer(
                actualPage: homePageTitle,
              ),
            ),
      body: ResponsiveLayout(
        key: UniqueKey(),
        mobile: _mobileViel(controlerList),
        tablet: _tabletViel(controlerList),
        desktop: _webViel(controlerList),
      ),
    );
  }

  Widget _mobileViel(ListController controlerList) {
    List<String> listTypes = controlerList.getListofTipes();
    return BasicTaskListViel(
      backward: () {
        setState(() {
          widget.index -= 1;
        });
      },
      forward: () {
        setState(() {
          widget.index += 1;
        });
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          if (widget.index > 0) {
            setState(() {
              widget.index -= 1;
            });
          }
        } else if (details.delta.dx < 0) {
          if (widget.index < (listTypes.length - 1)) {
            setState(() {
              widget.index += 1;
            });
          }
        }
      },
      key: UniqueKey(),
      index: widget.index,
      listTypes: listTypes,
    );
  }

  Widget _tabletViel(ListController controlerList) {
    return _listsView(controlerList);
  }

  Widget _webViel(ListController controlerList) {
    return Row(
      key: UniqueKey(),
      children: [
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
            child: const CustamDrawer(
              actualPage: homePageTitle,
            ),
          ),
        ),
        Expanded(child: _listsView(controlerList)),
      ],
    );
  }

  Scrollbar _listsView(ListController controlerList) {
    ScrollController scrollController = ScrollController();
    List<String> listTypes = controlerList.getListofTipes();
    return Scrollbar(
      key: UniqueKey(),
      thumbVisibility: true,
      trackVisibility: true,
      controller: scrollController,
      child: ListView.builder(
          key: UniqueKey(),
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: listTypes.length,
          itemBuilder: (context, index) {
            return Row(
              key: UniqueKey(),
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                    key: UniqueKey(),
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: BasicTaskListViel(
                      backward: () {},
                      forward: () {},
                      onHorizontalDragUpdate: (details) {},
                      key: UniqueKey(),
                      index: index,
                      listTypes: listTypes,
                    )),
                if (index != (listTypes.length - 1))
                  const VerticalDivider(
                    width: 0,
                  )
              ],
            );
          }),
    );
  }
}
