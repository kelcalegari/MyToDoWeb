import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mytodoweb/services/ListController.dart';
import 'package:mytodoweb/services/firebase_auth_service.dart';





import 'app/app.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';



Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();

WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    Provider(
      create: (_) => FirebaseAuthService(),
    ),

    ChangeNotifierProvider(
      create: (context) => ListController(context.read),

    ),
    StreamProvider(
      create: (context) => context.read<FirebaseAuthService>().authStateChanges,
      initialData: null,
    ),
  ], child: const MyToDo()));
}


