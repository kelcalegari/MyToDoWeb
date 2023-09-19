/// The above class is a login screen implementation in Dart using the Flutter framework and Firebase
/// authentication.
// ignore_for_file: must_be_immutable, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/Button.dart';
import '../../components/Editor.dart';

import 'package:provider/provider.dart';
import '../../components/funcions.dart';
import '../../constants.dart';
import '../../services/firebase_auth_service.dart';
import 'Registration.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String emailError = "";
  String passwordError = "";

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      _emailController.text = email;
    }
    return Scaffold(
      body: Stack(
        key: UniqueKey(),
        alignment: Alignment.center,
        children: [
          Center(
            child: ConstrainedBox(
              key: UniqueKey(),
              constraints: const BoxConstraints(maxWidth: mobileWidth),
              child: Container(
                key: UniqueKey(),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // define a posição da sombra
                    ),
                  ],
                ),
                child: Form(
                  key: widget._formKey,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 50.0, bottom: 10.0),
                              child: SizedBox(
                                  width: 100.0,
                                  height: 100.0,
                                  child: Icon(
                                    Icons.task_alt,
                                    size: 100,
                                  )),
                            ),
                            const Text(
                              programName,
                              textScaleFactor: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 60.0, bottom: 10.0),
                              child: Editor(
                                ctrl: _emailController,
                                label: emailLabel,
                                icon: Icons.account_circle_outlined,
                                textInputType: TextInputType.emailAddress,
                                validador: _validateEmail,
                              ),
                            ),
                            Editor(
                              ctrl: _passwordController,
                              label: passwordLabel,
                              icon: Icons.lock,
                              textInputType: TextInputType.visiblePassword,
                              isPassword: true,
                              validador: _validatePassword,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 45.0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                      ),
                                      onPressed: () {
                                        _goToRegistration(context);
                                      },
                                      child: Text(
                                        registerButtonLabel,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    noAccountButtonLabel,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: Button(
                              btnText: loginButtonLabel,
                              onPressed: () {
                                _realizaLogin(context, _emailController.text,
                                    _passwordController.text);
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (widget.isLoading) _loadingIndicator()
        ],
      ),
    );
  }

  Container _loadingIndicator() {
    return Container(
      color: Colors.grey.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  String? _validateEmail(value) {
    if (value == null || value.isEmpty) {
      return emailRequiredMessage;
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return invalidEmailMessage;
    } else if (emailError != "") {
      return emailError;
    }

    return null;
  }

  String? _validatePassword(value) {
    if (value == null || value.isEmpty) {
      return passwordRequiredMessage;
    } else if (!isValidPassword(value)) {
      return incorrectPasswordMessage;
    } else if (passwordError != "") {
      return passwordError;
    }
    return null;
  }

  void _goToRegistration(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Registration()));
  }



  void _realizaLogin(
      BuildContext context, String email, String password) async {
    emailError = "";
    passwordError = "";

    if (widget._formKey.currentState!.validate()) {
      _chengeLoading();
      try {
        await context
            .read<FirebaseAuthService>()
            .signInFirebaseAuth(email, password);
      } on FirebaseAuthException catch (e) {
        final code = parseAuthExceptionMessage(input: e.message);

        if (e.code == 'user-not-found' || code == 'user-not-found') {
          emailError = userNotFoundMessage;
        } else if (e.code == 'wrong-password' || code == 'wrong-password') {
          passwordError = incorrectPasswordMessage;
        } else if (e.code == 'too-many-requests' ||
            code == 'too-many-requests') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(tooManyAttemptsMessage)));
        } else if (e.code == 'network-request-failed' ||
            code == 'network-request-failed') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text(noConnectionMessage)));
        } else {
          debugPrint("erro :${e.code}");
        }
        widget._formKey.currentState!.validate();
        _chengeLoading();
      } catch (a) {
        debugPrint(a.toString());
      }
    }
  }

  void _chengeLoading() {
    setState(() {
      widget.isLoading = !widget.isLoading;
    });
  }
}
