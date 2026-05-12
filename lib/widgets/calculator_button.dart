import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final VoidCallback onPressed;
  final bool isWide;

  const CalculatorButton({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    required this.onPressed,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isWide ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: color ?? Colors.grey[850],
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 75,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
