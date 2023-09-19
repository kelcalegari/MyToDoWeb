import 'package:flutter/material.dart';


import '../../app/ResponsiveLayout.dart';
import '../../constants.dart';
import '../funcions.dart';

class PrioriedadeChip extends StatefulWidget {
  TextEditingController ctrl;
  double divScreen;
  bool isEditing;
  PrioriedadeChip(
      {required this.ctrl,
      this.divScreen = 1,
      this.isEditing = true,
      super.key});

  @override
  State<PrioriedadeChip> createState() => _PrioriedadeChipState();
}

class _PrioriedadeChipState extends State<PrioriedadeChip> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / widget.divScreen;
    double maxFontSize = 20.0;
    double fontSize = screenWidth * 0.03;
    double finalFontSize = fontSize.clamp(0.0, maxFontSize);

    return GestureDetector(
      onTap: () async {
        if (widget.isEditing) {
          String? temp =
              await showPopUp(context, widget.ctrl.text, priorityOpts);

          if (temp != null) {
            setState(() {
              widget.ctrl.text = temp;
            });
          }
        }
      },
      child: Chip(
        padding:
            (ResponsiveLayout.isMobile(context)) ? EdgeInsets.all(0) : null,
        visualDensity: (ResponsiveLayout.isMobile(context))
            ? VisualDensity.compact
            : VisualDensity.comfortable,
        label: Text(
          widget.ctrl.text,
          style: TextStyle(color: Colors.white, fontSize: finalFontSize),
        ),
        backgroundColor: getColorFromPriority(widget.ctrl.text),
      ),
    );
  }
}
