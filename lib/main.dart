import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _output = '0';
  double _num1 = 0.0;
  double _num2 = 0.0;
  String _operand = '';

  void _buttonPressed(String buttonText) {
    if (buttonText == 'C') {
      _output = '0';
      _num1 =.0;
      _num2 =.0;
      _operand = '';
    } else if (buttonText == '+' || buttonText == '-' || buttonText == '*' || buttonText == '/') {
      _num1 = double.parse(_output);
      _operand = buttonText;
      _output = '0';
    } else if (buttonText == '.') {
      if (_output.contains('.')) {
        return;
      }
      _output += buttonText;
    } else if (buttonText == '=') {
      _num2 = double.parse(_output);

      if (_operand == '+') {
        _output = (_num1 + _num2).toString();
      } else if (_operand == '-') {
        _output = (_num1 - _num2).toString();
      } else if (_operand == '*') {
        _output = (_num1 * _num2).toString();
      } else if (_operand == '/') {
        _output = (_num1 / _num2).toString();
      }

      _num1 =.0;
      _num2 =.0;
      _operand = '';
    } else {
      _output = _output == '0' ? buttonText : _output + buttonText;
    }

    setState(() {});
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              child: Text(
                _output,
                style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Divider(),
            ),
            Column(children: [
              Row(children: [
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('/'),
              ]),
              Row(children: [
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('*'),
              ]),
              Row(children: [
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('-'),
              ]),
              Row(children: [
                _buildButton('.'),
                _buildButton('0'),
                _buildButton('C'),
                _buildButton('+'),
              ]),
              Row(children: [
                _buildButton('='),
              ]),
            ])
          ],
        ),
      ),
    );
  }
}