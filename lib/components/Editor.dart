// ignore_for_file: file_names, no_logic_in_create_state

import 'package:flutter/material.dart';


class Editor extends StatefulWidget {
  final TextEditingController ctrl;
  final String? label;
  final String? hint;
  final IconData? icon;
  final TextInputType textInputType;
  final bool isPassword;
  final double pad;
  final int maxLength;
  final int maxLines;
  final double fontSize;
  final String? Function(String?)? validador;
  final FocusNode? focusNode;
  final void Function()? onComplete;
  final void Function(PointerDownEvent)? onTapOutside;

  const Editor({
    super.key,
    required this.ctrl,
    this.label,
    this.hint,
    required this.textInputType,
    this.icon,
    this.isPassword = false,
    this.pad = 35,
    this.maxLength = -1,
    this.maxLines = 1,
    this.fontSize = 20,
    this.validador,
    this.focusNode,
    this.onComplete,
    this.onTapOutside
  });
  @override
  State<StatefulWidget> createState() {
    return EditorState(
      ctrl: ctrl,
      label: label,
      hint: hint,
      icon: icon,
      textInputType: textInputType,
      isPassword: isPassword,
      pad: pad,
      maxLength: maxLength,
      maxLines: maxLines,
      fontSize: fontSize,
      validador: validador,
    );
  }
}

class EditorState extends State<Editor> {
  final TextEditingController ctrl;
  final String? label;
  final String? hint;
  final IconData? icon;
  final TextInputType textInputType;
  final bool isPassword;
  final double pad;
  final int maxLength;
  final int maxLines;
  final fontSize;
  final String? Function(String?)? validador;
  bool _passVisible = false;

  EditorState({
    required this.ctrl,
    this.label,
    this.hint,
    required this.textInputType,
    this.icon,
    required this.isPassword,
    required this.pad,
    required this.maxLength,
    required this.maxLines,
    required this.fontSize,
    this.validador,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: pad, right: pad),
      child: TextFormField(
        focusNode: widget.focusNode,
        textCapitalization:
            isPassword ? TextCapitalization.none : TextCapitalization.sentences,
        maxLength: maxLength > 0 ? maxLength : null,
        validator: validador,
        maxLines: maxLines,
        controller: ctrl,
        style: TextStyle(fontSize: fontSize),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: isPassword != false
              ? IconButton(
                  icon: Icon(
                    _passVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onPressed: () {
                    setState(() {
                      _passVisible = !_passVisible;
                    });
                  },
                )
              : null,
        ),
        keyboardType: textInputType,
        obscureText: !_passVisible && isPassword,
        onEditingComplete: widget.onComplete,
        onTapOutside: widget.onTapOutside,
      ),
    );
  }
}
