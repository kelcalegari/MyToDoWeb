import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String btnText;
  final VoidCallback onPressed;
  final double pad;
  final double height;
  final double width;

  const Button({
    Key? key,
    required this.btnText,
    required this.onPressed,
    this.pad = 35,
    this.height = 60,
    this.width = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: pad, right: pad),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: height,
              width: width,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(
                  btnText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
