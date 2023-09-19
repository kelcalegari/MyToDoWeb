import '../../components/Button.dart';
import '../../components/Editor.dart';
import '../../components/funcions.dart';
import '../../constants.dart';
import '../../models/Account.dart';
import '../../services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app.dart';

class UpdateAccount extends StatefulWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String emailError = "";
  String passwordError = "";
  bool isLoading = false;
  late Account user;

  UpdateAccount({super.key});

  @override
  State<UpdateAccount> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  @override
  Widget build(BuildContext context) {
    widget.user = context.read<FirebaseAuthService>().userAtual;
    widget.nameController.text = widget.user.name!;
    widget.emailController.text = widget.user.eMail!;

    return Stack(children: [
      SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: mobileWidth),
            child: Form(
              key: widget._formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, left: 35, right: 35),
                    child: Row(
                      children: [
                        const Text(
                          accountText,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            context.read<FirebaseAuthService>().signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyToDo()),
                            );
                          },
                          label: const Text(logoutText),
                          icon: const Icon(Icons.logout),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onBackground),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
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
                      ctrl: widget.currentPasswordController,
                      label: currentPasswordText,
                      textInputType: TextInputType.visiblePassword,
                      isPassword: true,
                      validador: _validateCurrentPassword,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Editor(
                      ctrl: widget.passwordController,
                      label: passwordLabel,
                      textInputType: TextInputType.visiblePassword,
                      isPassword: true,
                      validador: _validateNewPassword,
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
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Button(
                      btnText: saveText,
                      onPressed: () => _updateUserData(
                          context,
                          widget.emailController.text,
                          widget.currentPasswordController.text,
                          widget.nameController.text,
                          (widget.passwordController.text != "")
                              ? widget.passwordController.text
                              : null),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      if (widget.isLoading) _loadingIndicator()
    ]);
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
    } else if (widget.emailError != "") {
      return widget.emailError;
    }

    return null;
  }



  String? _validateCurrentPassword(value) {
    if (value == null || value.isEmpty) {
      return passwordRequiredMessage;
    } else if (!isValidPassword(value)) {
      return incorrectPasswordMessage;
    }
    return null;
  }

  String? _validateNewPassword(value) {
    if (value == null || value.isEmpty) {
      return null;
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

  Future<void> _updateUserData(BuildContext context, String eMail,
      String password, String name, String? newPassword) async {
    widget.emailError = "";
    widget.passwordError = "";

    if (widget._formKey.currentState!.validate()) {
      _chengeLoading();
      try {
        await context
            .read<FirebaseAuthService>()
            .updateAccountData(name, eMail, password, newPassword);
        widget.currentPasswordController.text="";
        widget.passwordController.text="";
        widget.rePasswordController.text="";
        _chengeLoading();
      } on FirebaseAuthException catch (e) {
        final code = parseAuthExceptionMessage(input: e.message);
        if (code == 'weak-password' || e.code == 'weak-password') {
          widget.passwordError = weakPasswordMessage;
        } else if (code == 'wrong-password' || e.code == 'wrong-password') {
          widget.passwordError = incorrectPasswordMessage;
        } else if (code == 'email-already-in-use' ||
            e.code == 'email-already-in-use') {
          widget.emailError = emailExistsMessage;
        } else if (code == 'invalid-email' || e.code == 'invalid-email') {
          widget.emailError = invalidEmailMessage;
        } else if (code == 'too-many-requests' ||
            e.code == 'too-many-requests') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(tooManyAttemptsMessage)));
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
      widget.user = context.read<FirebaseAuthService>().userAtual;
    });
  }
}
