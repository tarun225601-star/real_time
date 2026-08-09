import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final String _expression;
  final String _result;

  const CalculatorDisplay({Key? key, required String expression, required String result})
      : _expression = expression,
        _result = result,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            _expression,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(
            _result,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}