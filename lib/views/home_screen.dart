import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculator_app/providers/calculator_provider.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _expressionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final calculatorProvider = Provider.of<CalculatorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _expressionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter expression',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                calculatorProvider.calculateExpression(_expressionController.text);
              },
              child: Text('Calculate'),
            ),
            SizedBox(height: 16),
            Text(
              calculatorProvider.calculatorModel.expression,
              style: TextStyle(fontSize: 24),
            ),
            Text(
              calculatorProvider.calculatorModel.result,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}