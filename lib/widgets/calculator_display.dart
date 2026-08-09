import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final String display;

  const CalculatorDisplay({Key? key, required this.display}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          display,
          style: const TextStyle(fontSize: 36),
        ),
      ),
    );
  }
}