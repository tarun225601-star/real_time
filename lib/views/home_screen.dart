import 'package:calculator_app/controllers/calculator_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final calculatorController = Provider.of<CalculatorController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Number',
              ),
              onChanged: (value) {
                calculatorController.setFirstNumber(value);
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Second Number',
              ),
              onChanged: (value) {
                calculatorController.setSecondNumber(value);
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Operation',
              ),
              items: const [
                DropdownMenuItem(
                  child: Text('+'),
                  value: '+',
                ),
                DropdownMenuItem(
                  child: Text('-'),
                  value: '-',
                ),
                DropdownMenuItem(
                  child: Text('*'),
                  value: '*',
                ),
                DropdownMenuItem(
                  child: Text('/'),
                  value: '/',
                ),
              ],
              onChanged: (value) {
                calculatorController.setOperation(value as String);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculatorController.calculateResult();
              },
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 20),
            Text(
              'Result: ${calculatorController.result}',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}