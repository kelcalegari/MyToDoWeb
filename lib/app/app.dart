import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/Account.dart';
import 'Home.dart';
import 'login/Login.dart';

class MyToDo extends StatelessWidget {
  const MyToDo({super.key});

  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      home: Consumer<Account?>(
        builder: (_, user, __) {
          if (user == null) {
            return Login();
          } else {
            return Home();
          }
        },
      ),
      theme: lightTheme,
      darkTheme: darkTheme,
    );
    return materialApp;
  }
}
