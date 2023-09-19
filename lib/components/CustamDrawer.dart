import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../app/config/Configuracao.dart';
import '../app/Home.dart';
import '../app/ResponsiveLayout.dart';

import '../app/tasks/BasicTaskView.dart';
import '../constants.dart';
import '../models/Account.dart';
import '../services/ListController.dart';
import '../services/firebase_auth_service.dart';
import 'Button.dart';

class CustamDrawer extends StatelessWidget {
  final VoidCallback? onPressed;
  final String labelButton;
  final String actualPage;
  const CustamDrawer(
      {this.onPressed, this.actualPage = "", this.labelButton = "", super.key});

  @override
  Widget build(BuildContext context) {

    Account user = context.read<FirebaseAuthService>().userAtual;
    List<String> listTypes = context.read<ListController>().getListofTipes();
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        if (ResponsiveLayout.isNotDesktop(context))
          UserAccountsDrawerHeader(
            accountName: Text(user.name ?? ""),
            accountEmail: Text(user.eMail ?? ""),
            currentAccountPicture: const CircleAvatar(
              child: Icon(
                Icons.person,
                size: 56,
                color: Colors.white,
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/userProfileBg.jpg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ListTile(
            leading: Icon(Icons.home,
                color: (actualPage == homePageTitle)
                    ? const Color(tertiaryColor)
                    : null),
            title: Text(
              homePageTitle,
              style: (actualPage == homePageTitle)
                  ? const TextStyle(color: Color(tertiaryColor))
                  : null,
            ),
            enabled: actualPage != homePageTitle,
            onTap: () {

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => Home(),
                  transitionDuration: const Duration(seconds: 0),
                ),
              );

            }),

        ListView.builder(
            shrinkWrap: true,
            itemCount: listTypes.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: Icon(iconsList[context
                      .read<ListController>()
                      .configUser
                      .configLists[index]['icone']], color: (actualPage == listTypes[index])
                      ? const Color(tertiaryColor)
                      : null),
                  title: Text('$taskText ${listTypes[index]}',
                    style: (actualPage == listTypes[index])
                        ? const TextStyle(color: Color(tertiaryColor))
                        : null,
                  ),
                  enabled: actualPage != listTypes[index],
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => BasicTaskView(currentType: listTypes[index]),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                    );
                  });
            }),

        if (ResponsiveLayout.isNotDesktop(context))
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(configText),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Settings()));
            },
          ),
        if ((ResponsiveLayout.isDesktop(context)) && (labelButton != ""))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Button(
                height: 40,
                btnText: labelButton,
                pad: 0,
                onPressed: onPressed ?? () {}),
          )
      ],
    );
  }
}
