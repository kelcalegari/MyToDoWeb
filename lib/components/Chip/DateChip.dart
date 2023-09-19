import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app/ResponsiveLayout.dart';
import '../../constants.dart';
import '../funcions.dart';

class DateChip extends StatefulWidget {
  TextEditingController ctrl;
  double maxFontSize;
  double divScreen;
  bool isEditing;
  DateChip(
      {required this.ctrl,
      this.maxFontSize = 20,
      this.divScreen = 1,
      this.isEditing = true,
      super.key});

  @override
  State<DateChip> createState() => _DateChipState();
}

class _DateChipState extends State<DateChip> {
  DateTime? deadline;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / widget.divScreen;
    double maxFontSize = 20.0;
    double fontSize = screenWidth * 0.03;
    double finalFontSize = fontSize.clamp(0.0, maxFontSize);
    bool isPrazo = widget.ctrl.text.toLowerCase() == deadlineText.toLowerCase();
    return GestureDetector(
      onTap: () async {
        if (widget.isEditing) {
          DateTime? deadline = isPrazo
              ? DateTime.now()
              : DateFormat('HH:mm - dd/MM/yyyy').parse(widget.ctrl.text);
          deadline = await selectDate(context, deadline);
          if (deadline != null) {
            setState(() {
              widget.ctrl.text =
                  DateFormat('HH:mm - dd/MM/yyyy').format(deadline!);
            });
          }
        }
      },
      child: Chip(
        padding: (ResponsiveLayout.isMobile(context))?EdgeInsets.all(0): null,
        visualDensity: (ResponsiveLayout.isMobile(context))? VisualDensity.compact: VisualDensity.comfortable,
        label: Text(
          widget.ctrl.text,
          style: TextStyle(color: Colors.white, fontSize: finalFontSize),
        ),
        backgroundColor:
            isPrazo ? null : Colors.grey,
      ),
    );
  }
}
