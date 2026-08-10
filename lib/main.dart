import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final _controller = TextEditingController(text: '0');
  double _currentValue = 0;
  double _previousValue = 0;
  String _operation = '';

  void _onPressed(String value) {
    setState(() {
      if (value == '+' || value == '-' || value == '*' || value == '/') {
        _previousValue = double.parse(_controller.text);
        _operation = value;
        _controller.text = '0';
      } else if (value == '=') {
        double currentValue = double.parse(_controller.text);
        double result;
        switch (_operation) {
          case '+':
            result = _previousValue + currentValue;
            break;
          case '-':
            result = _previousValue - currentValue;
            break;
          case '*':
            result = _previousValue * currentValue;
            break;
          case '/':
            result = _previousValue / currentValue;
            break;
          default:
            result = 0;
        }
        _controller.text = result.toString();
      } else {
        if (_controller.text == '0') {
          _controller.text = value;
        } else {
          _controller.text += value;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              readOnly: true,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _onPressed('7'),
                  child: const Text('7'),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed('8'),
                  child: const Text('8'),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed('9'),
                  child: const Text('9'),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed('/'),
                  child: const Text('/'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _onPressed('4'),
                  child: const Text('4'),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed('5'),
                  child: const Text('5'),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed('6'),
                  child: const Text('6'),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed('*'),
                  child: const Text('*'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _onPressed('1'),
                  child: const Text('1'),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed('2'),
                  child: const Text('2'),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed('3'),
                  child: const Text('3'),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed('-'),
                  child: const Text('-'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _onPressed('0'),
                  child: const Text('0'),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed('='),
                  child: const Text('='),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed('+'),
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.text = '0';
                  },
                  child: const Text('C'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}