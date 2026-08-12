import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Simple Calculator',
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({Key? key}) : super(key: key);

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  final _textController = TextEditingController(text: '0');
  double? _currentValue;
  String? _operator;
  double? _previousValue;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _textController.text = '0';
        _currentValue = null;
        _operator = null;
        _previousValue = null;
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        _previousValue = double.parse(_textController.text);
        _operator = value;
        _textController.text = '0';
      } else if (value == '=') {
        if (_previousValue != null && _operator != null) {
          double result;
          switch (_operator) {
            case '+':
              result = _previousValue! + double.parse(_textController.text);
              break;
            case '-':
              result = _previousValue! - double.parse(_textController.text);
              break;
            case '*':
              result = _previousValue! * double.parse(_textController.text);
              break;
            case '/':
              if (double.parse(_textController.text) != 0) {
                result = _previousValue! / double.parse(_textController.text);
              } else {
                _textController.text = 'Error';
                return;
              }
              break;
            default:
              result = 0;
          }
          _textController.text = result.toStringAsFixed(2);
          _previousValue = null;
          _operator = null;
        }
      } else {
        if (_textController.text == '0') {
          _textController.text = value;
        } else {
          _textController.text += value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _textController,
                enabled: false,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.2,
              children: [
                ElevatedButton(
                  onPressed: () => _onButtonPressed('7'),
                  child: const Text('7', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('8'),
                  child: const Text('8', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('9'),
                  child: const Text('9', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('/'),
                  child: const Text('/', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('4'),
                  child: const Text('4', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('5'),
                  child: const Text('5', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('6'),
                  child: const Text('6', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('*'),
                  child: const Text('*', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('1'),
                  child: const Text('1', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('2'),
                  child: const Text('2', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('3'),
                  child: const Text('3', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('-'),
                  child: const Text('-', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('0'),
                  child: const Text('0', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('.'),
                  child: const Text('.', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('='),
                  child: const Text('=', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('+'),
                  child: const Text('+', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: () => _onButtonPressed('C'),
                  child: const Text('C', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
