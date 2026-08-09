import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Calculator App',
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '';

  void _onPressed(String value) {
    setState(() {
      if (value == '=') {
        try {
          _result = _calculate(_expression);
        } catch (e) {
          _result = 'Error';
        }
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
          .replaceAll('+', '+')
          .replaceAll('-', '-')
          .replaceAll('*', '*')
          .replaceAll('/', '/')
          .replaceAll('%', '%')
          .split('').map((e) => e.runtimeType == String ? e : '').join('');
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 48),
                  ),
                ],
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
                ElevatedButton(
                  onPressed: () => _onPressed('0'),
                  child: const Text('0'),
                ),
                ElevatedButton(
                  onPressed: () => _onPressed('.'),
                  child: const Text('.'),
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
                  onPressed: () => _onPressed('C'),
                  child: const Text('C'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}