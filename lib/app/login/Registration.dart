// ignore_for_file: file_names
import '../../services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../components/Button.dart';
import '../../components/Editor.dart';
import '../../components/funcions.dart';
import '../../constants.dart';

import '../Home.dart';
import 'Login.dart';

class Registration extends StatefulWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String emailError = "";
  String passwordError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: mobileWidth),
              child: Container(
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
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Editor(
                                ctrl: widget.nameController,
                                label: nameLabel,
                                textInputType: TextInputType.name,
                                validador: validateName,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Editor(
                                ctrl: widget.emailController,
                                label: emailLabel,
                                textInputType: TextInputType.emailAddress,
                                validador: _validateEmail,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Editor(
                                ctrl: widget.passwordController,
                                label: passwordLabel,
                                textInputType: TextInputType.visiblePassword,
                                isPassword: true,
                                validador: _validatePassword,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Editor(
                                ctrl: widget.rePasswordController,
                                label: rePasswordLabel,
                                textInputType: TextInputType.visiblePassword,
                                isPassword: true,
                                validador: _validateRePassword,
                              ),
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
                                        textStyle:
                                            const TextStyle(fontSize: 20),
                                      ),
                                      onPressed: () => _performLogin(context),
                                      child: Text(
                                        loginButtonLabel,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    haveAccountButtonLabel,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
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
                              btnText: registerButtonLabel,
                              onPressed: () => _performRegistration(
                                  context,
                                  widget.emailController.text,
                                  widget.passwordController.text,
                                  widget.nameController.text),
                            ),
                          ),
                        ),
                      ),
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
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _performLogin(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
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
    }
    return null;
  }

  String? _validateRePassword(value) {
    if (value != widget.passwordController.text) {
      return passwordMismatchMessage;
    }

    return null;
  }

  Future<void> _performRegistration(
      BuildContext context, String eMail, String password, String name) async {
    emailError = "";
    passwordError = "";

    if (widget._formKey.currentState!.validate()) {
      _chengeLoading();
      try {
        await context
            .read<FirebaseAuthService>()
            .cadastroInFirebaseAuth(name, eMail, password);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false,
        );
      } on FirebaseAuthException catch (e) {
        final code = parseAuthExceptionMessage(input: e.message);
        if (code == 'weak-password' || e.code == 'weak-password') {
          passwordError = weakPasswordMessage;
        } else if (code == 'email-already-in-use' ||
            e.code == 'email-already-in-use') {
          emailError = emailExistsMessage;
        } else if (code == 'invalid-email' || e.code == 'invalid-email') {
          emailError = invalidEmailMessage;
        } else if (code == 'network-request-failed' ||
            e.code == 'network-request-failed') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text(noConnectionMessage)));
        } else {
          debugPrint("erro :${e.code}");
        }
        widget._formKey.currentState!.validate();
        _chengeLoading();
      }
    }
  }

  void _chengeLoading() {
    setState(() {
      widget.isLoading = !widget.isLoading;
    });
  }
}
