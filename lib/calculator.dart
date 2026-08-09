import 'package:flutter/material.dart';
import 'package:simple_calculator/widgets/calculator_button.dart';
import 'package:simple_calculator/widgets/calculator_display.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _display = '';
  String _result = '';
  String _operator = '';
  double _num1 = 0;
  double _num2 = 0;

  void _onClick(String value) {
    if (value == '+' || value == '-' || value == '*' || value == '/') {
      _num1 = double.parse(_display);
      _operator = value;
      _display = '';
    } else if (value == '=') {
      _num2 = double.parse(_display);
      switch (_operator) {
        case '+':
          _result = (_num1 + _num2).toString();
          break;
        case '-':
          _result = (_num1 - _num2).toString();
          break;
        case '*':
          _result = (_num1 * _num2).toString();
          break;
        case '/':
          _result = (_num1 / _num2).toString();
          break;
      }
      _display = _result;
    } else if (value == 'C') {
      _display = '';
      _result = '';
      _operator = '';
      _num1 = 0;
      _num2 = 0;
    } else {
      _display += value;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CalculatorDisplay(display: _display),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.2,
              children: [
                CalculatorButton(value: '7', onClick: _onClick),
                CalculatorButton(value: '8', onClick: _onClick),
                CalculatorButton(value: '9', onClick: _onClick),
                CalculatorButton(value: '/', onClick: _onClick),
                CalculatorButton(value: '4', onClick: _onClick),
                CalculatorButton(value: '5', onClick: _onClick),
                CalculatorButton(value: '6', onClick: _onClick),
                CalculatorButton(value: '*', onClick: _onClick),
                CalculatorButton(value: '1', onClick: _onClick),
                CalculatorButton(value: '2', onClick: _onClick),
                CalculatorButton(value: '3', onClick: _onClick),
                CalculatorButton(value: '-', onClick: _onClick),
                CalculatorButton(value: '0', onClick: _onClick),
                CalculatorButton(value: '.', onClick: _onClick),
                CalculatorButton(value: '=', onClick: _onClick),
                CalculatorButton(value: '+', onClick: _onClick),
                CalculatorButton(value: 'C', onClick: _onClick),
              ],
            ),
          ),
        ],
      ),
    );
  }
}