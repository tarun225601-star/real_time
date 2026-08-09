import 'package:flutter/material.dart';
import 'package:simple_calculator/widgets/calculator_button.dart';
import 'package:simple_calculator/widgets/calculator_display.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _expression = '';
  String _result = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == '=') {
        _result = _calculate(_expression);
        _expression = '';
      } else if (value == 'C') {
        _expression = '';
        _result = '';
      } else {
        _expression += value;
      }
    });
  }

  String _calculate(String expression) {
    try {
      return expression
          .replaceAll(' ', '')
          .split('
')
          .map((element) => element
              .replaceAll('+', ' + ')
              .replaceAll('-', ' - ')
              .replaceAll('*', ' * ')
              .replaceAll('/', ' / ')
              .split(' ')
              .map((e) => double.parse(e))
              .reduce((value, element) {
                if (expression.contains('+')) {
                  return value + element;
                } else if (expression.contains('-')) {
                  return value - element;
                } else if (expression.contains('*')) {
                  return value * element;
                } else if (expression.contains('/')) {
                  return value / element;
                } else {
                  return 0;
                }
              }))
          .join('
');
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CalculatorDisplay(
            expression: _expression,
            result: _result,
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            childAspectRatio: 1.2,
            children: [
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '7',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '8',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '9',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '/',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '4',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '5',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '6',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '*',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '1',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '2',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '3',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '-',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '0',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '.',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '=',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: '+',
              ),
              CalculatorButton(
                onPressed: _onButtonPressed,
                value: 'C',
              ),
            ],
          ),
        ],
      ),
    );
  }
}